import 'package:example/pages/home_page.dart';
import 'package:example/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderWrapper extends StatelessWidget {
  const ProviderWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(firebaseAuth: FirebaseAuth.instance),
        ),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
