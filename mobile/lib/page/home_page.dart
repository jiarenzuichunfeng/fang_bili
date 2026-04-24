import 'package:fang_bili/model/video_model.dart';
import 'package:fang_bili/navigator/hi_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var listener;
  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(this.listener = (current,pre){
      if(widget == current.page || current.page is HomePage){

      }else if (widget == pre?.page || pre?.page is HomePage) {}
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().addListener(this.listener);
    super.dispose();
  }

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
