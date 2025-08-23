import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuestionsPage extends StatefulWidget {
  final String subject;
  final String quizType;

  const QuestionsPage({super.key, required this.subject, required this.quizType});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  List _questions = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final data = await rootBundle.loadString("assets/data/questions.json");
    final decoded = json.decode(data);

    setState(() {
      _questions = decoded[widget.subject]?[widget.quizType] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("${widget.subject} - ${widget.quizType}")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question number
                Text(
                  "${_currentIndex + 1}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 8),

                // Question text
                Text(
                  question["question"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),

                // Options
                ...question["options"].map<Widget>((opt) {
                  final isSelected = question["selected"] == opt;
                  final isCorrect = opt == question["answer"];

                  return Card(
                    color: isSelected
                        ? (isCorrect ? Colors.green[200] : Colors.red[200])
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(opt),
                      leading: Radio<String>(
                        value: opt,
                        groupValue: question["selected"],
                        onChanged: (val) {
                          setState(() {
                            question["selected"] = val;
                          });
                        },
                      ),
                      trailing: isSelected
                          ? Icon(
                              isCorrect ? Icons.check : Icons.close,
                              color: isCorrect ? Colors.green : Colors.red,
                            )
                          : null,
                    ),
                  );
                }).toList(),

                const SizedBox(height: 10),

                // Explanation toggle
                if (question["selected"] != null)
                  ExpansionTile(
                    title: const Text("Explanation"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          question["explanation"] ?? "No explanation provided.",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                const Spacer(),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentIndex > 0)
                      ElevatedButton(
                        onPressed: () => setState(() => _currentIndex--),
                        child: const Text("Previous"),
                      ),
                    if (_currentIndex < _questions.length - 1)
                      ElevatedButton(
                        onPressed: () => setState(() => _currentIndex++),
                        child: const Text("Next"),
                      ),
                    if (_currentIndex == _questions.length - 1)
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Quiz Completed 🎉")),
                          );
                        },
                        child: const Text("Finish"),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
