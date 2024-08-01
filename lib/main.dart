import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:flutter_firebase/screens/chat.dart';
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
      ],
      child: MaterialApp(
        title: 'Flutter Messenger',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<CustomAuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.user == null ? Signin() : Chat();
          },
        ),
      ),
    );
  }
}
