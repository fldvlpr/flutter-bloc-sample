import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_sample/core/di/injection.dart';
import 'package:flutter_bloc_sample/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter_bloc_sample/features/profile/presentation/profile_screen.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/bloc/todo_detail_cubit.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/create_todo_screen.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/home_screen.dart';
import 'package:flutter_bloc_sample/features/todos/presentation/screens/todo_detail_screen.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return DashboardScreen(child: child);
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(path: '/create', builder: (context, state) => CreateTodoScreen()),
    GoRoute(
      path: '/todo/:id',
      builder: (context, state) {
        final idString = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) =>
              TodoDetailCubit(todoRepository: getIt<TodoRepository>())
                ..fetchTodoDetail(int.parse(idString)),
          child: TodoDetailScreen(todoId: int.parse(idString)),
        );
      },
    ),
  ],
);
