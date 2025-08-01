import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String repeatPassword = '';
  bool isPending = false;

  @override
  Widget build(BuildContext context) {
    final authRequest = ref.watch(authProvider.notifier);

    void handleSignUp() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          isPending = true;
        });

        try {
          await authRequest.signUp((
            name: name,
            email: email,
            password: password,
          ));

          if (context.mounted) {
            context.go('/login');
            SnackBars.show(context: context, message: 'Success create account');
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
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Please sign up to enjoy all Montrack features',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: 20,
                          children: [
                            Input(
                              label: 'Name',
                              placeholder: 'Name',
                              enabled: !isPending,
                              onSaved: (value) => name = value!,
                            ),
                            Input(
                              label: 'Email',
                              placeholder: 'Email',
                              enabled: !isPending,
                              onSaved: (value) => email = value!,
                            ),
                            Input(
                              label: 'Password',
                              placeholder: 'Password',
                              variant: 'password',
                              enabled: !isPending,
                              onSaved: (value) => password = value!,
                              onChanged: (value) => {
                                setState(() {
                                  password = value;
                                }),
                              },
                            ),
                            Input(
                              label: 'Repeat Password',
                              placeholder: 'Repeat Password',
                              variant: 'password',
                              enabled: !isPending,
                              onSaved: (value) => repeatPassword = value!,
                              onChanged: (value) => {
                                setState(() {
                                  repeatPassword = value;
                                }),
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Repeat Password';
                                }

                                if (password != repeatPassword) {
                                  return 'Password not match';
                                }

                                return null;
                              },
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
                      label: 'Sign up',
                      disabled: isPending,
                      isLoading: isPending,
                      onPressed: () {
                        handleSignUp();
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go('/login');
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            enableFeedback: false,
                          ),
                          child: Text(
                            'Log In',
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
