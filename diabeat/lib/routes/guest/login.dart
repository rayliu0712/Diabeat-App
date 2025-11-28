import 'package:diabeat/routes/guest/auth_state.dart';
import 'package:diabeat/core/session.dart' as session;
import 'package:diabeat/util.dart' as util;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:diabeat/core/request.dart' as request;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  AuthState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends AuthState<LoginPage> {
  String? _passwordErr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(flex: 1),
                const Text(
                  '歡迎回來 !',
                  style: TextStyle(fontSize: 35),
                  textAlign: TextAlign.center,
                ),
                const Spacer(flex: 1),
                buildEmailField(),
                const SizedBox(height: 20),
                TextFormField(
                  validator: passwordValidator,
                  forceErrorText: _passwordErr,
                  onSaved: (newValue) => password = newValue!,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.send,
                  obscureText: passwordObscured,
                  decoration: passwordDecoration(),
                  onChanged: (value) {
                    if (_passwordErr != null) {
                      setState(() => _passwordErr = null);
                    }
                  },
                  onFieldSubmitted: waiting
                      ? null
                      : (value) {
                          _tryLogIn();
                        },
                ),
                const Spacer(flex: 2),
                FilledButton.icon(
                  onPressed: waiting ? null : _tryLogIn,
                  style: util.filledPageButtonStyle(),
                  icon: waiting
                      ? util.smallCircularProgressIndicator()
                      : const Icon(Icons.login_rounded),
                  label: waiting ? const Text('登入中') : const Text('登入'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tryLogIn() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState!.save();
    primaryFocus?.unfocus();
    setState(() => waiting = true);

    // final (ok, data) = await request.logIn(
    //   context,
    //   email: email,
    //   password: password,
    // );
    final (ok, data) = await request.logIn(email: email, password: password);
    if (!mounted) return;

    if (ok) {
      await session.logInAndWrite(
        pUsername: data['username'],
        pAccess: data['access'],
        pRefresh: data['refresh'],
      );

      context.pop();
      context.go('/record');
    } else {
      setState(() {
        waiting = false;

        if (data != null) {
          switch (data['non_field_errors'][0]) {
            case 'Email does not exist.':
              emailErr = 'Email 不存在';
              break;

            case 'Incorrect password.':
              _passwordErr = '密碼錯誤';
              break;
          }
        }
      });
    }
  }
}
