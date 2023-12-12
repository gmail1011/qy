package io.flutter.plugins;

import android.Manifest;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;
import androidx.core.app.ActivityCompat;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Random;
import com.mcxiaoke.packer.helper.PackerNg;

public class DeviceUtils {

  /**
   * 获取Imei号
   * <p>
   * 先判断是否有文件，如果没有，先创建文件，写入Imei号
   */
  public static String getUniqueId(Context context) {
    // 首先从SD卡去取deviceId,如果没有，那么就通过getUniqueId取，然后再存到SD卡
    String deviceId = "";
    try {
      File deviceFile = new File(getRootDir(context), ".device/.device_id");
      File currentFile = new File(getRootDir(context), ".pf_id.txt");
      // 兼容以前版本
      if (deviceFile.exists()) {
        deviceId = getFileContent(deviceFile);
        saveIdToFile(deviceId, currentFile);
        // 删除旧的文件
        deviceFile.delete();
      } else {
        if (currentFile.exists()) {
          deviceId = getFileContent(currentFile);
        } else {
          deviceId = generateDeviceId();
          saveIdToFile(deviceId, currentFile);
        }
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      if (TextUtils.isEmpty(deviceId)) {
        deviceId = generateDeviceId();
        File currentFile = new File(getRootDir(context), ".pf_id.txt");
        saveIdToFile(deviceId, currentFile);
      }
      return deviceId;
    }
  }

  private static void saveIdToFile(String deviceId, File file) {
    try {
      if (!file.exists()) {
        file.createNewFile();
      }
      FileOutputStream fos = new FileOutputStream(file);
      // 向文件中写出数据
      fos.write(deviceId.getBytes());
      fos.close();
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  /// 获取渠道号
  public static String getChannel(Context context) {
    return PackerNg.getChannel(context);
  }

  /// 获取文件内容
  private static String getFileContent(File file) {
    String content = "";
    try {
      FileInputStream inputStream;
      inputStream = new FileInputStream(file);
      byte temp[] = new byte[512];
      int len = 0;
      int count;
      while ((count = inputStream.read(temp)) > 0) {
        len += count;
      }
      content = new String(temp, 0, len);
    } catch (IOException e) {

    } finally {
      return content;
    }
  }

  private static boolean createFile(String path) {
    Intent intent = new Intent(Intent.ACTION_CREATE_DOCUMENT);
    intent.addCategory(Intent.CATEGORY_OPENABLE);
    intent.setType("application/txt");
    intent.putExtra(Intent.EXTRA_TITLE, "tttttt.txt");

    return true;
  }

  /// 本地生成唯一标识
  private static String generateDeviceId() {
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssS");
    String dateStr = dateFormat.format(System.currentTimeMillis());
    return "A" + getRandomString(2) + dateStr;
  }

  private static String getRootDir(Context context) {
    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
      // 优先获取SD卡根目录[/storage/sdcard0]
      return Environment.getExternalStorageDirectory().getAbsolutePath();
    } else {
      // 应用缓存目录[/data/data/应用包名/cache]
      return context.getCacheDir().getAbsolutePath();
    }
  }

  /// 随机生成字符串
  public static String getRandomString(int length) {
    String str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    Random random = new Random();
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < length; i++) {
      int number = random.nextInt(52);
      sb.append(str.charAt(number));
    }
    return sb.toString();
  }
}
