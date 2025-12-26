package ai.faturamatik.flutter_faturamatik


import android.app.Activity
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



class FlutterFaturamatikSDKPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  private var channel: MethodChannel? = null
  private var delegateChannel: EventChannel? = null
  private val delegateHandler = FaturamatikDelegateEventHandler()

  private var activity: Activity? = null
  private val mainHandler = Handler(Looper.getMainLooper())

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
    pendingStartResult = null
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "startKYC" -> startKyc(result)
      else -> result.notImplemented()
    }
  }

  private fun startKyc(result: MethodChannel.Result) {
    
    val act = activity
    if (act == null) {
      result.error("NO_ACTIVITY", "Plugin is not attached to an Activity.", null)
      return
    }

    if (pendingStartResult != null) {
      result.error("ALREADY_RUNNING", "KYC flow is already running.", null)
      return
    }

    pendingStartResult = result

    try {
      val config = KycConfig() // [Inference] Config alanlarını bilmiyorsak boş başlatıyoruz

      KycSdk.startLiveness(
        act,
        config,
        object : KycCallback {
          override fun onSuccess(r: KycResult) {
           
              val payload = mapOf(
                "event" to "kyc_result",
                "success" to r.success,
                "reason" to r.reason
              )
              delegateHandler.emit(payload)
              pendingStartResult?.success(payload)
              pendingStartResult = null
            
          }

          override fun onError(code: String, message: String) {
           
              val payload = mapOf(
                "event" to "kyc_error",
                "code" to code,
                "message" to message
              )
              delegateHandler.emit(payload)
              pendingStartResult?.success(payload)
              pendingStartResult = null
           
          }

          override fun onCancelled() {
            
              val payload = mapOf("event" to "kyc_cancelled")
              delegateHandler.emit(payload)
              pendingStartResult?.success(payload)
              pendingStartResult = null
            
          }
        }
      )
    } catch (t: Throwable) {
      pendingStartResult = null
      result.error("START_FAILED", t.message, null)
    }
  }

  // ActivityAware
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    activity = null
    pendingStartResult = null
  }
}