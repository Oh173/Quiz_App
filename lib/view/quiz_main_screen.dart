import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/view/Auth/login_screen.dart';
import 'package:quiz_app/view/profile_page_screen.dart';
import 'package:quiz_app/view/start_quiz_screen.dart';

class QuizMainScreen extends StatefulWidget {
  const QuizMainScreen({super.key});

  @override
  State<QuizMainScreen> createState() => _QuizMainScreenState();
}

class _QuizMainScreenState extends State<QuizMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quiz  App'
        ),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            padding: const EdgeInsets.all(0),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.blue.shade600.withOpacity(.8),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatQuizScreen(),
                ),
              ),
              child: const Text(" Start QUIZ "),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePageScreen(),
                ),
              ),
              child: const Text(" Profile "),
            ),
          ],
        ),
      ),
    );
  }
}
