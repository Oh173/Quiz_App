import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/view/admin/quiz_admin_questions_screen.dart';
import '../Auth/login_screen.dart';


class QuizAdminScreen extends StatefulWidget {
  const QuizAdminScreen({super.key});

  @override
  State<QuizAdminScreen> createState() => _QuizAdminScreenState();
}

class _QuizAdminScreenState extends State<QuizAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Admin'),
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
        body: QuizAdminQuestionsScreen(),
    );
  }
}
