import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    @required this.onPressed,
    @required this.child,
    this.color = Colors.blue,
    this.height = 50.0,
    this.width,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: Colors.amber,
          onSurface: Colors.blueAccent,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
