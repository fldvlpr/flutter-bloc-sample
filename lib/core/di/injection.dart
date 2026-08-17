import 'package:get_it/get_it.dart';
import 'package:flutter_bloc_sample/core/network/api_client.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_data_provider.dart';
import 'package:flutter_bloc_sample/features/todos/data/todo_repository.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Core
  getIt.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data Providers
  getIt.registerLazySingleton<TodoDataProvider>(
    () => TodoDataProvider(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepository(todoDataProvider: getIt<TodoDataProvider>()),
  );
}
