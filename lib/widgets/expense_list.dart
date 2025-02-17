import 'package:expense_app/model/expense.dart';
import 'package:expense_app/widgets/edit.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
              backgroundColor: Colors.white,
              child: Icon(
                expense.category == 'Food' ? Icons.dining_outlined: 
                expense.category == 'Transport' ? Iconsax.car : 
                expense.category == 'Bills' ? Iconsax.moneys :
                expense.category == 'Travel' ? Iconsax.airplane :
                expense.category == 'Entertainment'? Iconsax.speaker : 
                    Icons.question_mark, 
                    color: Color(0xFF3F7CAC),
              ),
            ),
            title: Text(expense.title),
            subtitle: Text(
              "GHc ${NumberFormat("#,##0.00").format(expense.amount)} - ${expense.category}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Iconsax.edit_24, color: Colors.blue),
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
                  icon: Icon(Iconsax.trash, color: Colors.red),
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
