import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';
import '../Transaction/TransactionForm.dart';
import '../../dataModel/transaction.dart';
import 'ExpenseForm.dart'; // For formatting the DateTime

class ExpensePannel {
  final PanelController _panelController = PanelController();
  Transaction? transaction;

  // Method to show the panel
  void showPanel() {
    _panelController.open();
  }

  // Method to hide the panel
  void hidePanel() {
    _panelController.close();
  }

  // Method to toggle panel visibility
  void togglePanel(Transaction trans) {
    if (_panelController.isPanelOpen) {
      transaction = null;
      hidePanel();
    } else {
      transaction = trans;
      print("got $trans and $transaction");
      showPanel();
    }
  }

  // Method to get the SlidingUpPanel widget
  SlidingUpPanel getPanelWidget(
      BuildContext context,
      Function(Transaction) updateTransactions,
      Function(Transaction) deleteTransaction,
      ) {
    return SlidingUpPanel(
      controller: _panelController,
      panel: transaction!=null?ExpenseForm(
        transaction: transaction!,
        onClose: hidePanel,  // Pass the hidePanel method to close the panel
        delete: deleteTransaction,
        update: updateTransactions
      ):Container(),
      minHeight: 0,  // Minimum height of the panel
      maxHeight: 250,  // Maximum height of the panel
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      backdropEnabled: true,
      backdropOpacity: 0.5,
    );
  }
}
