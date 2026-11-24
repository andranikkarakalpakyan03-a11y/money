enum Category {
  food('Սնունդ', '🍔'),
  transport('Տրանսպորտ', '🚌'),
  entertainment('Զվարճանք', '🎮'),
  other('Այլ', '📦');

  final String title;
  final String emoji;

  const Category(this.title, this.emoji);
}

class Expense {
  final int id;
  final String title;
  final int amount;
  final Category category;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
  });
}
