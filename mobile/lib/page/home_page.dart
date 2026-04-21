import 'package:fang_bili/model/video_model.dart';
import 'package:fang_bili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("首页"),
            MaterialButton(
              onPressed: () {
                HiNavigator.getInstance().onJumpTo(
                  RouteStatus.detail,
                  args: {'videoMo': VideoModel(1001)},
                );
                print("111");
              },
              child: Text("详情"),
            ),
          ],
        ),
      ),
    );
  }
}
