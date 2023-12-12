import 'package:device_preview/device_preview.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/common/provider/fiction_update_model.dart';
import 'package:flutter_app/common/provider/location_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/provider/lou_feng_update_model.dart';
import 'package:flutter_app/page/audio_novel_page/ys_audio_player.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/main_player_ui_show_model.dart';
import 'package:flutter_app/page/video/video_list_model/second_player_ui_show_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'common/provider/can_play_count_model.dart';
import 'common/provider/msg_count_model.dart';
import 'global_store/state.dart';
import 'global_store/store.dart';
import 'page/splash/effect.dart';
import "package:flutter_app/utils/analytics.dart" as Analytics;

//不需要放大左滑退出页面的路由表
final noLeftSliderRoutes = <String>[];

final AbstractRoutes routers = PageRoutes(
  pages: routerMap,
  visitor: (String path, Page<Object, dynamic> page) {
    /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
    /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
    if (page.isTypeof<GlobalBaseState>()) {
      /// 建立 AppStore 驱动 PageStore 的单向数据连接
      /// 1. 参数1 AppStore
      /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
      page.connectExtraStore<GlobalState>(GlobalStore.store,
          (Object pageState, GlobalState newAppState) {
        /// 当页面属性不等于app属性，通过观察者/访问者模式，遍历所有页面，将页面属性重置为app属性
        final GlobalBaseState oldPageState = pageState;
        if (oldPageState.meInfo != newAppState.meInfo ||
            oldPageState.wallet != newAppState.wallet) {
          /// 从app更新个人信息到页面
          if (pageState is Cloneable) {
            final Object copy = pageState.clone();
            final GlobalBaseState newState = copy;
            newState.meInfo = newAppState.meInfo;
            newState.wallet = newAppState.wallet;
            return newState;
          }
        }
        return pageState;
      });
    }

    /// AOP
    /// 页面可以有一些私有的 AOP 的增强， 但往往会有一些 AOP 是整个应用下，所有页面都会有的。
    /// 这些公共的通用 AOP ，通过遍历路由页面的形式统一加入。
    // page.enhancer.append(
    //   /// View AOP
    //   viewMiddleware: <ViewMiddleware<dynamic>>[
    //     safetyView<dynamic>(),
    //   ],

    //   /// Adapter AOP
    //   adapterMiddleware: <AdapterMiddleware<dynamic>>[safetyAdapter<dynamic>()],

    //   /// Effect AOP
    //   effectMiddleware: <EffectMiddleware<dynamic>>[
    //     _pageAnalyticsMiddleware<dynamic>(),
    //   ],

    //   /// Store AOP
    //   middleware: <Middleware<dynamic>>[
    //     logMiddleware<dynamic>(
    //         tag: page.runtimeType.toString(),
    //         monitor: (t) {
    //           return t?.runtimeType?.toString() ?? "";
    //         }),
    //   ],
    // );
  },
);

class InitedApp extends StatefulWidget {
  @override
  _InitedAppState createState() => _InitedAppState();
}

class _InitedAppState extends State<InitedApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final String tag = "AppLifeCycle";

  @override
  void initState() {
    super.initState();

    /// 添加activity生命周期监听函数
    WidgetsBinding.instance.addObserver(this);



    isFirstEnterAPP();
  }


  void isFirstEnterAPP() async{

    bool value = SpUtil.getBool("firstStartApp",defValue: false);

    print("----------第一次启动App" + value.toString());

    Config.isFirstStartApp = value;

    if(!value){
      SpUtil.putBool("firstStartApp", true);
    }

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        l.i(tag, "app 暂停了inactive");
        autoPlayModel?.disposeAll();
        curAudioPlayer?.pause();
        break;
      case AppLifecycleState.detached:
        l.i(tag, "app 暂停了detached");
        break;
      case AppLifecycleState.paused:
        l.i(tag, "app 暂停了paused");
        autoPlayModel?.disposeAll();
        curAudioPlayer?.pause();
        break;
      case AppLifecycleState.resumed:
        l.i(tag, "app 恢复了resumed");
        _recoveryVideo();
        break;
      default:
    }
  }

  _recoveryVideo() async {
    await localServerGuard?.run();
    autoPlayModel?.startAvailblePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: autoPlayModel),
        ChangeNotifierProvider.value(value: playCountModel),
        ChangeNotifierProvider(
          create: (ctx) => MsgCountModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocationModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => MainPlayerUIShowModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SecondPlayerShowModel(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CountdwonUpdate(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LouFengUpdate(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FictionUpdate(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: Size(428, 926),
        allowFontScaling: false,
        builder: () => GetMaterialApp(
          locale: DevicePreview.locale(context), // Add the locale here
          builder: DevicePreview.appBuilder, // Add the builder here
          theme: ThemeData(
            platform: TargetPlatform.iOS,
            //scaffoldBackgroundColor: Colors.transparent,
            scaffoldBackgroundColor: AppColors.primaryColor,
            primaryColor: AppColors.primaryColor,
            unselectedWidgetColor: Color(0xffD8D8D8),
            // disabledColor: Colors.yellow,
            // primaryColor: Colors.black,
            // primarySwatch: Colors.black,
            splashColor: Colors.transparent,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              color: Colors.black,
              elevation: 0,
              textTheme: TextTheme(
                headline6:
                    TextStyle(color: Colors.white, fontSize: Dimens.pt18, fontWeight: FontWeight.w500),
              ),
              brightness: Brightness.dark,
            ),
          ),
          navigatorKey: FlutterBase.navigatorKey,
          debugShowCheckedModeBanner: true,
          //关掉模拟器右上角debug图标
          title: Lang.APP_NAME,
          // home: routers.buildPage(PAGE_SPLASH, null),
          initialRoute: PAGE_SPLASH,
          navigatorObservers: [CustomRouteObserver(), Analytics.observer],
          onGenerateRoute: (RouteSettings settings) {
            if (noLeftSliderRoutes.contains(settings.name)) {
              return MaterialPageRoute<Object>(
                  settings: settings,
                  builder: (BuildContext context) {
                    return routers.buildPage(settings.name, settings.arguments);
                  });
            } else {
              return IMCupertinoPageRoute<Object>(
                  settings: settings,
                  builder: (BuildContext context) {
                    return routers.buildPage(settings.name, settings.arguments);
                  });
            }
          },
        ),
      ),
    );
  }
}

//继承RouteObserver
/// 新增页面停留埋点
class CustomRouteObserver<PageRoute> extends RouteObserver {
  @override
  void didPush(Route newRoute, Route oldRoute) {
    // l.i("router",
    //     "didPush()...p:${oldRoute?.settings?.name} n:${newRoute?.settings?.name}");
    //umengDidPush(newRoute, oldRoute);
    super.didPush(newRoute, oldRoute);
  }

  @override
  void didPop(Route route, Route previousRoute) {
    // l.i("router",
    //     "didPop()...p:${previousRoute?.settings?.name} n:${route?.settings?.name}");
    //umengDidPop(route, previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    // l.i("router",
    //     "didReplace()...old:${oldRoute?.settings?.name} new:${newRoute?.settings?.name}");
    //umengDidReplace(newRoute: newRoute, oldRoute: oldRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
  return (AbstractLogic<dynamic> logic, Store<T> store) {
    return (Effect<dynamic> effect) {
      return (Action action, Context<dynamic> ctx) {
        if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
          l.i(tag, '${logic.runtimeType} ${action.type.toString()} ');
        }
        return effect?.call(action, ctx);
      };
    };
  };
}
