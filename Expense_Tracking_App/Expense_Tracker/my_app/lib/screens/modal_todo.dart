import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/todo_model.dart';
import '../../../../providers/todo_provider.dart';

class TodoModal extends StatefulWidget {
  final String type;
  final Todo? item;

  const TodoModal({super.key, required this.type, this.item});

  @override
  State<TodoModal> createState() => _TodoModalState();
}

class _TodoModalState extends State<TodoModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _checkedCategory;
  bool _paid = false;

  final List<String> _categories = [
    'Bills',
    'Transportation',
    'Food',
    'Utilities',
    'Health',
    'Entertainment',
    'Miscellaneous',
  ];

  //to initialize 
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description ?? '';
      _amountController.text = widget.item!.amount?.toString() ?? '';
      _checkedCategory = widget.item!.category;
    }
  }

  //to dispose
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Text _buildTitle() {
    switch (widget.type) {
      case 'Add':
        return const Text("Add New Expense");
      case 'Edit':
        return const Text("Edit Expense");
      case 'Delete':
        return const Text("Delete Expense");
      default:
        return const Text("");
    }
  }

  //to build content of the dialog
  Widget _buildContent(BuildContext context) {
    switch (widget.type) {
      case 'Delete':
        return Text("Are you sure you want to delete '${widget.item!.title}'?");
      default:
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter a name'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Please enter description'
                      : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _checkedCategory,
                  hint: const Text('Select Category'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _checkedCategory = newValue!;
                    });
                  },
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Select a category'
                      : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please input amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        );
    }
  }

  TextButton _dialogAction(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.type != 'Delete' && !_formKey.currentState!.validate())
          return;

        switch (widget.type) {
          case 'Add':
            Todo temp = Todo(
              title: _nameController.text,
              description: _descriptionController.text,
              category: _checkedCategory,
              amount: double.tryParse(_amountController.text) ?? 0.0,
              paid: _paid,
            );
            context.read<TodoListProvider>().addTodo(temp);
            Navigator.of(context).pop();
            break;
          case 'Edit':
            final newTodo = Todo(
              id: widget.item!.id,
              title: _nameController.text,
              description: _descriptionController.text,
              category: _checkedCategory,
              amount: double.tryParse(_amountController.text) ?? 0.0,
              paid: widget.item!.paid,
            );
            context.read<TodoListProvider>().editTodo(newTodo);
            Navigator.of(context).pop();
            break;
          case 'Delete':
            context.read<TodoListProvider>().deleteTodo(widget.item!.id!); 
            Navigator.of(context).pop();
            break;
        }
      },
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      child: Text(widget.type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(context),
      actions: <Widget>[
        _dialogAction(context),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
