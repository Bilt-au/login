import 'package:bilt_login/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;

class ProviderButton extends StatelessWidget {
  const ProviderButton({
    super.key,
    required this.provider,
    required this.auth,
    required this.onSignInComplete,
  });

  final Function(User?, enums.AuthProvider) onSignInComplete;
  final FirebaseAuth auth;
  final enums.AuthProvider provider;

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.apple,
      onPressed: () async {
        await AuthService(firebaseAuth: auth)
            .signInWithProvider(provider)
            .then((user) => {
                  onSignInComplete(user, provider),
                });
      },
    );
  }
}
