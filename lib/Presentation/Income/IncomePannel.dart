import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:intl/intl.dart';

import '../Transaction/TransactionForm.dart';
import '../../dataModel/transaction.dart';
import 'IncomeForm.dart'; // For formatting the DateTime

class IncomePannel {
  final PanelController _panelController = PanelController();

  // Method to show the panel
  void showPanel() {
    _panelController.open();
  }

  // Method to hide the panel
  void hidePanel() {
    _panelController.close();
  }

  // Method to toggle panel visibility
  void togglePanel() {
    if (_panelController.isPanelOpen) {
      hidePanel();
    } else {
      showPanel();
    }
  }

  // Method to get the SlidingUpPanel widget
  SlidingUpPanel getPanelWidget(
      BuildContext context,
      Function(Transaction) onIncomeSubmit,
      ) {
    return SlidingUpPanel(
      controller: _panelController,
      panel: IncomeForm(
        onIncomeSubmit: onIncomeSubmit,
        onClose: hidePanel,  // Pass the hidePanel method to close the panel
      ),
      minHeight: 0,  // Minimum height of the panel
      maxHeight: 400,  // Maximum height of the panel
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      backdropEnabled: true,
      backdropOpacity: 0.5,
    );
  }
}
