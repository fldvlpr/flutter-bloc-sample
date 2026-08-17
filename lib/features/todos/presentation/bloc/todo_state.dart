import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';

sealed class TodoState extends Equatable {
  const TodoState();
  
  @override
  List<Object> get props => [];
}

final class TodoInitial extends TodoState {}

final class TodoLoadInProgress extends TodoState {}

final class TodoLoadSuccess extends TodoState {
  final List<Todo> todos;

  const TodoLoadSuccess(this.todos);

  @override
  List<Object> get props => [todos];
}

final class TodoLoadFailure extends TodoState {
  final String error;

  const TodoLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
