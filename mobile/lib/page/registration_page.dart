import 'package:fang_bili/widget/appbar.dart';
import 'package:fang_bili/widget/login_effect.dart';
import 'package:fang_bili/widget/login_input.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", () {
        print("right button click");
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) => {print(text)},
            ),
            LoginInput(
              title: "密码",
              hint: "请输入密码",
              obscureText: true,
              onChanged: (value) => {print(value)},
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
              onChanged: (value) => {print(value)},
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
              onChanged: (value) => {print(value)},
            ),
            LoginInput(
              title: "课程订单号",
              hint: "请输入课程订单号",
              keyboardType: TextInputType.number,
              onChanged: (value) => {print(value)},
            ),
          ],
        ),
      ),
    );
  }
}
