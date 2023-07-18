import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/utiils/global.color.dart';
import 'package:quiz_app/view/Auth/forget_password_screen.dart';
import 'package:quiz_app/view/admin/quiz_admin_screen.dart';
import 'package:quiz_app/view/quiz_main_screen.dart';
import 'package:quiz_app/view/Auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(top: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Quiz App',
                    style: GoogleFonts.amaranth(
                      textStyle: TextStyle(
                        color: GlobalColors.mainColor,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'Login to your account!',
                  style: GoogleFonts.amaranth(
                    textStyle: TextStyle(
                      color: GlobalColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                // Email Input
                Container(
                  padding: const EdgeInsets.only(top: 2, left: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 7),
                      ]),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      helperStyle: TextStyle(
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Email Input
                Container(
                  padding: const EdgeInsets.only(top: 2, left: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 7),
                      ]),
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      helperStyle: TextStyle(
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        "Forget Password ?",
                        style: GoogleFonts.amaranth(
                          textStyle: TextStyle(
                            color: GlobalColors.textColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => navigateToForgetPasswordScreen(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    login(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    decoration: BoxDecoration(
                        color: GlobalColors.mainColor,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10)
                        ]),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.amaranth(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Don\`t have an account',
              style: GoogleFonts.amaranth(
                textStyle: TextStyle(
                  color: GlobalColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                navigateToRegisterScreen();
              },
              child: Text(
                '  Sign Up',
                style: GoogleFonts.amaranth(
                  textStyle: TextStyle(
                    color: GlobalColors.mainColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  navigateToForgetPasswordScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgetPasswordScreen(),
      ),
    );
  }

  navigateToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  void login(BuildContext context) {
    String email = emailController.text;

    String password = passwordController.text;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      checkUserType();
    }).catchError((e) {
      print(e);
      if (e.code == 'user-not-found') {
        // show error to user
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        // show error to user
        wrongPasswordMessage();
      }
    });
  }

  void checkUserType() {
    final userId = firebaseAuth.currentUser!.uid;

    firestore.collection("quizUsers").doc(userId).get().then((value) {
      if (!value.exists) {
        firebaseAuth.signOut();
        Fluttertoast.showToast(msg: "User not found!");
        return;
      }

      if (value.data()!.containsKey("block") && value.data()!['block']) {
        firebaseAuth.signOut();
        Fluttertoast.showToast(msg: "You are BLOCKED!");
        return;
      }

      if (value.data()!['admin']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const QuizAdminScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const QuizMainScreen(),
            ));
      }
    });
  }

  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.grey,
          title: Center(
            child: Text(
              'Incorrect Email',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.grey,
          title: Center(
            child: Text(
              'Incorrect Password',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
