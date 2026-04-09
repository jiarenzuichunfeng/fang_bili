import 'package:dio/dio.dart';
import 'package:fang_bili/db/hi_cacke.dart';
import 'package:fang_bili/http/cors/hi_error.dart';
import 'package:fang_bili/http/cors/hi_net.dart';
import 'package:fang_bili/http/dao/login_dao.dart';
import 'package:fang_bili/http/request/test_request.dart';
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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  Future<void> _incrementCounter() async {
    // TestRequest request = TestRequest();
    // request.add("aa", "ddd").add("bb", "333").add("requestPrams", "kkk");
    // try {
    //   var result = await HiNet.getInstance()?.fire(request);
    //   print(result);
    // } on NeedAuth catch (e) {
    //   print(e);
    // } on NeedLogin catch (e) {
    //   print(e);
    // } on HiNetError catch (e) {
    //   print(e);
    // }
    test();
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

  void test() async {
    try {
      var result = await LoginDao.Login("admin", "123456");
      // var result = await LoginDao.registration("admin", "123456","4321","9876");
      print(result);
    } on NeedAuth catch (e) {
      print(e);
    }
  }
}
