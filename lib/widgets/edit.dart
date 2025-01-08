import 'package:expense_app/model/expense.dart';
import 'package:flutter/material.dart';


class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final int index;
  final Function editExpense;

  const EditExpenseScreen({super.key, 
    required this.expense,
    required this.index,
    required this.editExpense,
  });

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late String _selectedCategory;

  final List<String> _categories = ['Food', 'Entertainment', 'Bills', 'Travel', 'Others'];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.expense.title;
    _amountController.text = widget.expense.amount.toString();
    _selectedCategory = widget.expense.category;
  }

  void _submitEditExpense() {
    final updatedExpense = Expense(
      title: _titleController.text,
      amount: double.tryParse(_amountController.text) ?? 0.0,
      date: widget.expense.date,
      category: _selectedCategory,
    );

    widget.editExpense(widget.index, updatedExpense);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _submitEditExpense,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
