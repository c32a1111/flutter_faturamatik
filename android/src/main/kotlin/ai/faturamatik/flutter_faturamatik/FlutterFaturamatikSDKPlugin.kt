package ai.faturamatik.flutter_faturamatik


import android.app.Activity
import android.app.Application
import android.os.Bundle
import io.flutter.Log
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.kyc.sdk.core.KycSdk
import com.kyc.sdk.core.KycConfig
import com.kyc.sdk.core.KycCallback
import com.kyc.sdk.result.KycResult
import java.util.Collections
import java.util.WeakHashMap


class FlutterFaturamatikSDKPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private var channel: MethodChannel? = null
  private var delegateChannel: EventChannel? = null
  private val delegateHandler = FaturamatikDelegateEventHandler()

  private var activity: Activity? = null
  private val mainHandler = Handler(Looper.getMainLooper())

  private val kycActivities =
  Collections.newSetFromMap(WeakHashMap<Activity, Boolean>())

  private var lifecycleCallbacks: Application.ActivityLifecycleCallbacks? = null

  // startKYC async -> MethodChannel result’ını bekletmek için
  private var pendingStartResult: MethodChannel.Result? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "faturamatiksdk_method_channel").also {
      it.setMethodCallHandler(this)
    }

    delegateChannel = EventChannel(binding.binaryMessenger, "faturamatiksdk_delegate_channel").also {
      it.setStreamHandler(delegateHandler)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
    channel = null

    delegateChannel?.setStreamHandler(null)
    delegateChannel = null

    delegateHandler.clear()
    
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
   when (call.method) {
    "startKYC" -> startKyc(result)
    "closeKYC" -> {
      closeKycUi()
      result.success(true)
    }
    else -> result.notImplemented()
    }
  }

private var isKycRunning = false 

private fun startKyc(result: MethodChannel.Result) {
  val act = activity
  if (act == null) {
    result.error("NO_ACTIVITY", "Plugin is not attached to an Activity.", null)
    return
  }

  if (isKycRunning) {
    result.error("ALREADY_RUNNING", "KYC flow is already running.", null)
    return
  }

  isKycRunning = true

  try {
    val config = KycConfig()

    KycSdk.startLiveness(
      act,
      config,
      object : KycCallback {

        override fun onSuccess(r: KycResult) {
          isKycRunning = false
          delegateHandler.emit(
            mapOf(
              "event" to "kyc_result",
              "success" to r.success,
              "message" to r.message
            )
          )
        }

        override fun onError(code: String, message: String) {
          isKycRunning = false
          delegateHandler.emit(
          mapOf(
            "event" to "kyc_error",
            "code" to code,      // string
            "message" to message
          )
        )
      }

      override fun onCancelled() {
          isKycRunning = false
          delegateHandler.emit(mapOf("event" to "kyc_cancelled"))
        }
      }
    )

    
    result.success(true)

  } catch (t: Throwable) {
    isKycRunning = false
    result.error("START_FAILED", t.message, null)
  }
}


  // ActivityAware
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    registerKycActivityTracker(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activity?.let { unregisterKycActivityTracker(it) }
    activity = null
    isKycRunning = false
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  private fun isKycSdkActivity(a: Activity): Boolean {
  val name = a.javaClass.name
  return name.startsWith("com.kyc.sdk.") // gerekirse değiştir
  }


  private fun registerKycActivityTracker(hostActivity: Activity) {
  if (lifecycleCallbacks != null) return

  val app = hostActivity.application

  lifecycleCallbacks = object : Application.ActivityLifecycleCallbacks {
    override fun onActivityCreated(a: Activity, savedInstanceState: Bundle?) {
      if (isKycSdkActivity(a)) kycActivities.add(a)
    }

    override fun onActivityResumed(a: Activity) {
      if (isKycSdkActivity(a)) kycActivities.add(a)
    }

    override fun onActivityDestroyed(a: Activity) {
      kycActivities.remove(a)
    }

    override fun onActivityStarted(a: Activity) {}
    override fun onActivityPaused(a: Activity) {}
    override fun onActivityStopped(a: Activity) {}
    override fun onActivitySaveInstanceState(a: Activity, outState: Bundle) {}
  }

  app.registerActivityLifecycleCallbacks(lifecycleCallbacks)
}

private fun unregisterKycActivityTracker(hostActivity: Activity) {
  val cb = lifecycleCallbacks ?: return
  hostActivity.application.unregisterActivityLifecycleCallbacks(cb)
  lifecycleCallbacks = null
  kycActivities.clear()
}

private fun closeKycUi() {
  mainHandler.post {
    try {
      val cls = Class.forName("com.kyc.sdk.session.KycSession")
      cls.getMethod("clear").invoke(null)
    } catch (_: Throwable) {}

    
    val snapshot = kycActivities.toList()
    snapshot.forEach { a ->
      try {
        if (!a.isFinishing && !a.isDestroyed) a.finish()
      } catch (_: Throwable) {}
    }
    kycActivities.clear()

    isKycRunning = false
  }
}


}