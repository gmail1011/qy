package io.flutter.plugins;

import android.app.Activity;

import android.content.Context;
import android.util.Log;

import com.meituan.android.walle.WalleChannelReader;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

///泡芙本地插件
public class NativePlugin implements MethodChannel.MethodCallHandler {

  public static String CHANNEL = "com.yinse/device";

  static MethodChannel methodChannel;

  private Activity activity;

  private NativePlugin(Activity activity) {
    this.activity = activity;
  }

  /// 注册
  public static void registerWith(PluginRegistry.Registrar registrar) {
    methodChannel = new MethodChannel(registrar.messenger(), CHANNEL);
    NativePlugin instance = new NativePlugin(registrar.activity());
    methodChannel.setMethodCallHandler(instance);
  }

  /// 调用
  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {
    if (call.method.equals("getDeviceId")) {
      result.success(DeviceUtils.getUniqueId(activity));
    } else if (call.method.equals("getMimeType")) {
      result.success(FileUtils.getMimeType(call.argument("filePath")));
    } else if (call.method.equals("getVideoDuration")) {
      result.success(FileUtils.getVideoDuration(call.argument("filePath")));
    } else if (call.method.equals("getVideoResolution")) {
      result.success(FileUtils.getVideoResolution(call.argument("filePath")));
    } else if (call.method.equals("getVideoRatio")) {
      result.success(FileUtils.getVideoRatio(call.argument("filePath")));
    } else if (call.method.equals("getVideoSize")) {
      result.success(FileUtils.getVideoSize(call.argument("filePath")));
    } else if (call.method.equals("getVideoBitrate")) {
      result.success(FileUtils.getVideoBitrate(call.argument("filePath")));
    } else if (call.method.equals("saveCoverInLocal")) {
      result.success(FileUtils.saveCoverInLocal(call.argument("filePath")));
    } else if (call.method.equals("getChannel")) {
      // 获取android 渠道的东西
//      result.success(DeviceUtils.getChannel(activity));
       result.success(getChannel(activity));
    }
  }
  /// 获取渠道号
  public static String getChannel(Context context) {
    return  WalleChannelReader.getChannel(context);
  }
}
