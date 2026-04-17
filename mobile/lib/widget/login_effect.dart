import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({super.key, required this.protect});

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 18.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300] ?? Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          Image(width: 90, height: 90, image: AssetImage('images/logo.png')),
          _image(false),
        ],
      ),
    );
  }

  _image(bool lift) {
    var headLeft = widget.protect
        ? 'images/head_left_protect.png'
        : 'images/head_left.png';
    var headRight = widget.protect
        ? 'images/head_right_protect.png'
        : 'images/head_right.png';
    return Image(height: 90, image: AssetImage(lift ? headLeft : headRight));
  }
}
