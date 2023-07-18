import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/utiils/global.color.dart';
import 'package:quiz_app/view/Auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:quiz_app/view/quiz_main_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 1),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirebaseAuth.instance.currentUser == null
              ? const LoginScreen()
              : const QuizMainScreen(),
        ),
      );
    });
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: Center(
        child: Text(
          'Quiz App',
          style: GoogleFonts.amaranth(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
