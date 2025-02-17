import 'package:expense_app/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  EditExpenseScreenState createState() => EditExpenseScreenState();
}

class EditExpenseScreenState extends State<EditExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late String _selectedCategory;
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.expense.title;
    _amountController.text = widget.expense.amount.toString();
    _selectedCategory = widget.expense.category;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCategories = prefs.getStringList('categories') ??
        [
          'Food',
          'Entertainment',
          'Bills',
          'Travel',
          'Transport',
        ];
    setState(() {
      _categories = savedCategories;
    });
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  void _addNewCategory(String newCategory) {
    if (newCategory.isEmpty) return;

    setState(() {
      _categories.add(newCategory);
      _selectedCategory = newCategory;
    });

    _saveCategories(); 
  }

  void _submitEditExpense() {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    if (title.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedExpense = Expense(
      title: title,
      amount: amount,
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
                    if (newValue == 'Add new category') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final newCategoryController = TextEditingController();
                          return AlertDialog(
                            title: Text('Add new category'),
                            content: TextField(
                              controller: newCategoryController,
                              decoration:
                                  InputDecoration(labelText: 'Category Name'),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Add'),
                                onPressed: () {
                                  final newCategory =
                                      newCategoryController.text.trim();
                                  if (newCategory.isNotEmpty) {
                                    _addNewCategory(newCategory);
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    }
                  },
                  items:
                      _categories.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList() +
                          [
                            DropdownMenuItem<String>(
                              value: 'Add new category',
                              child: Text('Add a category'),
                            ),
                          ],
                ),
              ),
            ),
            SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F4858),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(400, 50),
              ),
              onPressed: _submitEditExpense,
              child:
                  Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
