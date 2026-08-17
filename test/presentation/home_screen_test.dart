import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/home_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {
  late MockTodoBloc mockTodoBloc;

  setUp(() {
    mockTodoBloc = MockTodoBloc();

    // We must stub the stream to return an empty stream because flutter_bloc expects it
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<TodoBloc>.value(
        value: mockTodoBloc,
        child: const HomeScreen(),
      ),
    );
  }

  group('Home Screen', () {
    testWidgets('show circular progress indicator when state is loading', (
      tester,
    ) async {
      // 1. Arrange
      when(() => mockTodoBloc.state).thenReturn(TodoLoadInProgress());

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows todos when state is loaded', (tester) async {
      // 1. Arrange
      when(() => mockTodoBloc.state).thenReturn(
        TodoLoadSuccess([
          Todo(id: 1, userId: 1, title: 'title', completed: false),
        ]),
      );

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert
      expect(find.text('title'), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);
    });

    testWidgets('shows error when page state is failure', (tester) async {
      // 1. Arrange
      when(() => mockTodoBloc.state).thenReturn(TodoLoadFailure('error'));

      // 2. Act
      await tester.pumpWidget(createWidgetUnderTest());

      // 3. Assert
      expect(find.text('Error: error'), findsOneWidget);
    });
  });
}
