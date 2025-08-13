import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(secureStorageProvider);
    final authRequest = ref.watch(authProvider.notifier);

    void handleLogin() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isPending = true;
        });

        try {
          final response = await authRequest.signIn((
            email: email,
            password: password,
          ));

          if (response.data['message'].contains('2FA')) {
            if (context.mounted) {
              context.go(
                Uri(
                  path: '/otp',
                  queryParameters: {'userId': response.data['data']['userId']},
                ).toString(),
              );
            }
          } else {
            final value = AuthLoginResponse.fromJson(response.data);

            storage.write('access_token', value.data.accessToken);
            storage.write('refresh_token', value.data.refreshToken);

            if (context.mounted) context.replace('/home');
          }
        } on DioException catch (error) {
          if (context.mounted) {
            SnackBars.show(
              context: context,
              message:
                  '${error.response?.data['message'] ?? 'Ops Something Wrong'}',
              type: SnackBarsVariant.error,
            );
          }
        } finally {
          setState(() {
            _isPending = false;
          });
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsetsGeometry.directional(
            bottom: 0,
            start: 20,
            end: 20,
            top: 45,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 20,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Container(
                      margin: EdgeInsetsDirectional.only(bottom: 20),
                      child: Image.asset(
                        'assets/images/MontrackLogo.png',
                        width: double.infinity,
                        height: 27.17,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Please log in to enjoy all Montrack features',
                      style: TextStyle(fontSize: 17, color: Colors.grey[600]),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 30,
                          children: [
                            Input(
                              label: 'Email',
                              placeholder: 'Your Email',
                              enabled: !_isPending,
                              onSaved: (value) => email = value!,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Input(
                                  label: 'Passowrd',
                                  placeholder: 'Your Password',
                                  variant: 'password',
                                  enabled: !_isPending,
                                  onSaved: (value) => password = value!,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF3077E3),
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Button(
                      label: 'Login',
                      disabled: _isPending,
                      isLoading: _isPending,
                      onPressed: () {
                        handleLogin();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text(
                          'Don’t have an account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/signup');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            enableFeedback: false,
                          ),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3077E3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
