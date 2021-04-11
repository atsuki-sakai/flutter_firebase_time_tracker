import 'package:flutter/material.dart';
import 'package:flutter_firebase/home/home_page.dart';
import 'package:flutter_firebase/home/jobs/jobs_page.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:flutter_firebase/service/database.dart';
import 'package:flutter_firebase/sign_page/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.active) {
          final User _user = snapShot.data;
          if (_user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: _user.uid),
            // FIXME - Test now => child: JobsPage();
            child: HomePage(),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
