import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_event.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockupTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockupTodoRepository mockupTodoRepository;

  setUp(() {
    mockupTodoRepository = MockupTodoRepository();
  });

  group('Todo Bloc - Fetch Todos', () {
    final todos = [Todo(id: 1, userId: 1, title: 'title', completed: false)];

    blocTest<TodoBloc, TodoState>(
      'emits loading and loaded state when fetch todos called and repository succeeds',
      build: () {
        when(
          () => mockupTodoRepository.getTodos(),
        ).thenAnswer((_) async => todos);

        return TodoBloc(todoRepository: mockupTodoRepository);
      },
      act: (bloc) => bloc.add(TodosFetched()),
      expect: () => [TodoLoadInProgress(), TodoLoadSuccess(todos)],
      verify: (_) {
        verify(() => mockupTodoRepository.getTodos()).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'emits loading and failure state when fetch todos called and repository fails',
      build: () {
        when(
          () => mockupTodoRepository.getTodos(),
        ).thenThrow(Exception('error'));

        return TodoBloc(todoRepository: mockupTodoRepository);
      },
      act: (bloc) => bloc.add(TodosFetched()),
      expect: () => [TodoLoadInProgress(), TodoLoadFailure('Exception: error')],
      verify: (_) {
        verify(() => mockupTodoRepository.getTodos()).called(1);
      },
    );
  });

  group('Todo Bloc - Add Todo', () {
    blocTest<TodoBloc, TodoState>(
      'test add todo success',
      build: () {
        when(() => mockupTodoRepository.createTodo(any())).thenAnswer(
          (_) async => Todo(id: 1, userId: 1, title: 'title', completed: false),
        );

        return TodoBloc(todoRepository: mockupTodoRepository);
      },
      act: (bloc) => bloc.add(TodoAdded('title')),
      expect: () => [
        TodoLoadInProgress(),
        TodoLoadSuccess([
          Todo(id: 1, userId: 1, title: 'title', completed: false),
        ]),
      ],
      verify: (_) {
        verify(() => mockupTodoRepository.createTodo(any())).called(1);
      },
    );

    blocTest<TodoBloc, TodoState>(
      'test add todo failure',
      build: () {
        when(
          () => mockupTodoRepository.createTodo(any()),
        ).thenThrow(Exception('error'));

        return TodoBloc(todoRepository: mockupTodoRepository);
      },
      act: (bloc) => bloc.add(TodoAdded('title')),
      expect: () => [TodoLoadInProgress(), TodoLoadFailure('Exception: error')],
      verify: (_) {
        verify(() => mockupTodoRepository.createTodo(any())).called(1);
      },
    );
  });
}
