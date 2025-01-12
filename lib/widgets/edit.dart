import 'package:expense_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final int index;
  final Function editExpense;

  const EditExpenseScreen({
    super.key,
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

  final List<String> _categories = [
    'Food',
    'Entertainment',
    'Bills',
    'Travel',
    'Transport',
    'Others'
  ];

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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          //  TextFormField(
          //     controller: _titleController,
          //     decoration: InputDecoration(
          //       labelText: 'Description',
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //   ),

          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixText: 'GHc ',
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(400, 50),
              ),
              onPressed: _submitEditExpense,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
