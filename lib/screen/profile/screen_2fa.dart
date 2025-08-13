import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/auth/auth_model.dart';
import 'package:montrack/service/api/auth_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/skeleton.dart';
import 'package:montrack/widget/elements/snackbar.dart';
import 'package:montrack/widget/modules/app_bar.dart';

enum Type2FA { setup, disabled, input }

class Screen2FA extends ConsumerStatefulWidget {
  const Screen2FA({super.key, this.type});

  final Type2FA? type;

  @override
  ConsumerState<Screen2FA> createState() => _Screen2FAState();
}

class _Screen2FAState extends ConsumerState<Screen2FA> {
  String _otpCode = '';
  bool _isPending = false;
  Type2FA _onScreenWidget = Type2FA.setup;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Enable2FAResponse> enable2FA = ref.watch(
      enable2FAProvider,
    );

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

    void handleEnable2FA() async {
      setState(() {
        _isPending = true;
      });

      try {
        final response = await authRequest.verify2FA(
          payload: {
            'token_pin': _otpCode,
            'totp_secret': enable2FA.value!.data.secret,
          },
        );

        if (response.statusCode == 201) {
          ref.invalidate(getLoggedUserProvider);

          if (context.mounted) {
            context.pop();
            SnackBars.show(
              context: context,
              message: 'Success enable 2FA',
              type: SnackBarsVariant.success,
            );
          }
        }
      } on DioException catch (error) {
        if (context.mounted) {
          SnackBars.show(
            context: context,
            message: error.response?.data['message'] ?? 'Error',
            type: SnackBarsVariant.error,
          );
        }
      } finally {
        setState(() {
          _isPending = false;
        });
      }
    }

    void handleDisable2FA() async {
      setState(() {
        _isPending = true;
      });

      try {
        final response = await authRequest.disabled2FA(
          payload: {'token_pin': _otpCode},
        );

        if (response.statusCode == 201) {
          ref.invalidate(getLoggedUserProvider);

          if (context.mounted) {
            context.pop();
            SnackBars.show(
              context: context,
              message: 'Success disable 2FA',
              type: SnackBarsVariant.success,
            );
          }
        }
      } on DioException catch (error) {
        if (context.mounted) {
          SnackBars.show(
            context: context,
            message: error.response?.data['message'] ?? 'Error',
            type: SnackBarsVariant.error,
          );
        }
      } finally {
        setState(() {
          _isPending = false;
        });
      }
    }

    Widget renderQrCode() {
      return enable2FA.when(
        data: (value) {
          String base64String = value.data.qrCode.split(',')[1];
          Uint8List imageBytes = base64Decode(base64String);

          return Column(
            spacing: 5,
            children: [
              Image.memory(imageBytes, width: 200, height: 200),
              Text('Scan this QR Code with your authenticator app'),
              Text('or'),
              Text('Enter the code below:'),
              Text(
                value.data.secret,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: value.data.secret));
                  SnackBars.show(
                    context: context,
                    message: 'Success copy code',
                  );
                },
                child: Text('Copy code'),
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(15),
                child: Button(
                  label: 'Continue',
                  onPressed: () {
                    setState(() {
                      _onScreenWidget = Type2FA.input;
                    });
                  },
                ),
              ),
            ],
          );
        },
        error: (err, stack) => Column(
          spacing: 5,
          children: [
            SkeletonBox(width: 200, height: 200),
            SkeletonBox(width: 400, height: 20),
            SkeletonBox(width: 300, height: 20),
            SkeletonBox(width: 200, height: 20),
            Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: SkeletonBox(width: double.infinity, height: 50),
            ),
          ],
        ),
        loading: () => Column(
          spacing: 5,
          children: [
            SkeletonBox(width: 200, height: 200),
            SkeletonBox(width: 400, height: 20),
            SkeletonBox(width: 300, height: 20),
            SkeletonBox(width: 200, height: 20),
            Padding(
              padding: EdgeInsetsGeometry.all(20),
              child: SkeletonBox(width: double.infinity, height: 50),
            ),
          ],
        ),
      );
    }

    Widget renderOTPInput() {
      return Column(
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
              onPressed: () {
                if (widget.type == Type2FA.setup) {
                  return handleEnable2FA();
                }

                if (widget.type == Type2FA.disabled) {
                  return handleDisable2FA();
                }
              },
              disabled: _otpCode.isEmpty || _isPending,
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text(
              'Back',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3077E3),
              ),
            ),
          ),
        ],
      );
    }

    Widget renderWidget() {
      if (widget.type == Type2FA.setup && _onScreenWidget == Type2FA.input) {
        return renderOTPInput();
      }

      if (widget.type == Type2FA.disabled) {
        return renderOTPInput();
      }

      return renderQrCode();
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: widget.type == Type2FA.setup ? 'Enable 2FA' : 'Disable 2FA',
        showLeading: true,
        onBack: () => context.pop(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [renderWidget()],
      ),
    );
  }
}
