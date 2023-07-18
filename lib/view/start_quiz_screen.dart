import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/view/quiz_main_screen.dart';

enum QuestionAnswers { one, two, three }

class StatQuizScreen extends StatefulWidget {
  const StatQuizScreen({super.key});

  @override
  State<StatQuizScreen> createState() => _StatQuizScreenState();
}

class _StatQuizScreenState extends State<StatQuizScreen> {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> questions = [];

  int currentQuestion = 0;
  int points = 0;
  Map<String, dynamic> question = {};

  QuestionAnswers questionAnswers = QuestionAnswers.one;

  void getQuestions() {
    firestore.collection("quizQuestions").get().then((value) {
      questions.clear();
      for (var document in value.docs) {
        final question = document.data();
        questions.add(question);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isNotEmpty) {
      question = questions[currentQuestion];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Question ${currentQuestion + 1} / ${questions.length}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "- ${question['question']}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 10),
                        RadioListTile<QuestionAnswers>(
                          title: Text(question['answerOne']),
                          value: QuestionAnswers.one,
                          groupValue: questionAnswers,
                          onChanged: (QuestionAnswers? question) {
                            setState(() {
                              questionAnswers = question!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        RadioListTile<QuestionAnswers>(
                          title: Text(question['answerTwo']),
                          value: QuestionAnswers.two,
                          groupValue: questionAnswers,
                          onChanged: (QuestionAnswers? question) {
                            setState(() {
                              questionAnswers = question!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        RadioListTile<QuestionAnswers>(
                          title: Text(question['answerThree']),
                          value: QuestionAnswers.three,
                          groupValue: questionAnswers,
                          onChanged: (QuestionAnswers? question) {
                            setState(() {
                              questionAnswers = question!;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => nextQuestion(),
                      child: Text(
                        (currentQuestion + 1 == questions.length)
                            ? "Finish"
                            : "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  nextQuestion() {
    // print(questionAnswers.name);
    // print(question['rightAnswer']);

    if (questionAnswers.name == question['rightAnswer']) {
      points++;
    }

    if (currentQuestion + 1 == questions.length) {
      showAlertDialog(context);
      return;
    }

    currentQuestion++;

    questionAnswers = QuestionAnswers.one;

    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const QuizMainScreen(),
          ),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("My title"),
      content: Text("Your points : $points"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
