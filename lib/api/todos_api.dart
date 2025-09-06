import 'package:myapp/main.dart';

class TodosApi {
  Stream<List<Map<String, dynamic>>> getTodosStream() {
    final userId = supabase.auth.currentUser!.id;
    return supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

 Future<Map<String, dynamic>> addTodo({
  required String title,
  required DateTime deadline,
}) async {
  final userId = supabase.auth.currentUser!.id;


  final newTodo = await supabase.from('todos').insert({
    'title': title,
    'deadline': deadline.toIso8601String(),
    'user_id': userId,
  }).select().single();

  return newTodo;
}

  Future<List<Map<String, dynamic>>> getTodosFuture() async {
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('todos')
        .select() // Use select() instead of stream()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data;
  }

Future<Map<String, dynamic>> updateTodo({
    required int id,
    String? title, 
    DateTime? deadline,
    bool? isCompleted,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (deadline != null) updates['deadline'] = deadline.toIso8601String();
    if (isCompleted != null) updates['is_completed'] = isCompleted;

    final updatedTodo = await supabase
        .from('todos')
        .update(updates)
        .eq('id', id)
        .select()
        .single();
    return updatedTodo;
  }

  Future<void> deleteTodo(int id) async {
    await supabase.from('todos').delete().eq('id', id);
  }
}
