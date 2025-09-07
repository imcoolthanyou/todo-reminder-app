import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/main.dart';
import 'package:myapp/utils/error_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthApi {
  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID']!,
      );
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No Id token from Google';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      showErrorSnackBar(context, 'Sign-in failed: $error');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> saveFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await supabase.from('profiles').upsert({
        'id': supabase.auth.currentUser!.id,
        'fcm_token': fcmToken,
      });
    }
  }
}
