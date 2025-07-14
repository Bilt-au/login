import 'package:bilt_login/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;

class FacebookButton extends StatelessWidget {
  const FacebookButton({
    super.key,
    required this.auth,
    required this.onSignInComplete,
  });

  final Function(User?, enums.AuthProvider) onSignInComplete;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      Buttons.facebook,
      onPressed: () async {
        await AuthService(firebaseAuth: auth)
            .signInWithProvider(enums.AuthProvider.Facebook)
            .then((user) => {
                  onSignInComplete(user, enums.AuthProvider.Facebook),
                });
      },
    );
  }
}
