import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  final String text;
  final VoidCallback onPressed;
  FormSubmitButton({
    this.text,
    this.onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          onPressed: onPressed,
          height: 44.0,
          color: Colors.indigo,
        );
}
