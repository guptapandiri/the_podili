import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final double fontSize;

  const ButtonWidget({
    @required this.text,
    @required this.onClicked,
    this.fontSize,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
    child: Text(
      text,
      style: TextStyle(fontSize: fontSize),
    ),
    shape: StadiumBorder(),
    color: Theme.of(context).primaryColor,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    textColor: Colors.white,
    onPressed: onClicked,
  );
}