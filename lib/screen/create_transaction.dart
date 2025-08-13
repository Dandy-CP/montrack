import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:montrack/models/goals/goals_list_model.dart';
import 'package:montrack/models/pocket/pocket_list_model.dart';
import 'package:montrack/service/api/goals_api.dart';
import 'package:montrack/service/api/pocket_api.dart';
import 'package:montrack/service/api/transaction_api.dart';
import 'package:montrack/service/api/wallet_api.dart';
import 'package:montrack/utils/formated_date.dart';
import 'package:montrack/widget/elements/button.dart';
import 'package:montrack/widget/elements/dropdown_input.dart';
import 'package:montrack/widget/elements/image_input.dart';
import 'package:montrack/widget/elements/input.dart';
import 'package:montrack/widget/modules/app_bar.dart';

class CreateTransaction extends ConsumerStatefulWidget {
  const CreateTransaction({super.key});

  @override
  ConsumerState<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends ConsumerState<CreateTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _trxName = '';
  String _trxAmount = '';
  String _trxDescription = '';
  String? _selectedTransactionType;
  String? _selectedTransactionFrom;
  DateTime? _selectedDate;
  String? _selectedTrxIdFrom;
  File? _selectedImage;
  bool _isPending = false;

  final List<Map<String, dynamic>> transactionTypeOptions = [
    {'label': 'Income', 'value': 'INCOME'},
    {'label': 'Expense', 'value': 'EXPENSE'},
  ];

  final List<Map<String, dynamic>> transactionFromOptions = [
    {'label': 'Wallet', 'value': 'WALLET'},
    {'label': 'Pocket', 'value': 'POCKET'},
    {'label': 'Goals', 'value': 'GOALS'},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trxRequest = ref.watch(transactionRequestProvider.notifier);

    final AsyncValue<PocketListResponse> pocketList = ref.watch(
      getListPocketProvider(page: 1, limit: 10),
    );

    final AsyncValue<GoalsListResponse> goalsList = ref.watch(
      getListGoalsProvider(page: 1, limit: 10),
    );

    final List<Map<String, dynamic>> pocketOptions = pocketList.when(
      data: (value) {
        return value.data
            .map((data) => {'label': data.pocketName, 'value': data.pocketId})
            .toList();
      },
      loading: () => [],
      error: (error, stackTrace) => [],
    );

    final List<Map<String, dynamic>> goalsOptions = goalsList.when(
      data: (value) {
        return value.data
            .map((data) => {'label': data.goalsName, 'value': data.goalsId})
            .toList();
      },
      loading: () => [],
      error: (error, stackTrace) => [],
    );

    void handleCreateTransaction() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        setState(() {
          _isPending = true;
        });

        final formDataPayload = FormData.fromMap({
          'transaction_name': _trxName,
          'transaction_ammount': _trxAmount,
          'transaction_type': _selectedTransactionType,
          'transaction_from': _selectedTransactionFrom,
          'transaction_description': _trxDescription,
          'transaction_date': _selectedDate?.toIso8601String(),
          if (_selectedImage != null)
            'attachment_file': await MultipartFile.fromFile(
              _selectedImage!.path,
            ),
          if (_selectedTrxIdFrom != null &&
              _selectedTransactionFrom == 'POCKET')
            'pocketId': _selectedTrxIdFrom,
          if (_selectedTrxIdFrom != null && _selectedTransactionFrom == 'GOALS')
            'goalsId': _selectedTrxIdFrom,
        });

        try {
          final response = await trxRequest.createTransaction(formDataPayload);

          if (response.statusCode == 201) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Transaction created successfully')),
              );

              ref.invalidate(getActiveWalletProvider);
              ref.invalidate(transactionListRequestProvider);
              ref.invalidate(getTransactionSummaryProvider);

              if (_selectedTransactionFrom == 'POCKET') {
                ref.invalidate(getListPocketProvider(page: 1, limit: 10));
              } else if (_selectedTransactionFrom == 'GOALS') {
                ref.invalidate(getListGoalsProvider(page: 1, limit: 10));
              }

              context.pop();
            }
          }
        } on DioException catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${error.response?.data['message'] ?? 'Ops Something Wrong'}',
                ),
              ),
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
        title: 'New Transaction',
        showLeading: true,
        onBack: () {
          context.pop();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsetsGeometry.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 15,
            children: [
              Input(
                label: 'Transaction Name',
                placeholder: 'Enter transaction name',
                enabled: !_isPending,
                onSaved: (value) => _trxName = value!,
              ),

              DropdownInput(
                label: 'Transaction Type',
                placeholder: 'Select Transaction Type',
                selectedOption: _selectedTransactionType,
                options: transactionTypeOptions,
                enabled: !_isPending,
                onSelected: (value) {
                  setState(() {
                    _selectedTransactionType = value;
                  });
                },
              ),

              DropdownInput(
                label: 'Transaction From',
                placeholder: 'Select Transaction From',
                selectedOption: _selectedTransactionFrom,
                options: transactionFromOptions,
                enabled: !_isPending,
                onSelected: (value) {
                  setState(() {
                    _selectedTransactionFrom = value;
                  });
                },
              ),

              if (_selectedTransactionFrom != null &&
                  _selectedTransactionFrom != 'WALLET')
                DropdownInput(
                  label: 'Select ${_selectedTransactionFrom!.toLowerCase()}',
                  placeholder:
                      'Select ${_selectedTransactionFrom!.toLowerCase()}',
                  selectedOption: _selectedTrxIdFrom,
                  options: _selectedTransactionFrom == 'POCKET'
                      ? pocketOptions
                      : goalsOptions,
                  enabled: !_isPending,
                  onSelected: (value) {
                    setState(() {
                      _selectedTrxIdFrom = value;
                    });
                  },
                ),

              Input(
                label: 'Date',
                placeholder: _selectedDate != null
                    ? formattedDate(_selectedDate!.toLocal().toString())
                    : 'Select Transaction Date',
                readOnly: true,
                suffixIcon: Icon(Icons.calendar_month),
                onTap: () => _selectDate(context),
                isOptional: _selectedDate != null,
                enabled: !_isPending,
              ),

              Input(
                label: 'Amount',
                placeholder: '0',
                keyboardType: TextInputType.number,
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('IDR')],
                ),
                onSaved: (value) => _trxAmount = value!,
                enabled: !_isPending,
              ),

              Input(
                label: 'Description',
                placeholder: 'Description (Optional)',
                variant: 'multiline',
                keyboardType: TextInputType.multiline,
                onSaved: (value) => _trxDescription = value!,
                enabled: !_isPending,
                isOptional: true,
              ),

              ImageInput(
                onPickImage: (file) {
                  setState(() {
                    _selectedImage = file;
                  });
                },
                enabled: !_isPending,
              ),

              Button(
                label: 'Create Transaction',
                onPressed: () => handleCreateTransaction(),
                disabled: _isPending,
                isLoading: _isPending,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
