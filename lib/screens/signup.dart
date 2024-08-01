import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:provider/provider.dart';

class Signup extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
      ),
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
                  await authProvider.signUpWithEmailAndPassword(
                      emailController.text, passwordController.text);
                  Navigator.of(context).pop();
                },
                child: const Text("Signup"))
          ],
        ),
      ),
    );
  }
}
