import 'package:bilt_login/src/components/email_fields.dart';
import 'package:bilt_login/src/constants/mappings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bilt_login/src/constants/enums.dart' as enums;

class BiltLoginScreen extends StatefulWidget {
  final Function(User?, enums.AuthProvider) onSignInComplete;
  final Widget? backgroundImage;
  final Color? backgroundColor;
  final Color? dividerColor;
  final Widget? logo;

  final FirebaseAuth auth;
  final List<enums.AuthProvider> providers;

  const BiltLoginScreen({
    super.key,
    required this.auth,
    required this.onSignInComplete,
    this.backgroundImage,
    this.dividerColor = Colors.white,
    required this.providers,
    this.backgroundColor,
    this.logo,
  });

  @override
  State<BiltLoginScreen> createState() => _BiltLoginScreenState();
}

class _BiltLoginScreenState extends State<BiltLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loading = false;

  void setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? CircularProgressIndicator()
          : Stack(
              children: [
                widget.backgroundImage ??
                    Container(color: widget.backgroundColor),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.logo ?? Container(),
                      if (widget.providers.contains(enums.AuthProvider.Email))
                        Column(
                          children: [
                            EmailFields(
                              email: emailController,
                              password: passwordController,
                              auth: widget.auth,
                              onSignInComplete: widget.onSignInComplete,
                            ),
                          ],
                        ),
                      if (widget.providers.contains(enums.AuthProvider.Email))
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 15.0),
                                child: Divider(
                                  color: widget.dividerColor,
                                  height: 50,
                                  thickness: 1.5,
                                ),
                              ),
                            ),
                            Text(
                              "or",
                              style: TextStyle(
                                  color: widget.dividerColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 15.0, right: 10.0),
                                child: Divider(
                                  color: widget.dividerColor,
                                  height: 50,
                                  thickness: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ...widget.providers.map((provider) {
                        return mapProviderToButton(
                            provider, widget.auth, widget.onSignInComplete);
                      })
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 25,
                  child: IconButton.filled(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close),
                  ),
                )
              ],
            ),
    );
  }
}
