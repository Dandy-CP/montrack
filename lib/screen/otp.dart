import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/snackbar.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  String _otpCode = '';
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(secureStorageProvider);
    final authRequest = ref.watch(authProvider.notifier);

    TextStyle? createStyle(Color color) {
      ThemeData theme = Theme.of(context);
      return theme.textTheme.headlineLarge?.copyWith(color: color);
    }

    final otpTextStyles = [
      createStyle(Colors.black),
      createStyle(Colors.black),
      createStyle(Colors.black),
      createStyle(Colors.black),
      createStyle(Colors.black),
      createStyle(Colors.black),
    ];

    void handleOnSubmit() async {
      setState(() {
        _isPending = true;
      });

      try {
        final response = await authRequest.validate2FA(
          payload: {'user_id': widget.userId, 'token_pin': _otpCode},
        );

        if (response.statusCode == 201) {
          final value = AuthLoginResponse.fromJson(response.data);

          storage.write('access_token', value.data.accessToken);
          storage.write('refresh_token', value.data.refreshToken);

          if (context.mounted) context.replace('/home');
        }
      } on DioException catch (error) {
        if (context.mounted) {
          SnackBars.show(
            context: context,
            message: error.response?.data['message'] ?? 'Ops Something Wrong',
            type: SnackBarsVariant.error,
          );
        }
      } finally {
        setState(() {
          _isPending = false;
        });
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          Text(
            'Verification Code',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text('Please input code from your authenticator'),
          OtpTextField(
            numberOfFields: 6,
            styles: otpTextStyles,
            borderWidth: 4.0,
            enabled: !_isPending,
            onSubmit: (String verificationCode) {
              setState(() {
                _otpCode = verificationCode;
              });
            },
          ),
          Padding(
            padding: EdgeInsetsGeometry.directional(start: 30, end: 30),
            child: Button(
              label: 'Submit',
              onPressed: () => handleOnSubmit(),
              disabled: _otpCode.isEmpty || _isPending,
            ),
          ),
          TextButton(
            onPressed: () {
              context.go('/login');
            },
            child: Text(
              'Back to login',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3077E3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
