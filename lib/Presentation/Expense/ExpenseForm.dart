import 'package:flutter/material.dart'
;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dataModel/transaction.dart';
class ExpenseForm extends StatefulWidget {
  final Transaction transaction;
  final Function onClose;  // Callback for closing the panel
  final Function update;
  final Function delete;

  const ExpenseForm({
    Key? key,
    required this.transaction,
    required this.delete,
    required this.update,
    required this.onClose,
  }) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.compare_arrows_sharp,
                  color: Colors.grey,
                  size: 40,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat('d MMMM yyyy - HH:mm').format(widget.transaction.dateTime),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 32,),
          Text(
            "₹ ${widget.transaction.amount}",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: widget.transaction.deducted ? Colors.red : Colors.green),
          ),
          Spacer(),
          Row(
            children: [
              // Expanded(child: ElevatedButton(
              //   onPressed: () {
              //
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.white.withOpacity(0.8), // Red color with 0.8 opacity
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8), // Optional: You can modify the corner radius
              //     ),
              //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Optional: Adjust button padding
              //   ),
              //   child: const Text(
              //     'Modify',
              //     style: TextStyle(
              //       fontSize: 16, // Adjust the font size as needed
              //       color: Colors.black, // Text color
              //     ),
              //   ),
              // ),),
              // SizedBox(width: 16,),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  widget.delete(widget.transaction);
                  widget.onClose();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.8), // Red color with 0.8 opacity
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Optional: You can modify the corner radius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Optional: Adjust button padding
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 16, // Adjust the font size as needed
                    color: Colors.white, // Text color
                  ),
                ),
              ),)
            ],
          )
        ],
      ),
    );
  }
}
