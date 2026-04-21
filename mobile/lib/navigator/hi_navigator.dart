import 'package:fang_bili/page/home_page.dart';
import 'package:fang_bili/page/login_page.dart';
import 'package:fang_bili/page/registration_page.dart';
import 'package:fang_bili/page/video_detail_page.dart';
import 'package:flutter/material.dart';

// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

// 获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage>pages,RouteStatus routeStatus){
  for(int i = 0; i<pages.length;i++){
    MaterialPage page = pages[i];
    if(getStatus(page) == routeStatus){
      return i;
    }
  }
  return -1;
}

// 自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown }

// 获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  }else {
    return RouteStatus.unknown;
  }
}

// 路由信息
class RouteStatusInfo{
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo({required this.routeStatus, required this.page});
}


//  监听路由页面跳转
// 感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;
  RouteJumpListener? _routeJump;
  HiNavigator._();
  static HiNavigator getInstance(){
    _instance ??= HiNavigator._();
    return _instance!;
  }
  
  void registerRouteJump(RouteJumpListener routeJumpListener){
    this._routeJump = routeJumpListener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
   _routeJump?.onJumpTo(routeStatus,args: args);
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus,{Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus,{Map? args});

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}