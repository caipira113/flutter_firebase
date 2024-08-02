import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:flutter_firebase/providers/theme.dart';
import 'package:flutter_firebase/screens/room_list.dart';
import 'package:flutter_firebase/screens/signin.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Flutter Messenger',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            home: Consumer<CustomAuthProvider>(
              builder: (context, authProvider, _) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Flutter Messenger'),
                    actions: [
                      IconButton(
                        icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.brightness_7 : Icons.brightness_2),
                        onPressed: () {
                          themeProvider.toggleTheme(themeProvider.themeMode != ThemeMode.dark);
                        },
                      ),
                      if (FirebaseAuth.instance.currentUser != null) // Check if the user is logged in
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          },
                        ),
                    ],
                  ),
                  body: authProvider.user == null ? Signin() : RoomList(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
