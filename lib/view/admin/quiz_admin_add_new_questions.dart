import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utiils/global.color.dart';

class QuizAdminAddNewQuestionScreen extends StatefulWidget {
  const QuizAdminAddNewQuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuizAdminAddNewQuestionScreen> createState() =>
      _QuizAdminAddNewQuestionState();
}

class _QuizAdminAddNewQuestionState
    extends State<QuizAdminAddNewQuestionScreen> {
  final questionController = TextEditingController();

  final answerOneController = TextEditingController();

  final answerTwoController = TextEditingController();

  final answerThreeController = TextEditingController();

  final rightAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new question"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: questionController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Question',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.question_mark_outlined,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: answerOneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.question_answer),
                  labelText: "Answer 1",
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: answerTwoController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Answer 2',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.question_answer,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: answerThreeController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Answer 3',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.question_answer,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: rightAnswerController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Right Answer',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.check,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: MaterialButton(
                  color: GlobalColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  onPressed: () => addQuestion(),
                  child: const Text(
                    "Add Question",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addQuestion() {
    String question = questionController.text;
    String answerOne = answerOneController.text;
    String answerTwo = answerTwoController.text;
    String answerThree = answerThreeController.text;
    String rightAnswer = rightAnswerController.text;

    String questionId = DateTime.now().millisecondsSinceEpoch.toString();

    Map<String, dynamic> data = {
      "questionId": questionId,
      "question": question,
      "answerOne": answerOne,
      "answerTwo": answerTwo,
      "answerThree": answerThree,
      "rightAnswer": rightAnswer,
    };

    FirebaseFirestore.instance.collection("quizQuestions")
        .doc(questionId)
        .set(data)
        .then((value) => Navigator.pop(context));
  }
}