import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/providers/auth_providers.dart';
import 'package:myapp/screens/auth_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load env vars first
  await dotenv.load(fileName: ".env");

  // init firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // setup supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const ProviderScope(child: MyApp()));
}


final supabase = Supabase.instance.client; // global supabase instance

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Todo Reminder App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),

      home: authState.when(
        data: (session) {
          if (session != null) {
            // user logged in, save fcm token
            ref.read(authApiProvider).saveFCMToken();
            return const HomeScreen();
          } else {
            // not logged in
            return const AuthScreen();
          }
        },
        loading: () => const SplashScreen(), // loading state
        // error screen if something breaks
        error: (error, stackTrace) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
