package com.yinse.flutter_app

//import com.umeng.analytics.MobclickAgent
//import com.umeng.commonsdk.UMConfigure.getTestDeviceInfo
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.net.*
import android.net.wifi.p2p.WifiP2pManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.annotation.RequiresApi
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.NativePlugin
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import java.net.InetAddress
import java.net.UnknownHostException
import java.util.*


class MainActivity : FlutterActivity() {


  //这个跟flutter的通道名称保持一直
  private val CHANNEL = "samples.flutter.io/requestApi"

  //定义flutter端调用Android原生方法的channelMethod
  private val channelMethod = "requestApi"

  //flutter对Android端的传参
  private val hostArgument = "host"
  private val pathArgument = "path"
  private val methodArgument = "method"
  private val queryParametersArgument = "queryParameters"
  private val headersArgument = "headers"
  private val extraArgument="extra"
  private val parametersArgument="parameters"
  private val bodyParametersArgumentsKey = "bodyParameters"
  private val dnsIpArgument="dnsIp"


  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    registerCustomPlugin(this)
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
      //这里是判断是不是调getIP方法，因为所有的方法都走这里
      if (methodCall.method.equals(channelMethod)) {
        var path = ""
        var params = HashMap<String,Object>()
        var headersParams = HashMap<String,Object>()
        var bodyParams = HashMap<String,Object>()
        if (methodCall.hasArgument(hostArgument) && methodCall.hasArgument(pathArgument) && methodCall.hasArgument(queryParametersArgument) ) {
          try {
            //取出从flutter端传递的host参数
            val hostArgument: String? = methodCall.argument(hostArgument)
            val pathArgument: String? = methodCall.argument(pathArgument)
            val methodArgument: String? = methodCall.argument(methodArgument)
            val queryParametersArgument: HashMap<String,Object>? = methodCall.argument(queryParametersArgument)
            var headersArgument:HashMap<String,Object>? = methodCall.argument(headersArgument)
            var extraArgument:HashMap<String,Object>? = methodCall.argument(extraArgument)
            var parametersArgument:HashMap<String,Object>? = methodCall.argument(parametersArgument)
            var bodyParametersArgument:HashMap<String,Object>? = methodCall.argument(bodyParametersArgumentsKey)
            var dnsValue:String? = methodCall.argument(dnsIpArgument)

            if(queryParametersArgument!=null){
              params = queryParametersArgument
            }
            if(pathArgument!=null){
              path = pathArgument
            }
            if(headersArgument!=null){
              headersParams = headersArgument
            }
            if (hostArgument != null) {
              RequestManager.HOST = hostArgument
            }
            if(bodyParametersArgument!=null){
              bodyParams = bodyParametersArgument
            }
            GlobalScope.launch (CoroutineName("网络请求")){
              var value = ""
              when(methodArgument){
                "POST" ->{
                  value = RequestManager.getInstance(this@MainActivity,dnsValue)?.requestSyn(path,RequestManager.TYPE_POST_JSON,bodyParams,headersParams).toString()
                }
                "GET" ->{
                  value =  RequestManager.getInstance(this@MainActivity,dnsValue)?.requestSyn(path,RequestManager.TYPE_GET,params,headersParams).toString()
                }
              }
              runOnUiThread {
                result.success(value)
              }
            }
          } catch (e: Exception) {
            e.printStackTrace()
          }
        }
      }
    }

  }

  private fun registerCustomPlugin(registry: PluginRegistry) {
    NativePlugin.registerWith(registry.registrarFor(NativePlugin.CHANNEL))
  }

  override fun onResume() {
    super.onResume()
    //MobclickAgent.onResume(this)
  }

  override fun onPause() {
    super.onPause()
    //MobclickAgent.onPause(this)
  }

}
