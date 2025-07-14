
import 'package:example/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInfoDisplay extends StatelessWidget {
  const UserInfoDisplay({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context);
    authService.fetchclaims();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (authService.displayName != '')
            Text(
              'Display Name: ${authService.displayName}',
              style: TextStyle(fontSize: 12),
            ),
          SizedBox(height: 20),
          if (authService.email != '')
            Text(
              'Email: ${authService.email}',
              style: TextStyle(fontSize: 12),
            ),
          SizedBox(height: 20),
          if (authService.userId != '')
            Text(
              'User ID ${authService.userId}',
              style: TextStyle(fontSize: 12),
            ),
          // if (authService.claims != null)
          //   for (var role in authService.claims!.entries)
          //     Text(
          //       '${role.key} : ${role.value}',
          //       style: const TextStyle(fontSize: 12),
          //     ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => authService.firebaseAuth.signOut(),
            child: const Text('Signout'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
