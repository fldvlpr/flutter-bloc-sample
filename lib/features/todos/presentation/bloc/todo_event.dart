import 'package:equatable/equatable.dart';

sealed class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

final class TodosFetched extends TodoEvent {}

final class TodoAdded extends TodoEvent {
  final String title;

  const TodoAdded(this.title);

  @override
  List<Object> get props => [title];
}
