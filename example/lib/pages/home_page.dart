import 'package:bilt_login/bilt_login_screen.dart';
import 'package:bilt_login/constants.dart' as constants;
import 'package:example/services/auth_service.dart';
import 'package:example/widgets/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void handleSignIn(
    BuildContext context,
    User? user,
    constants.AuthProvider provider,
  ) {
    if (user != null) {
      debugPrint('Sign-in successful with $provider: ${user.email}');
      Navigator.pop(context);
    } else {
      debugPrint('Sign-in failed for $provider');
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bilt LoginExample')),
      body: StreamBuilder<User?>(
        stream: authService.firebaseAuth.idTokenChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return UserInfoDisplay(user: snapshot.data!);
          } else {
            return Center(
              child: ElevatedButton(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => BiltLoginScreen(
                              auth: authService.firebaseAuth,
                              providers: [
                                constants.AuthProvider.Email,
                                constants.AuthProvider.Google,
                                constants.AuthProvider.Apple,
                              ],
                              onSignInComplete:
                                  (user, provider) =>
                                      handleSignIn(context, user, provider),
                              logo: Image.asset(
                                'assets/logo.png',
                                width: 300,
                                height: 300,
                              ),
                              backgroundImage: Image.asset(
                                'assets/login_bg.jpg',
                                fit: BoxFit.fill,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                      ),
                    ),
                child: const Text('Login page'),
              ),
            );
          }
        },
      ),
    );
  }
}
