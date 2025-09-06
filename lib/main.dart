import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_providers.dart';
import 'package:myapp/screens/auth_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/splash_screen.dart';
import 'package:myapp/services/notification_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final notificationService = NotificationService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notificationService.init();

  //initalizing the supabase

  await Supabase.initialize(
    url: "https://hmeltfimvgcxldxicqet.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhtZWx0ZmltdmdjeGxkeGljcWV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcwNjc3OTYsImV4cCI6MjA3MjY0Mzc5Nn0.DW6sDOcQWCQxxNkOKojhYFNyLJ58h3lrlMqod-EJICI",
  );

  runApp(ProviderScope(child: MyApp()));
}

final supabase = Supabase.instance.client;

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Todo Reminder App',
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      // Use the authState to decide which screen to show
      home: authState.when(
        data: (session) {
          if (session != null) {
            // User is logged in, show HomeScreen
            return const HomeScreen();
          } else {
            // User is not logged in, show AuthScreen
            return const AuthScreen();
          }
        },
        // Show a loading screen while checking auth state
        loading: () => const SplashScreen(),
        // Show an error screen if something goes wrong
        error: (error, stackTrace) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
