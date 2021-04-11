import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/conponets_widgets/form_submit_button.dart';
import 'package:flutter_firebase/conponets_widgets/show_exception_alert.dart';
import 'package:flutter_firebase/service/auth.dart';
import 'package:flutter_firebase/sign_page/email_sign_in_bloc.dart';
import 'package:provider/provider.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  EmailSignInFormBlocBased({@required this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) {
          return EmailSignInFormBlocBased(bloc: bloc);
        },
      ),
      dispose: (_, _bloc) {
        final bloc = _bloc as EmailSignInBloc;
        return bloc.dispose();
      },
    );
  }

  final EmailSignInBloc bloc;
  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();

  final _passwordFocusNode = FocusNode();

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
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  void _submit() async {
    try {
      widget.bloc.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (exception) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in Failed.',
        exception: exception,
      );
    }
  }

  void _emailEditingCompleted(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailTextField(model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(model),
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

  TextField _buildPasswordTextField(EmailSignInModel model) {
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
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
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
      onEditingComplete: () => _emailEditingCompleted(model),
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        print('email: ${model.email}, password: ${model.password}');
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }
}
