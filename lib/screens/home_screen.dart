import 'package:expense_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../widgets/expense_list.dart';
import 'add_expense_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  final double amount;

  const HomeScreen({super.key, required this.amount});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  String _selectedFilter = 'Today';
  late double _estimatedBudget;

  @override
  void initState() {
    super.initState();
    _estimatedBudget = widget.amount;
  }

  void _updateEstimatedBudget(double newBudget) {
    setState(() {
      _estimatedBudget = newBudget;
    });
  }

  void _addExpense(
      String title, double amount, DateTime date, String category) {
    setState(() {
      _expenses.add(Expense(
          title: title, amount: amount, date: date, category: category));
    });
  }

  void _deleteExpense(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  void _editExpense(int index, Expense newExpense) {
    setState(() {
      _expenses[index] = newExpense;
    });
  }

  double _calculateTotal() {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  List<Expense> _getFilteredExpenses() {
    final now = DateTime.now();

    if (_selectedFilter == 'Today') {
      return _expenses.where((expense) {
        return expense.date.difference(now).inDays == 0;
      }).toList();
    } else if (_selectedFilter == 'Week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      return _expenses.where((expense) {
        return expense.date.difference(startOfWeek).inDays >= 0 &&
            expense.date.difference(startOfWeek).inDays <= 6;
      }).toList();
    } else if (_selectedFilter == 'Month') {
      return _expenses.where((expense) {
        return expense.date.difference(DateTime(now.year, now.month)).inDays >=
                0 &&
            expense.date.difference(DateTime(now.year, now.month + 1)).inDays <
                0;
      }).toList();
    }

    return _expenses;
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _getFilteredExpenses();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Bandoh',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
            SizedBox(height: 10),
            WalletCard(
              estimatedBudget: _estimatedBudget,
              totalExpenses: _calculateTotal(),
              onSave: (newBudget) {
                _updateEstimatedBudget(newBudget);
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Today', 'Week', 'Month'].map((filter) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: _selectedFilter == filter
                          ? Color(0xFF3F7CAC)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: _selectedFilter == filter
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AnalyticsSection(
                        expenses:
                            filteredExpenses.isEmpty ? [] : filteredExpenses),
                    filteredExpenses.isEmpty
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Text(
                                'No expenses added',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                          )
                        : ExpenseList(
                            expenses: filteredExpenses,
                            deleteExpense: _deleteExpense,
                            editExpense: _editExpense,
                          ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F4858),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(400, 50),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => AddExpenseScreen(_addExpense),
                  ),
                );
              },
              child: Text(
                'Create Expense',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletCard extends StatelessWidget {
  final double estimatedBudget;
  final double totalExpenses;
  final Function(double) onSave;

  const WalletCard(
      {super.key,
      required this.estimatedBudget,
      required this.totalExpenses,
      required this.onSave});

  @override
  Widget build(BuildContext context) {
    double availableBalance = estimatedBudget - totalExpenses;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF33658A), Color(0xFF86BBD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(80, 0, 0, 0),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Estimated Budget",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "GHc ${NumberFormat("#,##0.00").format(estimatedBudget)}",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            final amountController = TextEditingController(
                              text: estimatedBudget.toStringAsFixed(2),
                            );

                            return AlertDialog(
                              title: Text('Edit Estimated Budget'),
                              content: TextField(
                                controller: amountController,
                                keyboardType: TextInputType.number,
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('Save'),
                                  onPressed: () {
                                    
                                    onSave(
                                        double.parse(amountController.text));
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Iconsax.edit, color: Colors.white),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  title: "Total Expenses",
                  value:   "GHc ${NumberFormat("#,##0.00").format(totalExpenses)}",
                ),
                _buildInfoColumn(
                  title: "Available Balance",
                  value:   "GHc ${NumberFormat("#,##0.00").format(availableBalance)}",
                  valueColor: availableBalance < 0 ? Colors.red : const Color.fromARGB(255, 128, 255, 132),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn({
    required String title,
    required String value,
    Color valueColor = Colors.white,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class AnalyticsSection extends StatelessWidget {
  final List<Expense> expenses;

  const AnalyticsSection({super.key, required this.expenses});

  List<PieChartSectionData> _getSections() {
    final categoryAmounts = <String, double>{};

    for (var expense in expenses) {
      categoryAmounts[expense.category] =
          (categoryAmounts[expense.category] ?? 0) + expense.amount;
    }

    return categoryAmounts.entries.map((entry) {
      final Map<String, Color> categoryColors = {
        'Food': Color(0xFF33658A),
        'Entertainment': Color(0xFF2F4858),
        'Bills': Color(0xFFF6AE2D),
        'Travel': Color(0xFFF26419),
        'Transport': Color(0xFF86BBD8),
        'Others': Color(0xFF33654A)
      };

      return PieChartSectionData(
        color: categoryColors[entry.key],
        value: entry.value,
        title: entry.key,
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        radius: 110,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 1.5,
        child: PieChart(
          PieChartData(
            sections: _getSections(),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
