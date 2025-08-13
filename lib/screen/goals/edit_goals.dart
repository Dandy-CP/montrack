import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:montrack/models/goals/goals_detail_model.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/image_input.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/elements/snackbar.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class EditGoalsScreen extends ConsumerStatefulWidget {
  const EditGoalsScreen({super.key, required this.goalsId});

  final String goalsId;

  @override
  ConsumerState<EditGoalsScreen> createState() => _EditGoalsScreenState();
}

class _EditGoalsScreenState extends ConsumerState<EditGoalsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String goalsName = '';
  String goalsAmount = '';
  String goalsSetAmount = '';
  String goalsDescription = '';
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GoalsDetailResponse> goalsDetail = ref.watch(
      getGoalsDetailProvider(goalsId: widget.goalsId),
    );

    final goalsRequest = ref.watch(goalsRequestProvider.notifier);

    TextEditingController goalsNameController = TextEditingController(
      text: goalsDetail.value?.data.goalsName,
    );

    TextEditingController goalsAmountController = TextEditingController(
      text: goalsDetail.value?.data.goalsAmount.toString(),
    );

    TextEditingController goalsSetAmountController = TextEditingController(
      text: goalsDetail.value?.data.goalsSetAmount.toString(),
    );

    TextEditingController goalsDescriptionController = TextEditingController(
      text: goalsDetail.value?.data.goalsDescription,
    );

    void handleEditGoals() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        context.loaderOverlay.show();

        final formDataPayload = FormData.fromMap({
          if (selectedImage != null)
            'attachment_file': await MultipartFile.fromFile(
              selectedImage!.path,
            ),
          'goals_name': goalsName,
          'goals_amount': goalsAmount,
          'goals_set_amount': goalsSetAmount,
          'goals_description': goalsDescription,
        });

        try {
          final response = await goalsRequest.updateGoals(
            goalsId: widget.goalsId,
            payload: formDataPayload,
          );

          if (response.statusCode == 200) {
            if (context.mounted) {
              context.pop();
              ref.invalidate(getListGoalsProvider(page: 1, limit: 10));
              SnackBars.show(context: context, message: 'Success edit goals');
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
          if (context.mounted) context.loaderOverlay.hide();
        }
      }
    }

    goalsDetail.when(
      data: (value) => context.loaderOverlay.hide(),
      error: (err, stack) => SnackBars.show(
        context: context,
        message: 'Error when get data',
        type: SnackBarsVariant.error,
      ),
      loading: () => context.loaderOverlay.show(),
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Create Goals',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                spacing: 20,
                children: [
                  Input(
                    label: 'Goals Name',
                    placeholder: 'Goals Name',
                    controller: goalsNameController,
                    onSaved: (value) => goalsName = value!,
                  ),
                  Input(
                    label: 'Goals Set Amount',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    controller: goalsSetAmountController,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('IDR')],
                    ),
                    onSaved: (value) => goalsSetAmount = value!,
                  ),
                  Input(
                    label: 'Amount',
                    placeholder: '0',
                    keyboardType: TextInputType.number,
                    controller: goalsAmountController,
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('IDR')],
                    ),
                    onSaved: (value) => goalsAmount = value!,
                  ),
                  Input(
                    label: 'Description',
                    placeholder: 'Description (Optional)',
                    controller: goalsDescriptionController,
                    variant: 'multiline',
                    isOptional: true,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) => goalsDescription = value!,
                  ),
                  ImageInput(
                    defaultImage: goalsDetail.value?.data.goalsAttachment,
                    onPickImage: (file) {
                      setState(() {
                        selectedImage = file;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Button(label: 'Edit Goals', onPressed: () => handleEditGoals()),
          ],
        ),
      ),
    );
  }
}
