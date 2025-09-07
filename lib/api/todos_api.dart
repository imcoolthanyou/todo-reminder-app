import 'package:myapp/main.dart';

class TodosApi {
  // stream of todos for current user
  Stream<List<Map<String, dynamic>>> getTodosStream() {
    final userId = supabase.auth.currentUser!.id;
    return supabase
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  // add new todo
  Future<void> addTodo({
    required String title,
    required DateTime deadline,
  }) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase.from('todos').insert({
      'title': title,
      'deadline': deadline.toIso8601String(),
      'user_id': userId,
    });
  }

  // get todos as future (not stream)
  Future<List<Map<String, dynamic>>> getTodosFuture() async {
    final userId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('todos')
        .select() // using select instead of stream
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data;
  }

  // update existing todo
  Future<void> updateTodo({
    required int id,
    String? title,
    DateTime? deadline,
    bool? isCompleted,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (deadline != null) updates['deadline'] = deadline.toIso8601String();
    if (isCompleted != null) updates['is_completed'] = isCompleted;

    await supabase.from('todos').update(updates).eq('id', id);
  }

  // delete todo
  Future<void> deleteTodo(int id) async {
    await supabase.from('todos').delete().eq('id', id);
  }
}
