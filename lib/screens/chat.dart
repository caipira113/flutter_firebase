import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/providers/auth.dart';
import 'package:flutter_firebase/services/firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/theme.dart';

class Chat extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
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
                    final data = message.data() as Map<String, dynamic>;
                    final email = data['email'] ?? 'Unknown';
                    final text = data['text'] ?? '';
                    final timestamp = data['timestamp'] as Timestamp?;
                    final formattedTime = timestamp != null
                        ? DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())
                        : 'Time unknown';
                    final uid = data.containsKey('uid') ? data['uid'] : null;
                    final isCurrentUser = uid != null && uid == authProvider.user?.uid;

                    return Align(
                      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: isCurrentUser
                              ? (isDarkMode ? Colors.blueGrey[800] : Colors.blue[100])
                              : (isDarkMode ? Colors.grey[800] : Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              email,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white70 : Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              text,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white54 : Colors.grey[500],
                                fontSize: 10.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Message content",
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final user = authProvider.user;
                      if (user != null) {
                        final email = user.email ?? 'Anonymous';
                        _firestoreService.sendMessage(
                            _controller.text, authProvider.user!.uid, email);
                        _controller.clear();
                      }
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
