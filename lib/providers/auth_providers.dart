import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/main.dart';

// listens to auth state changes
final authStateProvider = StreamProvider<Session?>((ref) {
  return supabase.auth.onAuthStateChange.map((data) => data.session);
});