import 'package:flutter_bloc_sample/features/todos/data/todo_data_provider.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoDataProvider extends Mock implements TodoDataProvider {}

void main() {
  late MockTodoDataProvider mockTodoDataProvider;
  late TodoRepository todoRepository;

  setUp(() {
    mockTodoDataProvider = MockTodoDataProvider();
    todoRepository = TodoRepository(todoDataProvider: mockTodoDataProvider);
  });

  group('Test Get Todos', () {
    test('should return list of todos', () async {
      // 1. Arrange
      final jsonMap = [
        {'id': 1, 'userId': 1, 'title': 'title', 'completed': false},
      ];

      when(
        () => mockTodoDataProvider.getTodos(),
      ).thenAnswer((_) async => jsonMap);

      // 2. Act
      final result = await todoRepository.getTodos();

      // 3. Assert
      expect(result, isA<List<Todo>>());
      expect(result.length, 1);
      expect(result[0].id, 1);
      expect(result[0].userId, 1);
      expect(result[0].title, 'title');
      expect(result[0].completed, false);
    });

    test('should throw exception', () async {
      // 1. Arrange
      when(() => mockTodoDataProvider.getTodos()).thenThrow(Exception('error'));

      // 2. Act & Assert
      expect(
        () => todoRepository.getTodos(),
        throwsA(
          predicate((exception) => exception.toString() == 'Exception: error'),
        ),
      );
    });
  });

  group('Test getTodoById', () {
    test('should return Todo By Id', () async {
      // 1. Arrange
      final jsonMap = {
        'id': 1,
        'userId': 1,
        'title': 'title',
        'completed': false,
      };
      when(
        () => mockTodoDataProvider.getTodoById(1),
      ).thenAnswer((_) async => jsonMap);

      // 2. Act
      final result = await todoRepository.getTodoById(1);

      // 3. Assert
      expect(result, isA<Todo>());
      expect(result.id, 1);
      expect(result.userId, 1);
      expect(result.title, 'title');
      expect(result.completed, false);
    });

    test('should throw exception', () async {
      // 1. Arrange
      when(
        () => mockTodoDataProvider.getTodoById(1),
      ).thenThrow(Exception('error'));

      // 2. Act & Assert
      expect(() => todoRepository.getTodoById(1), throwsA(isA<Exception>()));
    });
  });

  group('Test create Todo', () {
    test('should create and return Todo', () async {
      // 1. Arrange
      final jsonMap = {
        'id': 1,
        'userId': 1,
        'title': 'title',
        'completed': false,
      };
      when(
        () => mockTodoDataProvider.createTodo(any()),
      ).thenAnswer((_) async => jsonMap);

      // 2. Act
      final result = await todoRepository.createTodo('title');

      // 3. Assert
      expect(result, isA<Todo>());
      expect(result.id, 1);
      expect(result.userId, 1);
      expect(result.title, 'title');
      expect(result.completed, false);
    });

    test('should throw exception', () async {
      // 1. Arrange
      when(
        () => mockTodoDataProvider.createTodo(any()),
      ).thenThrow(Exception('error'));
    });
  });
}
