import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../data/categories.dart';
import '../widgets/category_filter.dart';
import '../widgets/expense_tile.dart';
import '../widgets/empty_expenses.dart';
import 'expense_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> _expenses = [];

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  Category _selectedCategory = categories.first;

  Category? _filterCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<Expense> get _filteredExpenses {
    if (_filterCategory == null) {
      return _expenses;
    }

    return _expenses.where((expense) {
      return expense.category == _filterCategory;
    }).toList();
  }

  int get _totalAmount {
    return _filteredExpenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  void _addExpense() {
    final title = _titleController.text.trim();

    final amount = int.tryParse(_amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Լրացրեք անվանումը և ճիշտ գումարը'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final expense = Expense(
      id: DateTime.now().microsecondsSinceEpoch,
      title: title,
      amount: amount,
      category: _selectedCategory,
    );

    setState(() {
      _expenses.insert(0, expense);
    });

    _titleController.clear();
    _amountController.clear();

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ծախսը հաջողությամբ ավելացվեց')),
    );
  }

  void _deleteExpense(Expense expense) {
    final index = _expenses.indexWhere((e) => e.id == expense.id);

    if (index == -1) return;

    setState(() {
      _expenses.removeAt(index);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${expense.title} ջնջվեց'),
        action: SnackBarAction(
          label: 'Վերադարձնել',
          onPressed: () {
            final alreadyExists = _expenses.any((e) => e.id == expense.id);

            if (alreadyExists) return;

            setState(() {
              _expenses.insert(index.clamp(0, _expenses.length), expense);
            });
          },
        ),
      ),
    );
  }

  Future<void> _editExpense(Expense expense) async {
    final updatedExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ExpenseDetailScreen(expense: expense);
        },
      ),
    );

    if (!mounted || updatedExpense == null) return;

    setState(() {
      final index = _expenses.indexWhere((e) => e.id == expense.id);

      if (index != -1) {
        _expenses[index] = updatedExpense;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenses = _filteredExpenses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ընդամենը՝ $_totalAmount դր.',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Անվանում',
                  hintText: 'Օրինակ՝ Սուրճ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Գումար',
                  hintText: 'Օրինակ՝ 1500',
                  suffixText: 'դր.',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                children: categories.map((category) {
                  return ChoiceChip(
                    label: Text('${category.emoji} ${category.title}'),
                    selected: _selectedCategory == category,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addExpense,
                  icon: const Icon(Icons.add),
                  label: const Text('Ավելացնել'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategoryFilter(
                selectedCategory: _filterCategory,
                onSelected: (category) {
                  setState(() {
                    _filterCategory = category;
                  });
                },
              ),
            ),

            const SizedBox(height: 8),

            SizedBox(
              height: 300,
              child: expenses.isEmpty
                  ? const EmptyExpenses()
                  : ListView.separated(
                      itemCount: expenses.length,
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1);
                      },
                      itemBuilder: (context, index) {
                        final expense = expenses[index];

                        return Dismissible(
                          key: ValueKey(expense.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) {
                            _deleteExpense(expense);
                          },
                          child: ExpenseTile(
                            expense: expense,
                            onTap: () {
                              _editExpense(expense);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
