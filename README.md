<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A login page using Firebase Authentication for email, google, apple and facebook signins.

## Features

Authenticate against Firebase using multiple providers.

## Getting started

1. Ensure you've setup firebase on the app and have a firebase.json file in the root.
2. Ensure you have a firebase obtions file configured in lib/firebaseOptions.dart
3. Set up the GIDClient ID for your app in ios:
```
<key>GIDClientID</key>
	<string>XXXXXXXXXXXXXXX.apps.googleusercontent.com</string>
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>com.googleusercontent.apps.XXXXXXXXXXXXXXX</string>
			</array>
		</dict>
	</array>
```
4. For android (To be confirmed)...

## Usage

```dart
BiltLoginScreen(
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
)
```

## Additional information

Check out the example/ folder for a full implementation of the package.
