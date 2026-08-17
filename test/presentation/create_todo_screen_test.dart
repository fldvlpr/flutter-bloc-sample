import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/domain/todo.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_bloc.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_event.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_state.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/create_todo_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoBloc extends Mock implements TodoBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(TodosFetched());
  });

  late MockTodoBloc mockTodoBloc;

  setUp(() {
    mockTodoBloc = MockTodoBloc();

    // Stub the stream required by flutter_bloc
    when(() => mockTodoBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  // Helper function to build our widget for testing
  Widget createWidgetUnderTest(GoRouter router) {
    return MaterialApp.router(routerConfig: router);
  }

  GoRouter _createRouter() {
    return GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home')),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) {
            return BlocProvider<TodoBloc>.value(
              value: mockTodoBloc,
              child: const CreateTodoScreen(),
            );
          },
        ),
      ],
    );
  }

  group('CreateTodoScreen', () {
    testWidgets('shows validation errors when submitting empty form', (
      tester,
    ) async {
      // ACT
      final router = _createRouter();
      await tester.pumpWidget(createWidgetUnderTest(router));
      router.push('/create');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create')); // Tap submit without typing
      await tester.pump(); // Force UI to redraw validation errors

      // ASSERT
      expect(find.text('Title is required'), findsOneWidget);
    });

    testWidgets('adds TodoAdded event when valid title is submitted', (
      tester,
    ) async {
      // Arrange
      final router = _createRouter();
      await tester.pumpWidget(createWidgetUnderTest(router));
      router.push('/create');
      await tester.pumpAndSettle();

      final titleField = find.byType(TextFormField);
      await tester.enterText(titleField, 'Buy groceries');

      // Act
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Assert
      final captured = verify(() => mockTodoBloc.add(captureAny())).captured;
      expect(captured, hasLength(1));

      final event = captured.single as TodoAdded;
      expect(event.title, 'Buy groceries');
    });
  });
}
