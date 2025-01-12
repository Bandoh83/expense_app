import 'package:expense_app/model/expense.dart';
import 'package:expense_app/widgets/edit.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(int) deleteExpense;
  final Function(int, Expense) editExpense;

  const ExpenseList({
    super.key,
    required this.expenses,
    required this.deleteExpense,
    required this.editExpense,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return Card(
          color: Color(0xFFF5F5F5),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Icon(
                expense.category == 'Food' ? Icons.restaurant: 
                expense.category == 'Transport' ? Icons.directions_car : 
                expense.category == 'Bills' ? Icons.payment :
                expense.category == 'Travel' ? Icons.flight :
                expense.category == 'Others' ? Icons.question_mark :
                expense.category == 'Entertainment'? Icons.movie : 
                    Icons.question_mark, // default icon
              ),
            ),
            title: Text(expense.title),
            subtitle: Text(
              'GHc ${expense.amount.toStringAsFixed(2)} - ${expense.category}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => EditExpenseScreen(
                          expense: expense,
                          index: index,
                          editExpense: editExpense,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteExpense(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
