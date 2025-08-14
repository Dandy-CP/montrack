import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class CreatePocket extends ConsumerStatefulWidget {
  const CreatePocket({super.key});

  @override
  ConsumerState<CreatePocket> createState() => _CreatePocketState();
}

class _CreatePocketState extends ConsumerState<CreatePocket> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String pocketName = '';
  String amount = '';
  String pocketDescription = '';
  String selectedEmoji = '💰';
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    final pocketRequest = ref.watch(pocketRequestProvider.notifier);

    void handleOnAddPocket() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isPending = true;
        });

        try {
          final request = await pocketRequest.createPocket((
            pocketName: pocketName,
            pocketAmount: int.parse(amount),
            pocketDescription: pocketDescription,
            pocketEmoji: selectedEmoji,
          ));

          if (request != null) {
            if (context.mounted) {
              SnackBars.show(context: context, message: request);
              ref.invalidate(getListPocketProvider(page: 1, limit: 10));
              context.pop();
            }
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

    void handlePickEmoji() {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 400,
            color: Colors.white,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() {
                  selectedEmoji = emoji.emoji;
                });
              },
              config: Config(
                height: 450,
                checkPlatformCompatibility: true,
                bottomActionBarConfig: BottomActionBarConfig(enabled: false),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add New Pocket',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => handlePickEmoji(),
                        child: Text(
                          selectedEmoji,
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      Input(
                        label: 'Name',
                        placeholder: 'Name Pocket',
                        enabled: !_isPending,
                        onSaved: (value) => pocketName = value!,
                      ),
                      Input(
                        label: 'Amount',
                        placeholder: '0',
                        keyboardType: TextInputType.number,
                        enabled: !_isPending,
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('IDR')],
                        ),
                        onSaved: (value) => amount = value!,
                      ),
                      Input(
                        label: 'Description',
                        placeholder: 'Description (Optional)',
                        variant: 'multiline',
                        enabled: !_isPending,
                        keyboardType: TextInputType.multiline,
                        isOptional: true,
                        onSaved: (value) => pocketDescription = value!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Button(
              label: 'Add Pocket',
              disabled: _isPending,
              isLoading: _isPending,
              onPressed: () => handleOnAddPocket(),
            ),
          ),
        ],
      ),
    );
  }
}
