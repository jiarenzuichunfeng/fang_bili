import 'package:fang_bili/db/hi_cacke.dart';
import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/cors/hi_net.dart';
import 'package:fang_bili/http/dao/login_dao.dart';
import 'package:fang_bili/http/request/notice_request.dart';
import 'package:fang_bili/page/login_page.dart';
import 'package:fang_bili/page/registration_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  void initState() {
    HiCacke.preInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.white,
          onPrimary: Colors.black,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // home: RegistrationPage(onJumpToLogin: () {}),
      // home: MyHomePage(title: '标题'),
      home: LoginPage(title: '标题', onJumpToRegistration: () {}),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int _counter = 0;

  Future<void> _incrementCounter() async {
    // testLogin();
    testRegistration();
    // testNotice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void testLogin() async {
    try {
      var result = await LoginDao.Login("admin", "123456");
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    }
  }

  void testRegistration() async {
    // 如果出现 返回值为空的情况 ，可能是ip地址变了
    try {
      var result = await LoginDao.registration(
        "admin",
        "123456",
        "4321",
        "9876",
      );
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    }
  }

  void testNotice() async {
    try {
      var result = await HiNet.getInstance()?.fire(NoticeRequest());
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    }
  }
}
