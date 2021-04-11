import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/conponets_widgets/form_submit_button.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_firebase/sign_page/validators.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget
    with EmailAndPasswordValidators {
  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  String get _email => _emailController.text;

  String get _password => _passwordController.text;

  bool _submitted = false;

  bool _isLoading = false;

  @override
  void dispose() {
    // ! - Controller&FoucsNodeを使うときは、disposeもセットで必要
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit(BuildContext context) async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      // ! Firebase_Auth の　エラーをキャッチできない。
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (exception) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in Failed.',
        exception: exception,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingCompleted() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _updateState() {
    setState(() {
      print(_email);
      print(_password);
    });
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(),
      SizedBox(
        height: 32.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: () => submitEnabled ? _submit(context) : null,
      ),
      TextButton(
        onPressed: !_isLoading ? _toggleFormType : null,
        child: Text(secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    final showErrorText =
        _submitted && widget.passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: () => _submit(context),
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'sample@email.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingCompleted,
      onChanged: (email) => _updateState(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
