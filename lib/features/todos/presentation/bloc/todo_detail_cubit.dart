import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';

sealed class TodoDetailState extends Equatable {
  const TodoDetailState();

  @override
  List<Object> get props => [];
}

final class TodoDetailInitial extends TodoDetailState {}

final class TodoDetailLoadInProgress extends TodoDetailState {}

final class TodoDetailLoadSuccess extends TodoDetailState {
  final Todo todo;

  const TodoDetailLoadSuccess(this.todo);

  @override
  List<Object> get props => [todo];
}

final class TodoDetailLoadFailure extends TodoDetailState {
  final String error;

  const TodoDetailLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}

class TodoDetailCubit extends Cubit<TodoDetailState> {
  final TodoRepository _todoRepository;

  TodoDetailCubit({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(TodoDetailInitial());

  Future<void> fetchTodoDetail(int id) async {
    emit(TodoDetailLoadInProgress());
    try {
      final todo = await _todoRepository.getTodoById(id);
      emit(TodoDetailLoadSuccess(todo));
    } catch (e) {
      emit(TodoDetailLoadFailure(e.toString()));
    }
  }
}
