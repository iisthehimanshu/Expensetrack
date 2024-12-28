import 'package:flutter/material.dart'
;
import 'package:intl/intl.dart';

import '../../dataModel/transaction.dart';
class TransactionForm extends StatefulWidget {
  Transaction? preFiledTransaction;
  final Function(Transaction) onTransactionSubmit;
  final Function(Transaction) update;
  final Function onClose;  // Callback for closing the panel

   TransactionForm({
    Key? key,
    required this.onTransactionSubmit,
    required this.onClose,
     required this.update,
     this.preFiledTransaction
  }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  
  @override
  void initState() {
    if(widget.preFiledTransaction != null){
      _nameController.text = widget.preFiledTransaction!.name;
      _amountController.text = widget.preFiledTransaction!.amount.toString();
      _descriptionController.text = widget.preFiledTransaction!.description??"";
      _selectedDate = widget.preFiledTransaction!.dateTime;
    }
    super.initState();
  }

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
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Transaction Name'),
          ),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          widget.preFiledTransaction== null?ListTile(
            title: Text('Date: ${DateFormat('d MMMM yyyy').format(_selectedDate)}'),
            trailing: Icon(Icons.calendar_today),
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (selected != null && selected != _selectedDate) {
                setState(() {
                  _selectedDate = selected;
                });
              }
            },
          ):Container(),
          ElevatedButton(
            onPressed: () {
              
              final name = _nameController.text;
              final amount = int.tryParse(_amountController.text) ?? 0;
              final description = _descriptionController.text.isEmpty?"null":_descriptionController.text;
              final transaction = Transaction(
                name: name,
                dateTime: _selectedDate,
                amount: amount,
                description: description,
                deducted: true,
              );
              if(widget.preFiledTransaction != null){
                widget.update(transaction);
              }else{
                widget.onTransactionSubmit(transaction);
              }
              _nameController.clear();// Pass the transaction to the callback
              _amountController.clear();
              _selectedDate = DateTime.now();
              FocusScope.of(context).unfocus();
              widget.onClose();
            },
            child: widget.preFiledTransaction==null?Text('Submit Transaction'):Text("Modify Transaction"),
          ),
        ],
      ),
    );
  }
}
