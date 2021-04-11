import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/service/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});

  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  // final StreamController<bool> _isLoadingController = StreamController<bool>();
  // Stream<bool> get isLoadingStream => _isLoadingController.stream;

  // void dispose() {
  //   _isLoadingController.close();
  // }

  // //　- sink.addを用いることで紐づいているStreamに新しい値を送ることができる。 _isLoadingController.sink.add(isLoading)
  // void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  // Point: (Future<User> Function() signInMethod) = Future<User>を返す,引数名signInMethodのFunctionを受け取っている
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      // _setIsLoading(true);
      return await signInMethod();
    } catch (error) {
      rethrow;
    } finally {
      // _setIsLoading(false);
      isLoading.value = false;
    }
  }

  Future<User> signInAnonymous() async => await _signIn(auth.signInAnonymous);
  // 便利に使いまわせる。
  // Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

  // ! このように引数をSignInPageから受け取るようにすると、依存度が高まるのでよろしくない。
  Future<User> signInWithEmailAndPassword({String email, String pass}) async =>
      await auth.signInWithEmailAndPassword(email, pass);
}
