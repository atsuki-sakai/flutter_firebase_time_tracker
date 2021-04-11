import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User get currentUser;
  Future<User> signInAnonymous();
  Future<void> signOut();
  Stream<User> authStateChanges();
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> createUserWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _auth = FirebaseAuth.instance;
  Stream<User> authStateChanges() => _auth.authStateChanges();
  @override
  User get currentUser => _auth.currentUser;

  @override
  Future<User> signInAnonymous() async {
    final userCredentials = await _auth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _auth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    // TODO - send email valification
    final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
