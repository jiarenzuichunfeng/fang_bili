// 自定义 appBar
import 'dart:ui';

import 'package:flutter/material.dart';

appBar(String title,String rightTitle,VoidCallback rightButtonClick){
  return AppBar(
    centerTitle: false,
    titleSpacing: 0,
    leading: BackButton(),
    title: Text(
      title,
      style:TextStyle(fontSize: 18.0),
    ),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: EdgeInsets.only(left: 15.0,right: 15.0),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}