import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/providers/storage/secure_storage_provider.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/snackbar.dart';

enum PinType { setup, input, disabled }

class InputPinScreen extends ConsumerStatefulWidget {
  const InputPinScreen({super.key, this.title, this.type});

  final String? title;
  final PinType? type;

  @override
  ConsumerState<InputPinScreen> createState() => _InputPinScreenState();
}

class _InputPinScreenState extends ConsumerState<InputPinScreen> {
  String _pinCode = '';

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(secureStorageProvider);

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
    ];

    void handleSubmit() async {
      final storedPin = await storage.get('user-pin');

      if (widget.type == PinType.setup) {
        await storage.write('user-pin', _pinCode);
        ref.invalidate(secureStorageProvider);
        if (context.mounted) {
          context.pop();
          SnackBars.show(context: context, message: 'Pin has been set');
        }

        return;
      }

      if (widget.type == PinType.input) {
        if (storedPin == _pinCode) {
          if (context.mounted) context.go('/home');
        } else {
          if (context.mounted) {
            SnackBars.show(
              context: context,
              message: 'Wrong pin',
              type: SnackBarsVariant.error,
            );
          }
        }

        return;
      }

      if (widget.type == PinType.disabled) {
        if (storedPin == _pinCode) {
          await storage.delete('user-pin');
          ref.invalidate(secureStorageProvider);

          if (context.mounted) {
            context.pop();
            SnackBars.show(context: context, message: 'Pin has been disabled');
          }
        } else {
          if (context.mounted) {
            SnackBars.show(
              context: context,
              message: 'Wrong pin',
              type: SnackBarsVariant.error,
            );
          }
        }

        return;
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 30,
        children: [
          Text(
            widget.title ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          Text('Please input your pin'),
          OtpTextField(
            numberOfFields: 5,
            styles: otpTextStyles,
            borderWidth: 4.0,
            obscureText: true,
            onSubmit: (String verificationCode) {
              setState(() {
                _pinCode = verificationCode;
              });
            },
          ),
          Padding(
            padding: EdgeInsetsGeometry.directional(start: 30, end: 30),
            child: Button(
              label: 'Continue',
              onPressed: () => handleSubmit(),
              disabled: _pinCode.isEmpty,
            ),
          ),
          if (widget.type != PinType.input)
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
      ),
    );
  }
}
