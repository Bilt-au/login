# example

An example app showcasing use of the bilt login widget using FIrebase Auth methods.

## Getting Started

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
4. For android....