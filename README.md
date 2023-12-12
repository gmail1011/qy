# 当你使用时，请检测出子module的依赖

flutter_base 依赖 flutter_base 是做代码下沉的，适陪于各个项目
$ git submodule init
$ git submodule update

YS短视频

一、主要插件如下：
1､fish_redux 闲魚框架，让你的代码更多、更大、更强
2､fijkplayer 基于ijkplayer的播放器
3、flutter_cache_/Users/mac/Documents/DevProjectmanager 缓存管理（图片和视频）
4、camera   调用系统相机录制视频
5、flutter_easyrefresh 刷新及分页加载框架

二、打包
1、android打包（建议配置armeabi-v7a则可）
a)、使用android studio打开android工程，等待加载信息
b)、信息加载完成后，修改build.gradle下的版本信息
c)、打开菜单Build-Generated Signed Bundle/APK
d)、选择打包模式为apk
e)、输入签名信息（文件、密码等），点击下一步
f)、选择release，同时勾选下方的V1、V2两种选项

2、ios打包(在Xcode中进行),假设你的开发者账号已进行配置
a)、进入xcode，点击Generic iOS Device，此时需要使用真机，真机才能打release包
b)、点击工程名字->选中edit scheme -> 选中release
c)、选中菜单product - > archive,等待生成安装包
d)、生成安装包成功后，会弹出界面，此时请选中界面中的Distribute App
e)、后面的配置请根据你的需要进行选择了

build json xxx.g.dart
add : par 'xxx.g.dart'
run: flutter packages pub run build_runner build --delete-conflicting-outputs
更新在线客服 代码
flutter pub upgrade chat_online_customers


# main 和远程一起开发的分支
# seba 色吧
# eat_melon_club 吃瓜社