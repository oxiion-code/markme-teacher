// widgets/todo_tile.dart
import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
          color: todo.completed ? Colors.green : Colors.grey,
        ),
        title: Text(
          todo.todo,
          style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: todo.completed
            ? const Chip(label: Text("Done"), backgroundColor: Colors.greenAccent)
            : const Chip(label: Text("Pending"), backgroundColor: Colors.orangeAccent),
      ),
    );
  }
}
