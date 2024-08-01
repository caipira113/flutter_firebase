import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:provider/provider.dart';

class Chat extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Signin"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestoreService.getMessage(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return ListTile(
                            title: Text(message["text"]),
                            subtitle: Text(message['email']),
                          );
                        }
                    );
                  },
                )
            ),
            Padding(
                padding: const EdgeInsets.all(8.0), child: Row(
              children: [
                Expanded(child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Message content",)
                )
                ),
                IconButton(onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    final user = authProvider.user;
                    if (user != null) {
                      final email = user.email ?? 'Anonymous';
                      _firestoreService.sendMessage(
                          _controller.text, authProvider.user!.uid, email);
                      _controller.clear();
                    }
                  }
                }, icon: const Icon(Icons.send))
              ],
            ))
          ],
        )
    );
  }
}
