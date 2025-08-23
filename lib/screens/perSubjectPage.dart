import 'package:flutter/material.dart';
import '../model/subjects.dart';
import 'QuestionsPage.dart';

class Quiz {
  final String name;
  final String type; // final, mid, model, matric
  final bool locked;

  Quiz({required this.name, required this.type, required this.locked});
}

class SubjectPage extends StatefulWidget {
  final Subject subject;
  const SubjectPage({super.key, required this.subject});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage>
    with SingleTickerProviderStateMixin {
  late final List<String> quizTypes;
  late final TabController _tabController;
  late final List<Quiz> quizzes;

  @override
  void initState() {
    super.initState();

    quizTypes = ["final", "mid", "model", "matric"];
    _tabController = TabController(length: quizTypes.length, vsync: this);

    // Example quizzes — in real app, fetch from DB or API
    quizzes = [
      Quiz(name: "${widget.subject.name} Final 1", type: "final", locked: false),
      Quiz(name: "${widget.subject.name} Final 2", type: "final", locked: true),
      Quiz(name: "${widget.subject.name} Mid 1", type: "mid", locked: false),
      Quiz(name: "${widget.subject.name} Model 1", type: "model", locked: false),
      Quiz(name: "${widget.subject.name} Matric 1", type: "matric", locked: true),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
        backgroundColor: widget.subject.color,
        bottom: TabBar(
          controller: _tabController,
          tabs: quizTypes.map((e) => Tab(text: e.toUpperCase())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: quizTypes.map((type) => _buildQuizGrid(type)).toList(),
      ),
    );
  }

  Widget _buildQuizGrid(String type) {
    final filtered = quizzes.where((q) => q.type == type).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("No quizzes available"));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final quiz = filtered[index];
        return GestureDetector(
          onTap: () {
            if (quiz.locked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${quiz.name} is locked 🚫")),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      QuizPage(subject: widget.subject, quiz: quiz),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: quiz.locked ? Colors.grey[300] : widget.subject.color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  quiz.locked ? Icons.lock : Icons.quiz,
                  size: 32,
                  color: Colors.black54,
                ),
                const SizedBox(height: 8),
                Text(
                  quiz.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class QuizPage extends StatefulWidget {
  final Subject subject;
  final Quiz quiz;
  const QuizPage({super.key, required this.subject, required this.quiz});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  void initState() {
    super.initState();
    // Redirect after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuestionsPage(
            subject: widget.subject.name,
            quizType: widget.quiz.type,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading screen until redirect
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

