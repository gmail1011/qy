# flutter_base

所有我们自己的代码库和框架

## Getting Started

主要做代码下沉淀和公共框架的东西
note-this:

1. 避免一份代码，到处复制粘贴，改了一个项目，其他项目没有改到的情况，减少维护成本
1. 为了保持框架的稳定性
    7级以下和组员不允许修改和上传这个文件夹里面的内容

- 主文件：`flutter_base.dart` 需要初始化

    ```dart
        // 在主程序初始化的时候调用,对底层框架的必要的初始化
        await FlutterBase.init();
    ```

## 文件说明

1. 公共dialog文件位于`./lib/dialog`下面的`dart`文件。

1. 修改的flutter 源码文件位于`./lib/sys_core`下面的`dart`文件。(不要随意乱动,根据flutter sdk更新来适配)

   - `drawer_scaffold.dart` 修改原生的scaffold.dart 优化了抽屉回调
   - `ys_drawer_controller.dart` 修改原生的drawer_controller控制器，使回调更加准确且只调用一次
   - `flutter_page_router.dart` 修改原生路由，优化左边滑动返回

1. 工具类文件位于`./lib/utils`下面的`dart`文件。

   - `screen.dart` 屏幕适配相关，使用前请初始化
   - `light_model.dart` 轻量级别存储模型(kv键值对)内部包含文件和内存缓存
  中量级别的文件和重量级的sqlite存储模型一般依赖于具体的业务模型，这里不进行说明
   - `dimens.dart` 基本的UI dp使用值
   - `file_util.dart` 文件相关的工具，存取、分片、文件大小、格式化
   - `toast_util.dart` 所有项目统一的显示toast 无context
   - `single_ticker_state.dart` 需要用到的动画的ticker状态
   - `permissions_util.dart` 权限工具

1. 统一的图片加载库`./lib/image/image_loader.dart`

   - 可以加载网络图片、本地图片、asset图片、svg图片
   - 可以预加载svg图片，减少等待时间

    ```dart
        //自定义ImageLoader的cacheManager
        ImageLoader.init(ImgCacheMgr());
    ```

## 帮助工具tools说明

- tools目录为各种帮助工具

1. `tools/gen_assets_mapping.dart`生成资源文件描述

    ```bash
        //在主目录`lib/assets/`生成相应的资源文件
        dart run flutter_base/tools/gen_assets_mapping.dart
    ```

1. `tools/check_chinese.dart`检查代码中的中文
1. `tools/check_dart_filename.dart`检查项目中dart文件是否是小写
1. `tools/check_imports.dart`检查项目中的冗余引用
1. 其他请RTFSC

## 渠道工具channel说明

- channel目录为各种帮助工具,see `channel/README.txt`

## 版本日志

- flutter_base 依赖于最新的flutter sdk 1.17.0

| ver   |    date    | desc                                               |
| :---- | :--------: | :------------------------------------------------- |
| 2.1.0 | 2019/12/19 | `Flutter 1.17.0 • channel stable • channel stable` |
