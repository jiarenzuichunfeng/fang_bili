import 'package:fang_bili/db/hi_cacke.dart';
import 'package:fang_bili/http/dao/login_dao.dart';
import 'package:fang_bili/model/video_model.dart';
import 'package:fang_bili/navigator/hi_navigator.dart';
import 'package:fang_bili/page/home_page.dart';
import 'package:fang_bili/page/login_page.dart';
import 'package:fang_bili/page/registration_page.dart';
import 'package:fang_bili/page/video_detail_page.dart';
import 'package:fang_bili/util/color.dart';
import 'package:fang_bili/util/toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({super.key});

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCacke?>(
      // 进行初始化
      future: HiCacke.preInit(),
      builder: (BuildContext context, AsyncSnapshot<HiCacke?> snapshot) {
        var widget = snapshot.connectionState == ConnectionState.done
            ? Router(routerDelegate: _routeDelegate)
            : Scaffold(body: Center(child: CircularProgressIndicator()));
        return MaterialApp(
          home: widget,
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: white,
              onPrimary: Colors.black,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    HiNavigator.getInstance().registerRouteJump(
      RouteJumpListener(
        onJumpTo: (RouteStatus routeStatus, {Map? args}) {
          _routeStatus = routeStatus;
          if (routeStatus == RouteStatus.detail) {
            this.videoModel = args?['videoMo'];
          }
          notifyListeners();
        },
      ),
    );
  }
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  RouteStatus _routeStatus = RouteStatus.home;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> temPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中，则将该页面和它上面的所有页面进行出栈
      // tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面
      temPages = temPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      // 跳转到首页时将栈中的其他页面进行出栈，首页不可回退
      pages.clear();
      page = pageWrap(HomePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel: videoModel!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(
        RegistrationPage(),
      );
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(
        LoginPage(),
      );
    }
    // 重新创建一个数组，否则pages因引用没有改变路由不会生效
    temPages = [...temPages, page];
    pages = temPages;

    return WillPopScope(
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
      child: Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          // 登录页未登录返回拦截
          if ((route.settings as MaterialPage).child is LoginPage) {
            if (!hasLogin) {
              showWarnToast("请先登录");
              return false;
            }
          }
          // 执行返回操作
          // 在这里可以控制是否返回
          if (!route.didPop(result)) {
            return false;
          }
          pages.removeLast();
          return true;
        },
      ),
    );
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;
  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {}
}

// 定义路由数据，path
class BiliRoutePath {
  final String location;
  BiliRoutePath.home() : location = '/';
  BiliRoutePath.detail() : location = '/detail';
}
