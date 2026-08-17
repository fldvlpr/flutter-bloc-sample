import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_event.dart';
import 'package:go_router/go_router.dart';

class CreateTodoScreen extends StatelessWidget {
  CreateTodoScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Todo Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = _controller.text.trim();
                if (title.isNotEmpty) {
                  context.read<TodoBloc>().add(TodoAdded(title));
                  context.pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
