import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/view/admin/quiz_admin_add_new_questions.dart';

class QuizAdminQuestionsScreen extends StatefulWidget {
  const QuizAdminQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<QuizAdminQuestionsScreen> createState() =>
      _QuizAdminQuestionsScreenState();
}

class _QuizAdminQuestionsScreenState extends State<QuizAdminQuestionsScreen> {
  final firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> questions = [];

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QuizAdminAddNewQuestionScreen(),
            ),
          ).then((value) => getQuestions());
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Container(
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
                Text(
                  "1 : ${question['answerOne']}",
                  style: TextStyle(
                    color: question['rightAnswer'] == "1"
                        ? Colors.green
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "2 : ${question['answerTwo']}",
                  style: TextStyle(
                    color: question['rightAnswer'] == "2"
                        ? Colors.green
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "3 : ${question['answerThree']}",
                  style: TextStyle(
                    color: question['rightAnswer'] == "3"
                        ? Colors.green
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed:() => deleteQuestions(index),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),)
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  deleteQuestions(int index) async {
    await firestore.collection("quizQuestions").doc(questions[index]['questionId']).delete();
    questions.removeAt(index);
    setState(() {});

  }

}

