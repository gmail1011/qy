package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.example.appsettings.AppSettingsPlugin;
import xyz.luan.audioplayers.AudioplayersPlugin;
import de.bytepark.autoorientation.AutoOrientationPlugin;
import io.flutter.plugins.camera.CameraPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import com.befovy.fijkplayer.FijkPlugin;
import io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin;
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin;
import org.zoomdev.flutter.alipay.FlutterAlipayPlugin;
import yy.inc.flutter_animation_set.FlutterAnimationSetPlugin;
import yy.inc.flutter_custom_dialog.FlutterCustomDialogPlugin;
import com.ajinasokan.flutterdisplaymode.DisplayModePlugin;
import com.pluging.flutter_facilityinfo.FlutterPhoneinfoPlugin;
import com.pichillilorenzo.flutter_inappwebview.InAppWebViewFlutterPlugin;
import com.jrai.flutter_keyboard_visibility.FlutterKeyboardVisibilityPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.example.flutternativeimage.FlutterNativeImagePlugin;
import com.whelksoft.flutter_native_timezone.FlutterNativeTimezonePlugin;
import io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin;
import com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin;
import com.dooboolab.fluttersound.FlutterSoundPlugin;
import com.flutter_webview_plugin.FlutterWebviewPlugin;
import io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin;
import com.example.imagegallerysaver.ImageGallerySaverPlugin;
import io.flutter.plugins.imagepicker.ImagePickerPlugin;
import com.leeson.image_pickers.ImagePickersPlugin;
import com.rioapp.demo.imeiplugin.ImeiPlugin;
import com.zaihui.installplugin.InstallPlugin;
import com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin;
import com.bigbug.mmkvflutter.MmkvFlutterPlugin;
import com.crazecoder.openfile.OpenFilePlugin;
import io.flutter.plugins.packageinfo.PackageInfoPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import com.julienvignali.phone_number.PhoneNumberPlugin;
import com.rhyme.r_scan.RScanPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.tekartik.sqflite.SqflitePlugin;
import io.flutter.plugins.urllauncher.UrlLauncherPlugin;
import io.flutter.plugins.videoplayer.VideoPlayerPlugin;
import creativecreatorormaybenot.wakelock.WakelockPlugin;
import io.flutter.plugins.webviewflutter.WebViewFlutterPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AppSettingsPlugin.registerWith(registry.registrarFor("com.example.appsettings.AppSettingsPlugin"));
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    AutoOrientationPlugin.registerWith(registry.registrarFor("de.bytepark.autoorientation.AutoOrientationPlugin"));
    CameraPlugin.registerWith(registry.registrarFor("io.flutter.plugins.camera.CameraPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    FijkPlugin.registerWith(registry.registrarFor("com.befovy.fijkplayer.FijkPlugin"));
    FirebaseAnalyticsPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebaseanalytics.FirebaseAnalyticsPlugin"));
    FlutterFirebaseCorePlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin"));
    FlutterAlipayPlugin.registerWith(registry.registrarFor("org.zoomdev.flutter.alipay.FlutterAlipayPlugin"));
    FlutterAnimationSetPlugin.registerWith(registry.registrarFor("yy.inc.flutter_animation_set.FlutterAnimationSetPlugin"));
    FlutterCustomDialogPlugin.registerWith(registry.registrarFor("yy.inc.flutter_custom_dialog.FlutterCustomDialogPlugin"));
    DisplayModePlugin.registerWith(registry.registrarFor("com.ajinasokan.flutterdisplaymode.DisplayModePlugin"));
    FlutterPhoneinfoPlugin.registerWith(registry.registrarFor("com.pluging.flutter_facilityinfo.FlutterPhoneinfoPlugin"));
    InAppWebViewFlutterPlugin.registerWith(registry.registrarFor("com.pichillilorenzo.flutter_inappwebview.InAppWebViewFlutterPlugin"));
    FlutterKeyboardVisibilityPlugin.registerWith(registry.registrarFor("com.jrai.flutter_keyboard_visibility.FlutterKeyboardVisibilityPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterNativeImagePlugin.registerWith(registry.registrarFor("com.example.flutternativeimage.FlutterNativeImagePlugin"));
    FlutterNativeTimezonePlugin.registerWith(registry.registrarFor("com.whelksoft.flutter_native_timezone.FlutterNativeTimezonePlugin"));
    FlutterAndroidLifecyclePlugin.registerWith(registry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    FlutterSecureStoragePlugin.registerWith(registry.registrarFor("com.it_nomads.fluttersecurestorage.FlutterSecureStoragePlugin"));
    FlutterSoundPlugin.registerWith(registry.registrarFor("com.dooboolab.fluttersound.FlutterSoundPlugin"));
    FlutterWebviewPlugin.registerWith(registry.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"));
    FluttertoastPlugin.registerWith(registry.registrarFor("io.github.ponnamkarthik.toast.fluttertoast.FluttertoastPlugin"));
    ImageGallerySaverPlugin.registerWith(registry.registrarFor("com.example.imagegallerysaver.ImageGallerySaverPlugin"));
    ImagePickerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.imagepicker.ImagePickerPlugin"));
    ImagePickersPlugin.registerWith(registry.registrarFor("com.leeson.image_pickers.ImagePickersPlugin"));
    ImeiPlugin.registerWith(registry.registrarFor("com.rioapp.demo.imeiplugin.ImeiPlugin"));
    InstallPlugin.registerWith(registry.registrarFor("com.zaihui.installplugin.InstallPlugin"));
    KeyboardVisibilityPlugin.registerWith(registry.registrarFor("com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin"));
    MmkvFlutterPlugin.registerWith(registry.registrarFor("com.bigbug.mmkvflutter.MmkvFlutterPlugin"));
    OpenFilePlugin.registerWith(registry.registrarFor("com.crazecoder.openfile.OpenFilePlugin"));
    PackageInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.packageinfo.PackageInfoPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    PhoneNumberPlugin.registerWith(registry.registrarFor("com.julienvignali.phone_number.PhoneNumberPlugin"));
    RScanPlugin.registerWith(registry.registrarFor("com.rhyme.r_scan.RScanPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    SqflitePlugin.registerWith(registry.registrarFor("com.tekartik.sqflite.SqflitePlugin"));
    UrlLauncherPlugin.registerWith(registry.registrarFor("io.flutter.plugins.urllauncher.UrlLauncherPlugin"));
    VideoPlayerPlugin.registerWith(registry.registrarFor("io.flutter.plugins.videoplayer.VideoPlayerPlugin"));
    WakelockPlugin.registerWith(registry.registrarFor("creativecreatorormaybenot.wakelock.WakelockPlugin"));
    WebViewFlutterPlugin.registerWith(registry.registrarFor("io.flutter.plugins.webviewflutter.WebViewFlutterPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
