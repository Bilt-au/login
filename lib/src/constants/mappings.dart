import 'package:bilt_login/src/components/facebook_button.dart';
import 'package:bilt_login/src/components/google_button.dart';
import 'package:bilt_login/src/components/provider_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;

Widget mapProviderToButton(enums.AuthProvider provider, FirebaseAuth auth,
    Function(User?, enums.AuthProvider) onSignInComplete) {
  switch (provider) {
    case enums.AuthProvider.Google:
      return GoogleButton(auth: auth, onSignInComplete: onSignInComplete);
    case enums.AuthProvider.Facebook:
      return FacebookButton(auth: auth, onSignInComplete: onSignInComplete);
    case enums.AuthProvider.Email:
      return Container();
    default:
      return ProviderButton(
          provider: provider, auth: auth, onSignInComplete: onSignInComplete);
  }
}
