import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/api/todos_api.dart';

final todosApiProvider = Provider((_ref) => TodosApi());

// gets todos from db
final todosProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(todosApiProvider).getTodosFuture();
});
