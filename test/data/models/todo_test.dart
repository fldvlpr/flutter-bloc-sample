import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToDo Model', () {
    test('should parse from JSON response correctly', () {
      // 1. Arrange
      final jsonMap = {
        'id': 1,
        'userId': 1,
        'title': 'title',
        'completed': false,
      };

      // 2. Act
      final result = Todo.fromJson(jsonMap);

      // 3. Assert
      expect(result, isA<Todo>());
      expect(result.id, 1);
      expect(result.userId, 1);
      expect(result.title, 'title');
      expect(result.completed, false);
    });
  });
}
