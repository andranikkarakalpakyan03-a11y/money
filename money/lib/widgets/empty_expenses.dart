import 'package:flutter/material.dart';

class EmptyExpenses extends StatelessWidget {
  const EmptyExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long, size: 70, color: Colors.grey),
            SizedBox(height: 15),
            Text(
              'Դեռ ծախսեր չկան',
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Text(
              'Ավելացրեք ձեր առաջին ծախսը',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
