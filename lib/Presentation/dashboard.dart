import 'package:expensetracker/Presentation/Income/IncomePannel.dart';
import 'package:expensetracker/Presentation/Transaction/TransactionPannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../HelperandServices/DatabaseHelper.dart';
import 'Expense/ExpensePannel.dart';
import '../dataModel/transaction.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({Key? key}) : super(key: key);

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  final TransactionPannel addExpensePannel = TransactionPannel();
  final IncomePannel addIncomePannel = IncomePannel();
  final ExpensePannel expensePannel = ExpensePannel();
  List<Transaction> _transactions = [];
  int _income = 0;
  int expensetotal = 0;
  DateTimeRange? range;

  @override
  void initState() {
    _loadTransactions();
    super.initState();
  }

  void _loadTransactions() async {
    _income = 0;
    expensetotal = 0;
    List<Transaction> transactions = await dbHelper.getAllTransactions();
    if (transactions != null) {
      setState(() {
        _transactions = transactions;
      });
    }
    _transactions.forEach((transaction){
      if(transaction.deducted){
        expensetotal = expensetotal + transaction.amount;
      }else{
        _income = _income + transaction.amount;
      }
    });
  }

  void _saveTransaction(Transaction transaction) async {
    await dbHelper.insertTransaction(transaction);
  }

  Future<void> updateTransactions(Transaction transaction) async {
    await dbHelper.updateTransaction(transaction);
    _loadTransactions();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await dbHelper.deleteTransaction(transaction.dateTime);
    _loadTransactions();
  }

  void _handleTransactionSubmit(Transaction transaction) {
    // Save the submitted transaction to SharedPreferences
    _saveTransaction(transaction);

    // Optionally, update the list in the UI if needed
    setState(() {
      _transactions.add(transaction);
      expensetotal = expensetotal+transaction.amount;
    });

    print('Transaction submitted: $transaction');
  }

  void _handleIncomeSubmit(Transaction income) {
    // Save the submitted transaction to SharedPreferences
    _saveTransaction(income);

    // Optionally, update the list in the UI if needed
    setState(() {
      _transactions.add(income);
      _income = _income+income.amount;
    });
  }

  bool isDateInRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start) && date.isBefore(end) || date.isAtSameMomentAs(start) || date.isAtSameMomentAs(end);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
            color: Color(0xff19191A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with greeting and profile
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Hello, User!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Balance Card
                Container(
                  margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                       Text(
                        '₹ ${_income-expensetotal}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            '**** **** **** 0322',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Income and Expenses Row
                Container(
                  margin: EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Aligns children at the top
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_upward, color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Flexible( // Ensures the Column can adapt its width
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Income',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '₹ $_income',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1, // Ensures the text wraps if necessary
                                      overflow: TextOverflow.ellipsis, // Optional: handle text overflow
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_downward,
                                    color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expenses',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  Text(
                                    '₹ ${expensetotal.toString()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1, // Ensures the text wraps if necessary
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Statistics Section
              ],
            ),
          ),pannel(),
            expensePannel.getPanelWidget(context,updateTransactions,deleteTransaction),
            addIncomePannel.getPanelWidget(context, _handleIncomeSubmit),
            addExpensePannel.getPanelWidget(context, _handleTransactionSubmit,updateTransactions)
          ],
        ),
      ),
    );
  }

  Widget pannel() {
    double screenHeight = MediaQuery.of(context).size.height;
    return SlidingUpPanel(
      borderRadius: BorderRadius.all(Radius.circular(24.0)),
      boxShadow: [
        BoxShadow(
          blurRadius: 20.0,
          color: Colors.grey,
        ),
      ],
      minHeight: 425,
      maxHeight: screenHeight - 80,
      panel: Container(
        padding: EdgeInsets.only(top: 12, left: 24, right: 24,bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 10,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            Row(
              children: [
                addIncomeButton(),
                addExpenseButton(),
              ],
            ),
            SizedBox(height: 6),
            Divider(),
            if (_transactions.isNotEmpty)
              Row(
                children: [
                  FilterChip(
                    label: range == null
                        ? const Text('Select Date Range')
                        : Text(
                        "${DateFormat('d MMM').format(range!.start)} - ${DateFormat('d MMM').format(range!.end)}"),
                    avatar: const Icon(Icons.date_range, size: 16),
                    onSelected: (_) async {
                      DateTimeRange? pickedRange = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        initialDateRange: DateTimeRange(
                          start: DateTime.now().subtract(const Duration(days: 30)),
                          end: DateTime.now(),
                        ),
                      );

                      if (pickedRange != null) {
                        setState(() {
                          range = pickedRange;
                        });
                      }
                    },
                    selected: false,
                  ),
                  SizedBox(width: 6),
                  if (range != null)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          range = null;
                        });
                      },
                      child: Text("Clear"),
                    ),
                ],
              ),
            Expanded(
              child: _transactions.isEmpty
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "No Records Found",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "You can add Expense using 'Add Expense'\nButton Above",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction =
                  _transactions[_transactions.length - 1 - index];
                  if (range == null ||
                      isDateInRange(
                          transaction.dateTime, range!.start, range!.end)) {
                    return expense(transaction);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget expense(Transaction transaction) {
    return InkWell(
      onTap: (){
        setState(() {
          expensePannel.togglePanel(transaction);
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 8, bottom: 12),
        child: Row(
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
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  DateFormat('d MMMM yyyy - HH:mm').format(transaction.dateTime),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            Text(
              "₹ ${transaction.amount}",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: transaction.deducted ? Colors.red : Colors.green),
            )
          ],
        ),
      ),
    );
  }

  Widget addIncomeButton(){
    return Expanded(
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors
                    .transparent), // Transparent background
            elevation: MaterialStateProperty.all(
                0), // Remove elevation (shadow)
            padding: MaterialStateProperty.all(
                EdgeInsets.zero), // Remove padding
            shape: MaterialStateProperty.all(
                OutlinedBorder.lerp(
                    null, null, 0)), // Remove shape
          ),
          onPressed: () {
            addIncomePannel.togglePanel();
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Add Income',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget addExpenseButton(){
    return Expanded(
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                Colors
                    .transparent), // Transparent background
            elevation: MaterialStateProperty.all(
                0), // Remove elevation (shadow)
            padding: MaterialStateProperty.all(
                EdgeInsets.zero), // Remove padding
            shape: MaterialStateProperty.all(
                OutlinedBorder.lerp(
                    null, null, 0)), // Remove shape
          ),
          onPressed: () {
            addIncomePannel.togglePanel();
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  'Add Expense',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
