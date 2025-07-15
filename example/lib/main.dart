import 'package:bilt_login/bilt_login_screen.dart';
import 'package:bilt_login/constants.dart' as constants;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../../../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderWrapper());
}

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
      child: MaterialApp(home: HomePage()),
    );
  }
}

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
      appBar: AppBar(title: const Text('Bilt Login Example')),
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
            Text('Email: ${authService.email}', style: TextStyle(fontSize: 12)),
          SizedBox(height: 20),
          if (authService.userId != '')
            Text(
              'User ID ${authService.userId}',
              style: TextStyle(fontSize: 12),
            ),
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
