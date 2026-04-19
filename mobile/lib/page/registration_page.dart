import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/dao/login_dao.dart';
import 'package:fang_bili/util/string_util.dart';
import 'package:fang_bili/util/toast.dart';
import 'package:fang_bili/widget/appbar.dart';
import 'package:fang_bili/widget/login_button.dart';
import 'package:fang_bili/widget/login_effect.dart';
import 'package:fang_bili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;
  const RegistrationPage({super.key, required this.onJumpToLogin});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String username = "";
  String password = "";
  String rePassword = "";
  String moocId = "";
  String orderId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", widget.onJumpToLogin),
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
              focusChanged: (value) => {
                setState(() {
                  protect = value;
                }),
              },
            ),
            LoginInput(
              title: "确认密码",
              hint: "请再次输入密码",
              obscureText: true,
              onChanged: (text) => {rePassword = text, checkInput()},
              focusChanged: (value) => {
                setState(() {
                  protect = value;
                }),
              },
            ),
            LoginInput(
              title: "慕课网ID",
              hint: "请输入慕课网ID",
              keyboardType: TextInputType.number,
              onChanged: (text) => {moocId = text, checkInput()},
            ),
            LoginInput(
              title: "课程订单号",
              hint: "请输入课程订单号后四位",
              lineStretch: true,
              keyboardType: TextInputType.number,
              onChanged: (text) => {orderId = text, checkInput()},
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: LoginButton(title: "注册", enable: false, onPressed: send),
            ),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(moocId) &&
        isNotEmpty(orderId)) {
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
      var result = await LoginDao.registration(
        username,
        password,
        moocId,
        orderId,
      );
      print(result);
      if (result['code'] == 0) {
        print("注册成功");
        showToast("注册成功");
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
        }
      } else {
        print(result["msg"]);
        showWarnToast(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = "两次密码不一致";
    } else if (orderId.length != 4) {
      tips = "请输入订单号后四位";
    }
    if (tips != null) {
      print(tips);
      showWarnToast(tips);
      return;
    }
    send();
  }
}
