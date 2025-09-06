import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/main.dart';
import 'package:myapp/utils/error_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthApi {
  static const webApiClient =
      "526652825327-p9d9lk3bub424n7orj38lr8ngp6a280g.apps.googleusercontent.com";

  Future<void> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webApiClient,
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
}
