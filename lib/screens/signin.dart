import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:flutter_firebase/screens/signup.dart';
import 'package:provider/provider.dart';

class Signin extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await authProvider.signInWithEmailAndPassword(
                      emailController.text, passwordController.text);
                },
                child: const Text('Sign In')),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Signup()));
                },
                child: const Text("Signup"))
          ],
        ),
      ),
    );
  }
}
