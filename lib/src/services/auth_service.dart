import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  late FirebaseAuth _auth;

  AuthService({FirebaseAuth? firebaseAuth}) {
    _auth = firebaseAuth ?? FirebaseAuth.instance;
  }

  Future<bool> signUpWithEmail({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<User?> signInWithProvider(enums.AuthProvider authProvider) async {
    try {
      final provider = switch (authProvider) {
        enums.AuthProvider.Apple => AppleAuthProvider(),
        enums.AuthProvider.Facebook => FacebookAuthProvider(),
        enums.AuthProvider.Google => GoogleAuthProvider(),
        enums.AuthProvider.Email =>
          throw Exception("Can't login with email via provider"),
      };

      User? user;
      if (kIsWeb) {
        user = (await _auth.signInWithPopup(provider)).user;
      } else {
        user = (await _auth.signInWithProvider(provider)).user;
      }
      return user;
    } catch (e) {
      debugPrint("${authProvider.name} sign-in failed: $e");
      return null;
    }
  }

  Future<User?> signInWithEmail({String? email, String? password}) async {
    try {
      var user = (await _auth.signInWithEmailAndPassword(
              email: email!, password: password!))
          .user;
      return user;
    } on FirebaseAuthException catch (e) {
      debugPrint("Email sign-in failed: $e");
      return null;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize();

    final GoogleSignInAccount googleUser = await signIn.authenticate();

    final Map<String, String>? headers =
        await googleUser.authorizationClient.authorizationHeaders([]);

    if (headers != null) {
      final String? accessToken =
          headers['Authorization']?.replaceFirst('Bearer ', '');
      final String? idToken = headers['X-Goog-ID-Token'];

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      var creds = await FirebaseAuth.instance.signInWithCredential(credential);
      return creds;
    }
    return null;
  }
}
