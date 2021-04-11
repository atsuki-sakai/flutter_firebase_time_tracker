import 'package:flutter/material.dart';
import 'package:flutter_firebase/sign_page/email_sign_in_form_change_notifier.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5.0,
              child: EmailSignInFormChangeNotifier.create(context),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
