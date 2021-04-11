import 'package:flutter/material.dart';
import 'package:flutter_firebase/landing_page.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        home: LandingPage(),
      ),
    );
  }
}
