import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';

class Signup extends StatelessWidget {
  Signup({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                      key: _formKey,
                      margin: EdgeInsetsDirectional.only(top: 30),
                      child: Form(
                        child: Column(
                          spacing: 20,
                          children: [
                            Input(label: 'Name', placeholder: 'Name'),
                            Input(label: 'Email', placeholder: 'Email'),
                            Input(
                              label: 'Password',
                              placeholder: 'Password',
                              variant: 'password',
                            ),
                            Input(
                              label: 'Repeat Password',
                              placeholder: 'Repeat Password',
                              variant: 'password',
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
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
