import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/conponets_widgets/show_alert_dialog.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/home/jobs/jobs_page.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:flutter_firebase/sign_page/email_sign_in_page.dart';
import 'package:flutter_firebase/sign_page/sign_in_manager.dart';
import 'package:flutter_firebase/sign_page/sign_in_button.dart';
import 'package:flutter_firebase/sign_page/social_sign_in_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          // dispose: (_, bloc) => bloc.dispose(),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) {
              return SignInPage(
                manager: manager,
                isLoading: isLoading.value,
              );
            },
          ),
        ),
      ),
    );
  }

  void showSignInError(BuildContext context, Exception exception) {
    //ユーザーがキャンセルした時はエラーを出さない。
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in Failed.',
      exception: exception,
    );
  }

  Future<void> _signInWithAnonymous(BuildContext context) async {
    try {
      // 2秒遅らせて、Indicatorが回っているか確認。
      Future.delayed(Duration(seconds: 2));
      await manager.signInAnonymous();
    } on Exception catch (e) {
      showSignInError(context, e);
    }
  }

  void _signInEmail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'SigIn Page',
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContext(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(isLoading),
            SizedBox(
              height: 32.0,
            ),
            SocialSignInButton(
              color: Colors.white,
              imagePath: 'images/google-logo.png',
              text: Text(
                'Sign in with Google.',
                style: defaultButtonStyle(),
              ),
              onPressed: isLoading
                  ? null
                  : () => showAlertDialog(
                        context,
                        title: 'test alert',
                        content: 'sample text.',
                        defaultActionText: 'Ok',
                        cancelActionText: 'cancel',
                      ),
            ),
            SizedBox(
              height: 12.0,
            ),
            SocialSignInButton(
              color: Colors.indigo,
              imagePath: 'images/facebook-logo.png',
              text: Text(
                'Sign in with atk721.',
                style: defaultButtonStyle().copyWith(color: Colors.white),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      try {
                        final email = 'atk721@icloud.com';
                        final pass = 'Heisei50721';
                        await manager.signInWithEmailAndPassword(
                            email: email, pass: pass);

                        showSnakBar(context, text: 'User: atk721 => signin.');
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return JobsPage();
                          }),
                        );
                      } catch (e) {
                        showSnakBar(
                          context,
                          text: e.toString(),
                        );
                      }
                    },
            ),
            SizedBox(
              height: 12.0,
            ),
            SignInButton(
              width: double.infinity,
              onPressed: isLoading ? null : () => _signInEmail(context),
              child: Text(
                'Sign in with Email',
                style: defaultButtonStyle().copyWith(color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'OR',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
            ),
            SignInButton(
              color: Colors.amber[600],
              width: double.infinity,
              onPressed: isLoading ? null : () => _signInWithAnonymous(context),
              child: Text(
                'Sign in with Anonymous',
                style: defaultButtonStyle().copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tricker.'),
        automaticallyImplyLeading: false,
      ),
      body: _buildContext(context),
    );
  }
}

TextStyle defaultButtonStyle() {
  return TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.black87);
}
