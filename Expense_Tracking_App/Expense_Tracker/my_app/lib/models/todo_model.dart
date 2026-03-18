import 'dart:convert';

class Todo {
  String? id;
  String title;
  String? description;
  String? category;
  double? amount;
  bool paid;

  Todo({
    this.id,
    required this.title,
    this.description,
    this.category,
    this.amount,
    this.paid = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: (json['amount'] != null) ? json['amount'].toDouble() : null,
      paid: json['paid'] ?? false,
    );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'amount': amount,
      'paid': paid,
    };
  }
}

