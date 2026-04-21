import 'package:fang_bili/db/hi_cacke.dart';
import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/dao/login_dao.dart';
import 'package:fang_bili/navigator/hi_navigator.dart';
import 'package:fang_bili/util/string_util.dart';
import 'package:fang_bili/util/toast.dart';
import 'package:fang_bili/widget/appbar.dart';
import 'package:fang_bili/widget/login_button.dart';
import 'package:fang_bili/widget/login_effect.dart';
import 'package:fang_bili/widget/login_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String username = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    HiCacke.preInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("登录", "注册", () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) => {username = text, checkInput()},
            ),
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              onChanged: (text) => {password = text, checkInput()},
              focusChanged: (focus) => {
                setState(() {
                  protect = focus;
                }),
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: LoginButton(
                title: '登录',
                enable: loginEnable,
                onPressed: send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.Login(username, password);
      print(result);
      if (result['code'] == 0) {
        print("登录成功");
        showToast('登录成功');
        HiNavigator.getInstance().onJumpTo(RouteStatus.home);
      } else {
        print(result["meg"]);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }
}
