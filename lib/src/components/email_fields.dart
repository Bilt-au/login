import 'package:bilt_login/src/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;

class EmailFields extends StatefulWidget {
  const EmailFields({
    super.key,
    required this.email,
    required this.password,
    required this.auth,
    required this.onSignInComplete,
  });

  final TextEditingController email;
  final TextEditingController password;
  final FirebaseAuth auth;
  final Function(User?, enums.AuthProvider) onSignInComplete;

  @override
  State<EmailFields> createState() => _EmailFieldsState();
}

class _EmailFieldsState extends State<EmailFields> {
  bool _displayEmailError = false;
  bool _displayPasswordError = false;

  final bool _loginEnabled = true;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _displayEmailError
            ? Container(
                alignment: Alignment.topLeft,
                child: const Text('Enter a valid email',
                    style: TextStyle(color: Colors.red)),
              )
            : Container(),
        TextField(
          controller: widget.email,
          enabled: _loginEnabled,
          onChanged: (value) => {
            setState(
              () {
                _displayPasswordError = false;
                _displayEmailError = false;
              },
            )
          },
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              filled: true,
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        _displayPasswordError
            ? Container(
                alignment: Alignment.topLeft,
                child: const Text('Enter a valid password',
                    style: TextStyle(color: Colors.red)),
              )
            : Container(),
        TextField(
          controller: widget.password,
          obscureText: _obscureText,
          enabled: _loginEnabled,
          onChanged: (value) => {
            setState(() {
              _displayPasswordError = false;
              _displayEmailError = false;
            })
          },
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: const Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  }),
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              filled: true,
              hintText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          onPressed: () async {
            await AuthService(firebaseAuth: widget.auth)
                .signInWithEmail(
                    email: widget.email.text, password: widget.password.text)
                .then((user) => {
                      widget.onSignInComplete(user, enums.AuthProvider.Email),
                    });
          },
          child: const Text('Sign in'),
        ),
      ],
    );
  }
}
