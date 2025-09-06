import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:myapp/main.dart'; 

// This provider exposes a stream of the user's authentication state.
// Our UI will listen to this stream to know when to show the AuthScreen or HomeScreen.
final authStateProvider = StreamProvider<Session?>((ref) {
  return supabase.auth.onAuthStateChange.map((data) => data.session);
});