import 'package:expense_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/expense_list.dart';
import 'add_expense_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];
  String _selectedFilter = 'Today';
  final double _estimatedBudget = 2000.0;

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
        return expense.date.year == now.year &&
            expense.date.month == now.month &&
            expense.date.day == now.day;
      }).toList();
    } else if (_selectedFilter == 'Week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(Duration(days: 6));
      return _expenses.where((expense) {
        return expense.date
                .isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
            expense.date.isBefore(endOfWeek.add(Duration(seconds: 1)));
      }).toList();
    } else if (_selectedFilter == 'Month') {
      return _expenses.where((expense) {
        return expense.date.year == now.year && expense.date.month == now.month;
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
                          ? Colors.blue
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                    AnalyticsSection(
                        expenses:
                            filteredExpenses.isEmpty ? [] : filteredExpenses),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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

  const WalletCard(
      {super.key, required this.estimatedBudget, required this.totalExpenses});

  @override
  Widget build(BuildContext context) {
    double availableBalance = estimatedBudget - totalExpenses;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                Text(
                  "\$${estimatedBudget.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn(
                  title: "Total Expenses",
                  value: "\$${totalExpenses.toStringAsFixed(2)}",
                ),
                _buildInfoColumn(
                  title: "Available Balance",
                  value: "\$${availableBalance.toStringAsFixed(2)}",
                  valueColor: availableBalance < 0 ? Colors.red : Colors.green,
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
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
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
        'Food': Colors.blue,
        'Entertainment': Colors.purple,
        'Bills': Colors.teal,
        'Travel': Colors.grey,
        'Others': Colors.pinkAccent
      };

      return PieChartSectionData(
        color: categoryColors[entry.key],
        value: entry.value,
        title: '${entry.key}: \$${entry.value.toStringAsFixed(2)}',
        radius: 40,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AspectRatio(
        aspectRatio: 3,
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
