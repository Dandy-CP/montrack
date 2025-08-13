import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class CreateWalletScreen extends ConsumerStatefulWidget {
  const CreateWalletScreen({super.key});

  @override
  ConsumerState<CreateWalletScreen> createState() => _CreateWalletScreenState();
}

class _CreateWalletScreenState extends ConsumerState<CreateWalletScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String walletName = '';
  String walletAmount = '';
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    final walletRequest = ref.watch(walletRequestProvider.notifier);

    void handleCreateWallet() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isPending = true;
        });

        try {
          final response = await walletRequest.createWallet({
            'wallet_name': walletName,
            'wallet_amount': int.parse(walletAmount),
          });

          if (response.statusCode == 201 && context.mounted) {
            context.pop();
            SnackBars.show(context: context, message: 'Wallet created');
            ref.invalidate(walletListProvider(page: 1, limit: 10));
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
      appBar: AppBarWidget(
        title: 'Create Wallet',
        showLeading: true,
        onBack: () => context.pop(),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          spacing: 20,
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 15,
                children: [
                  Input(
                    label: 'Wallet Name',
                    placeholder: 'Wallet Name',
                    onSaved: (value) => walletName = value!,
                    enabled: !_isPending,
                  ),
                  Input(
                    label: 'Wallet Amount',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('IDR')],
                    ),
                    onSaved: (value) => walletAmount = value!,
                    enabled: !_isPending,
                  ),
                ],
              ),
            ),
            Button(
              label: 'Create Wallet',
              onPressed: () => handleCreateWallet(),
              disabled: _isPending,
              isLoading: _isPending,
            ),
          ],
        ),
      ),
    );
  }
}
