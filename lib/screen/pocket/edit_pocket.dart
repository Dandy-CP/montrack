import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/models/pocket/pocket_detail_model.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class EditPocket extends ConsumerStatefulWidget {
  const EditPocket({super.key, required this.pocketId});

  final String pocketId;

  @override
  ConsumerState<EditPocket> createState() => _EditPocketState();
}

class _EditPocketState extends ConsumerState<EditPocket> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String pocketName = '';
  String amount = '';
  String pocketDescription = '';
  String selectedEmoji = '';
  bool _isPending = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<PocketDetailResponse> pocketDetail = ref.watch(
      getPocketDetailProvider(widget.pocketId),
    );

    final pocketRequest = ref.watch(pocketRequestProvider.notifier);

    TextEditingController pocketNameController = TextEditingController(
      text: pocketDetail.value?.data.pocketName,
    );

    TextEditingController pocketAmountController = TextEditingController(
      text: pocketDetail.value?.data.pocketAmmount.toString(),
    );

    TextEditingController pocketDescriptionController = TextEditingController(
      text: pocketDetail.value?.data.pocketDescription,
    );

    pocketDetail.when(
      data: (value) => context.loaderOverlay.hide(),
      loading: () => context.loaderOverlay.show(),
      error: (error, stack) {
        SnackBars.show(
          context: context,
          message: 'Error when get data',
          type: SnackBarsVariant.error,
        );
      },
    );

    void handleOnEditPocket() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isPending = true;
        });

        try {
          final request = await pocketRequest.updatePocket(
            pocketId: widget.pocketId,
            payload: (
              pocketName: pocketName,
              pocketAmount: int.parse(amount),
              pocketDescription: pocketDescription,
              pocketEmoji: selectedEmoji.isNotEmpty
                  ? selectedEmoji
                  : pocketDetail.value?.data.pocketEmoji ?? '',
            ),
          );

          if (request.statusCode == 200) {
            if (context.mounted) {
              SnackBars.show(
                context: context,
                message: 'Success update pocket',
                type: SnackBarsVariant.success,
              );
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
        title: 'Edit Pocket',
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
                          selectedEmoji.isNotEmpty
                              ? selectedEmoji
                              : pocketDetail.when(
                                  data: (value) => value.data.pocketEmoji,
                                  error: (err, stack) => '',
                                  loading: () => '',
                                ),
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                      Input(
                        label: 'Name',
                        placeholder: 'Name Pocket',
                        controller: pocketNameController,
                        enabled: !_isPending,
                        onSaved: (value) => pocketName = value!,
                      ),
                      Input(
                        label: 'Amount',
                        placeholder: '0',
                        controller: pocketAmountController,
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
                        controller: pocketDescriptionController,
                        variant: 'multiline',
                        enabled: !_isPending,
                        keyboardType: TextInputType.multiline,
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
              label: 'Edit Pocket',
              disabled: _isPending,
              isLoading: _isPending,
              onPressed: () => handleOnEditPocket(),
            ),
          ),
        ],
      ),
    );
  }
}
