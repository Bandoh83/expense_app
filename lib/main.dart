import 'package:expense_app/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
       textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          useMaterial3: true,
      ),
      home: Register(),
    );
  }
}

