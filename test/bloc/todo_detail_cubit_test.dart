import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_detail_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockTodoRepository;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
  });

  group('TodoDetail Bloc', () {
    blocTest<TodoDetailCubit, TodoDetailState>(
      'emits [loading, success] when fetch todo detail called and repository succeeds',
      build: () {
        when(() => mockTodoRepository.getTodoById(1)).thenAnswer(
          (_) async => Todo(id: 1, userId: 1, title: 'title', completed: false),
        );

        return TodoDetailCubit(todoRepository: mockTodoRepository);
      },
      act: (bloc) => bloc.fetchTodoDetail(1),
      expect: () => [
        TodoDetailLoadInProgress(),
        TodoDetailLoadSuccess(
          Todo(id: 1, userId: 1, title: 'title', completed: false),
        ),
      ],
      verify: (_) {
        verify(() => mockTodoRepository.getTodoById(1)).called(1);
      },
    );

    blocTest<TodoDetailCubit, TodoDetailState>(
      'emits [loading, failure] when fetch todo detail called and repository fails',
      build: () {
        when(
          () => mockTodoRepository.getTodoById(1),
        ).thenThrow(Exception('error'));

        return TodoDetailCubit(todoRepository: mockTodoRepository);
      },
      act: (bloc) => bloc.fetchTodoDetail(1),
      expect: () => [
        TodoDetailLoadInProgress(),
        TodoDetailLoadFailure('Exception: error'),
      ],
      verify: (_) {
        verify(() => mockTodoRepository.getTodoById(1)).called(1);
      },
    );
  });
}
