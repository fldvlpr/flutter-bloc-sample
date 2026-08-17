import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_detail_cubit.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/todo_detail_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoDetailCubit extends Mock implements TodoDetailCubit {}

void main() {
  late MockTodoDetailCubit mockTodoDetailCubit;

  setUp(() {
    mockTodoDetailCubit = MockTodoDetailCubit();

    // We must stub the stream to return an empty stream because flutter_bloc expects it
    when(
      () => mockTodoDetailCubit.stream,
    ).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<TodoDetailCubit>.value(
        value: mockTodoDetailCubit,
        child: const TodoDetailScreen(todoId: 1),
      ),
    );
  }

  group('Todo Detail Bloc', () {
    testWidgets('Show page details when state is loaded', (tester) async {
      // 1. Arrange
      when(() => mockTodoDetailCubit.state).thenReturn(
        TodoDetailLoadSuccess(
          Todo(id: 1, userId: 1, title: 'title', completed: false),
        ),
      );

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert
      expect(find.text('Title: title'), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    testWidgets('Show error when state is failure', (tester) async {
      // 1. Arrange
      when(
        () => mockTodoDetailCubit.state,
      ).thenReturn(TodoDetailLoadFailure('error'));

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert
      expect(find.text('Error: error'), findsOneWidget);
    });
  });
}
