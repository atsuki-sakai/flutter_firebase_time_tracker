import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  final Widget child;
  final Color color;
  final onPressed;
  final double width;
  final double height;

  SignInButton({
    @required this.onPressed,
    @required this.child,
    this.color = Colors.blue,
    this.height = 50.0,
    this.width,
  }) : super(
          width: width,
          height: height,
          child: child,
          color: color,
          onPressed: onPressed,
        );
}
