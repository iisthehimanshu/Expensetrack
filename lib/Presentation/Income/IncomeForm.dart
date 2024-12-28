import 'package:flutter/material.dart'
;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dataModel/transaction.dart';
class IncomeForm extends StatefulWidget {
  final Function(Transaction) onIncomeSubmit;
  final Function onClose;  // Callback for closing the panel

  const IncomeForm({
    Key? key,
    required this.onIncomeSubmit,
    required this.onClose,
  }) : super(key: key);

  @override
  _IncomeFormState createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Close Button at the top
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                widget.onClose();  // Close the panel when pressed
              },
            ),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),

          ElevatedButton(
            onPressed: () async {
              final amount = int.tryParse(_amountController.text) ?? 0;
              final transaction = Transaction(
                name: "Credit",
                dateTime: DateTime.now(),
                amount: amount,
                description: "",
                deducted: false,
              );
              _amountController.clear();
              widget.onIncomeSubmit(transaction);
              FocusScope.of(context).unfocus();
              widget.onClose();
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
