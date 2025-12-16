package ai.faturamatik.flutter_faturamatik


import android.app.Activity
import io.flutter.Log
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
import 
import com.oda.kyc.KycConfig

/** FlutterAmanisdkPlugin */
class FlutterFaturamatikSDKPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var nfcChannel: MethodChannel
  private lateinit var bioLoginChannel: MethodChannel
  private lateinit var delegateChannel: EventChannel
  // Give this reference to other modules e.g IdCapture when init.
  private var activity: Activity? = null

   private val delegateHandler = FaturamatikDelegateEventHandler()
  private val mainHandler = Handler(Looper.getMainLooper())

  // startKYC async olduğu için method result'ını saklıyoruz (tek seferde 1 akış)
  private var pendingStartKycResult: MethodChannel.Result? = null

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "faturamatiksdk_method_channel").also {
      it.setMethodCallHandler(this)
    }

    // Eğer gerçekten ayrı handler’lar kullanacaksan bunları da init et:
    nfcChannel = MethodChannel(binding.binaryMessenger, "faturamatiksdk_nfc_channel")
    bioLoginChannel = MethodChannel(binding.binaryMessenger, "faturamatiksdk_biologin_channel")

    delegateChannel = EventChannel(binding.binaryMessenger, "amanisdk_delegate_channel").also {
      // Stream handler’ını gerçekten kullanacaksan uncomment et:
      // it.setStreamHandler(FaturamatikDelegateEventHandler())
      it.setStreamHandler(null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)

    delegateChannel?.setStreamHandler(null)
  }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "startKYC" -> startKyc(call, result)
      else -> result.notImplemented()
    }
  }

   private fun startKyc(call: MethodCall, result: MethodChannel.Result) {
    val act = activity
    if (act == null) {
      result.error("NO_ACTIVITY", "Plugin is not attached to an Activity.", null)
      return
    }

    if (pendingStartKycResult != null) {
      result.error("ALREADY_RUNNING", "KYC flow is already running.", null)
      return
    }

    pendingStartKycResult = result

    try {
      // TODO: Eğer Dart'tan config alacaksan:
      // val args = call.arguments as? Map<String, Any?>
      // val config = KycConfig().apply { ... }
      val config = KycConfig()

      KycSdk.startLiveness(
        act,
        config,
        object : KycCallback {
          override fun onSuccess(r: KycResult) {
            // TODO: r içinden döndüreceğin alanları map'e koy
            val payload = mapOf(
              "type" to "success"
              // "data" to ...
            )

            mainHandler.post {
              delegateHandler.emitSuccess(payload)
              pendingStartKycResult?.success(payload)
              pendingStartKycResult = null
            }
          }

          override fun onError(code: String, message: String) {
            mainHandler.post {
              delegateHandler.emitError(code, message)
              pendingStartKycResult?.error(code, message, null)
              pendingStartKycResult = null
            }
          }

          override fun onCancelled() {
            mainHandler.post {
              delegateHandler.emitCancelled()
              pendingStartKycResult?.success(mapOf("type" to "cancelled"))
              pendingStartKycResult = null
            }
          }
        }
      )
    } catch (t: Throwable) {
      pendingStartKycResult = null
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
  }

}