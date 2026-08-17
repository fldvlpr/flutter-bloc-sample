import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/core/di/injection.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_detail_cubit.dart';

class TodoDetailScreen extends StatelessWidget {
  final int todoId;

  const TodoDetailScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo Detail')),
      body: BlocBuilder<TodoDetailCubit, TodoDetailState>(
        builder: (context, state) {
          if (state is TodoDetailInitial || state is TodoDetailLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoDetailLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TodoDetailLoadSuccess) {
            final todo = state.todo;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ID: ${todo.id}', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text(
                    'Title: ${todo.title}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text('Completed: ${todo.completed}'),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
