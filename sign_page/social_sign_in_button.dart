import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  final VoidCallback onPressed;
  final Color color;
  final double height;
  final String imagePath;
  final Widget text;
  final double width;

  SocialSignInButton({
    @required this.imagePath,
    @required this.text,
    this.onPressed,
    this.color = Colors.blue,
    this.height = 50.0,
    this.width,
  })  : assert(imagePath != null && imagePath != ''),
        assert(text != null),
        super(
          onPressed: onPressed,
          height: height,
          width: width,
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(imagePath),
              text,
              Opacity(
                opacity: 0.0,
                child: Image.asset(imagePath),
              )
            ],
          ),
        );
}
