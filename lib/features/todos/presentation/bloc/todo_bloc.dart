import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_event.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;

  TodoBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(TodoInitial()) {
    on<TodosFetched>(_onTodosFetched);
    on<TodoAdded>(_onTodoAdded);
  }

  Future<void> _onTodosFetched(
    TodosFetched event,
    Emitter<TodoState> emit,
  ) async {
    emit(TodoLoadInProgress());
    try {
      final todos = await _todoRepository.getTodos();
      emit(TodoLoadSuccess(todos));
    } catch (e) {
      emit(TodoLoadFailure(e.toString()));
    }
  }

  Future<void> _onTodoAdded(
    TodoAdded event,
    Emitter<TodoState> emit,
  ) async {
    if (state is TodoLoadSuccess) {
      final currentTodos = (state as TodoLoadSuccess).todos;
      emit(TodoLoadInProgress());
      try {
        final newTodo = await _todoRepository.createTodo(event.title);
        emit(TodoLoadSuccess([...currentTodos, newTodo]));
      } catch (e) {
        emit(TodoLoadFailure(e.toString()));
      }
    } else {
      emit(TodoLoadInProgress());
      try {
        final newTodo = await _todoRepository.createTodo(event.title);
        emit(TodoLoadSuccess([newTodo]));
      } catch (e) {
        emit(TodoLoadFailure(e.toString()));
      }
    }
  }
}
