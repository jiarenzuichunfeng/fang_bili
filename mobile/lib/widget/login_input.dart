import 'package:fang_bili/util/color.dart';
import 'package:flutter/material.dart';
// 登录框，自定义widget
class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;
  const LoginInput({
    super.key,
    required this.title,
    required this.hint,
    this.onChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // 是否获取光标
    _focusNode.addListener(() {
      widget.focusChanged?.call(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15.0),
              width: 100,
              child: Text(widget.title, style: TextStyle(fontSize: 16)),
            ),
            _input(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(height: 1, thickness: 0.5),
        ),
      ],
    );
  }

  _input() {
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autocorrect: !widget.obscureText,
        cursorColor: primary,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
        // 输入框样式
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 20.0, right: 20.0),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
        ),
      ),
    );
  }
}
