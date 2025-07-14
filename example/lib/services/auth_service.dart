import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  late FirebaseAuth _auth;

  Map<String, dynamic>? _claims;

  AuthService({FirebaseAuth? firebaseAuth}) {
    _auth = firebaseAuth ?? FirebaseAuth.instance;
  }

  FirebaseAuth get firebaseAuth => _auth;
  String get email => _auth.currentUser?.email ?? '';
  String get userId => _auth.currentUser?.uid ?? '';
  String get displayName => _auth.currentUser?.displayName ?? '';
  Map<String, dynamic>? get claims => _claims;

  bool hasRole(String role) =>
      _claims != null && _claims!.keys.contains(role) && _claims?[role] == true;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } on Exception catch (error) {
      debugPrint('Error signing out: $error');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      notifyListeners();
    } on Exception catch (error) {
      debugPrint('Error deleting account: $error');
    }
  }

  Future<void> fetchclaims() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final idTokenResult = await user.getIdTokenResult();
        final claims = idTokenResult.claims;
        if (claims != null) {
          _claims = claims;
        }
      }
    } on Exception catch (error) {
      debugPrint('Error fetching claims: $error');
    }
  }
}
