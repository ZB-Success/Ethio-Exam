import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/subjects.dart';
import '../widgets/theme_toggle_wrapper.dart';
import 'welcome_page.dart';
import 'perSubjectPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final jsonData = await rootBundle.loadString('assets/data/subjects.json');
    final List parsed = json.decode(jsonData);
    setState(() {
      _subjects = parsed.map((e) => Subject.fromJson(e)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeToggleWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Dashboard",
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0x033854),
          elevation: 0,
        ),
    drawer: Drawer(
          child: Column(
               children: [
                    UserAccountsDrawerHeader(
          decoration: const BoxDecoration(
            color: Color(0x033854),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).textTheme.bodyMedium?.color,
            child: const Icon(Icons.person, size: 40, color: Color(0xFF8E24AA)),
          ),
          accountName: Text(
            "Bruh W.",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color, 
            ),
          ),
          accountEmail: Text(
            "bruhtesheme@gmail.com",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
  ),
),

      Expanded(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text('Logout', style: TextStyle(color: Colors.red)),
        onTap: () {
          // Navigator.pop(context);
          Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => const WelcomePage(),
            transitionsBuilder: (_, animation, __, child) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutExpo,
              ));
              return SlideTransition(position: offsetAnimation, child: child);
            },
          ),
        );
        },
      ),
    ],
  ),
),

        body: _subjects.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grade 9 to 12 | Updated 2025",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, color: Theme.of(context).iconTheme.color),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: _subjects.length,
                      itemBuilder: (context, index) {
                        final category = _subjects[index];
                        return _buildCategoryCard(context, category);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Subject subject) {
    return Card(
      color: subject.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () {
           if (subject.locked) {
              ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${subject.name} is locked 🚫')),
          );
        } else {
          Navigator.push(context,MaterialPageRoute( builder: (context) => SubjectPage(subject: subject),),
    );
  }
},
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(subject.icon, size: 44, color: Colors.white),
                  if (subject.locked)
                    const Icon(Icons.lock, size: 24, color: Colors.white),
                ],
              ),
              const Spacer(),
              Text(
                subject.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
