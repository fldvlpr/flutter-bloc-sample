import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todos')),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoadInProgress || state is TodoInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TodoLoadFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TodoLoadSuccess) {
            final todos = state.todos;
            if (todos.isEmpty) {
              return const Center(child: Text('No todos yet.'));
            }
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  trailing: Checkbox(
                    value: todo.completed,
                    onChanged: (val) {}, 
                  ),
                  onTap: () {
                    context.push('/todo/${todo.id}');
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
