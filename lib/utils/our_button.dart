import 'package:flutter/material.dart';

class OurButton extends StatelessWidget{
  const OurButton({super.key, 
  required this.text, 
  required this.textColor, 
  required this.backgroundColor, 
  required this.onPressed, 
  required this.splashColor});

  final String text;
  final Color textColor, backgroundColor, splashColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(onPressed: onPressed,
    fillColor: backgroundColor,
    splashColor: splashColor,
    padding: ButtonTheme.of(context).padding,
    shape: const StadiumBorder(),
    child:  Text(text, style: TextStyle(color: textColor)),
    );
  }


}