import 'package:expense_app/model/expense.dart';
import 'package:expense_app/widgets/edit.dart';
import 'package:flutter/material.dart';


class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(int) deleteExpense;
  final Function(int, Expense) editExpense;

  const ExpenseList({super.key, 
    required this.expenses,
    required this.deleteExpense,
    required this.editExpense,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Allows ListView to fit its content
  physics: NeverScrollableScrollPhysics(), // Prevents nested scroll conflicts
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(expense.category[0]),
            ),
            
            title: Text(expense.title),
            subtitle: Text(
              '\$${expense.amount.toStringAsFixed(2)} - ${expense.category}',
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
