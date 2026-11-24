import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final Expense expense;

  const ExpenseDetailScreen({super.key, required this.expense});

  @override
  State<ExpenseDetailScreen> createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> {
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController(
      text: widget.expense.amount.toString(),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final amount = int.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Մուտքագրեք ճիշտ գումար')));
      return;
    }

    final updatedExpense = Expense(
      id: widget.expense.id,
      title: widget.expense.title,
      amount: amount,
      category: widget.expense.category,
    );

    Navigator.pop(context, updatedExpense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Փոփոխել ծախսը')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Text(
              widget.expense.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Նոր գումար',
                suffixText: 'դր.',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExpense,
                child: const Text('Պահպանել'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
