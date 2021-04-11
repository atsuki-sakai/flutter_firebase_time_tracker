import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/conponets_widgets/form_submit_button.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/home/jobs/jobs_page.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:flutter_firebase/sign_page/email_sign_in_change_model.dart';
import 'package:provider/provider.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) {
          return EmailSignInFormChangeNotifier(model: model);
        },
      ),
    );
  }

  final EmailSignInChangeModel model;
  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

  EmailSignInChangeModel get model => widget.model;

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
    widget.model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    try {
      // ! Firebase_Auth の　エラーをキャッチできない。 awaitがなければcatchしてくれない。
      await model.submit();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return JobsPage();
          },
        ),
      );
    } catch (exception) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in Failed.',
        exception: exception,
      );
    }
  }

  void _emailEditingCompleted() {
    final newFocus = model.emailValidator.isValid(widget.model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
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
        text: model.primaryText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      TextButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryText),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      focusNode: _passwordFocusNode,
      keyboardType: TextInputType.visiblePassword,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.emailErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'sample@email.com',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingCompleted,
      onChanged: model.updateEmail,
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
