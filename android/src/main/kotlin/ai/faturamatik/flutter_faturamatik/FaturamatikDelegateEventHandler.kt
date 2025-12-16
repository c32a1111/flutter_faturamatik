package ai.faturamatik.flutter_faturamatik

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.EventChannel

class FaturamatikDelegateEventHandler: EventChannel.StreamHandler {

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Handler(Looper.getMainLooper()).post {
           
        }
    }

    override fun onCancel(arguments: Any?) {
    }
}