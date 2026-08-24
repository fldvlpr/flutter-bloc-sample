# Flutter BLoC Testing Guide

This guide explains the mechanics of testing Flutter applications that use BLoC for state management, specifically focusing on the differences between `Mock` (from `mocktail`) and `MockCubit`/`MockBloc` (from `bloc_test`), and how they interact with Flutter's UI widgets.

## The Core Problem: How `BlocBuilder` Works
Whenever you use a `BlocBuilder` (or `BlocConsumer` / `BlocListener`) in your Flutter UI, the framework performs two crucial steps the very first time it renders:
1. **Reads the `.state`**: It asks the Cubit, *"What is your current state right now?"* so it can draw the initial frame on the screen.
2. **Listens to the `.stream`**: It subscribes to the Cubit's stream so it knows when to rebuild the UI in the future.

If either of those properties (`.state` or `.stream`) is completely missing or returns an invalid value, the `BlocBuilder` will crash the test with a `MissingStubError` or a `TypeError`.

---

## Approach 1: Using pure `mocktail` (`Mock`)

```dart
class MockPostFormCubit extends Mock implements PostFormCubit {}
```

When you use `Mock` from the `mocktail` package, you are creating what is called a "dumb shell". It looks exactly like your Cubit to the compiler, but **every single property and method inside of it is totally empty**. 

Because `BlocBuilder` *needs* `.state` and `.stream` to survive, your test will crash immediately if you don't manually stub them.

**To fix this**, you have to manually teach the dumb shell how to respond using `when(...)`:

```dart
void main() {
  late MockPostFormCubit mockPostFormCubit;

  setUp(() {
    mockPostFormCubit = MockPostFormCubit();
    
    // Teaching it how to respond to .state
    when(() => mockPostFormCubit.state).thenReturn(const PostFormState.initial());

    // Teaching it how to respond to .stream
    when(() => mockPostFormCubit.stream).thenAnswer((_) => const Stream.empty());
  });
}
```

Putting these in the `setUp` block provides a convenient "baseline" state. If a specific test case needs a *different* state (e.g., loading or error), you simply write a new `when(() => mockPostFormCubit.state).thenReturn(...)` inside that specific test case to override the default.

---

## Approach 2: Using `bloc_test` (`MockCubit` / `MockBloc`)

```dart
class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}
```

The `MockBloc` and `MockCubit` classes from the `bloc_test` package are essentially "smart shells". They extend the standard `mocktail` tool, but they **automatically write the default `.state` and `.stream` stubs for you** under the hood.

Because `MockBloc` is built specifically for BLoC testing, it automatically creates a dummy stream. However, it *doesn't* know what specific state you want your UI to test. 

So, even when using `MockBloc`, you **must still stub the state** for your UI tests so the `BlocBuilder` knows what to render:

```dart
testWidgets('renders list of posts when loaded', (tester) async {
  // We STILL have to provide the state, even with MockBloc!
  when(() => mockPostBloc.state).thenReturn(const PostState(isLoading: false, posts: [/*...*/]));

  await tester.pumpWidget(buildWidgetUnderTest());

  expect(find.text('Test Title'), findsOneWidget);
});
```

---

## What about Screens without `BlocBuilder`?

If you are testing a screen that **only submits data** (like a form screen that only calls `context.read<TodoBloc>().add(...)`), it rarely uses a `BlocBuilder`. 

If a screen never uses `BlocBuilder` or `BlocConsumer`, the Flutter framework never actually asks the Mock for its `.state` or `.stream` when drawing the UI. Because it never asks, you **do not need to stub the state or the stream**.

### Example: A Simple Form Screen
```dart
testWidgets('adds TodoAdded event when valid title is submitted', (tester) async {
  // Notice we don't stub .state anywhere here!
  await tester.pumpWidget(createWidgetUnderTest(router));
  
  await tester.enterText(find.byType(TextFormField), 'Buy groceries');
  await tester.tap(find.text('Create'));
  await tester.pumpAndSettle();

  // We just verify the event was added
  verify(() => mockTodoBloc.add(captureAny())).called(1);
});
```

---

## Summary Cheat Sheet

- **Use `MockCubit` or `MockBloc`** (from `bloc_test`) whenever testing a UI screen. It handles the annoying boilerplate (like creating dummy streams) for you.
- **You must use `when(() => bloc.state).thenReturn(...)`** before pumping the widget if the screen uses a `BlocBuilder`, so you can control exactly what state the UI is reacting to.
- **If the screen only calls `context.read<Bloc>().add()`**, it doesn't need `.state` to be stubbed because the UI isn't listening for state changes.
- **Use `setUp`** to define a default `.state` baseline for all tests.
- **Use `when` inside a test block** to override the default `.state` from `setUp` for that specific test scenario.

---

## Handling Navigation in Tests (`InheritedGoRouter`)

If the screen you are testing triggers navigation (like `context.pop()` or `context.push()`), the test will crash with a *"No GoRouter found in context"* error because the isolated test widget doesn't have your app's actual router setup.

To fix this, you inject a fake router into the widget tree using `InheritedGoRouter`:

```dart
class MockGoRouter extends Mock implements GoRouter {}

final mockGoRouter = MockGoRouter();

// Wrap your screen in the fake router
Widget buildWidgetUnderTest() {
  return MaterialApp(
    home: InheritedGoRouter(
      goRouter: mockGoRouter,
      child: const MyScreen(),
    ),
  );
}
```

This prevents crashes and allows you to verify that navigation *would* have happened during the test:
```dart
verify(() => mockGoRouter.pop()).called(1);
```
