import 'package:flutter/material.dart';
import 'widgets/theme_toggle_wrapper.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Subject card data
  final List<Map<String, dynamic>> _examCategories = const [
    {
      'name': 'BIOLOGY',
      'icon': Icons.science,
      'color': Color(0xFF4CAF50),
      'locked': true,
    },
    {
      'name': 'PHYSICS',
      'icon': Icons.lightbulb_outline,
      'color': Color(0xFFF44336),
      'locked': true,
    },
    {
      'name': 'CHEMISTRY',
      'icon': Icons.opacity,
      'color': Color(0xFF009688),
      'locked': false,
    },
    {
      'name': 'MATHS NATURAL',
      'icon': Icons.calculate,
      'color': Color(0xFF9E9E9E),
      'locked': false,
    },
    {
      'name': 'CIVICS',
      'icon': Icons.gavel,
      'color': Color(0xFF2196F3),
      'locked': true,
    },
    {
      'name': 'HISTORY',
      'icon': Icons.history,
      'color': Color(0xFF795548),
      'locked': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeToggleWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ethio Exam App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF8E24AA),
          leading: const BackButton(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          elevation: 0,
        ),
        body: Column(
          children: [
            // Grade/year banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Grade 9 to 12 | 2014–2016",
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
            // Grid of subjects
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.9,
                ),
                itemCount: _examCategories.length,
                itemBuilder: (context, index) {
                  final category = _examCategories[index];
                  return _buildCategoryCard(
                    context,
                    category['name'] as String,
                    category['icon'] as IconData,
                    category['color'] as Color,
                    category['locked'] as bool,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
    bool locked,
  ) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 6,
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () {
          if (locked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$name is locked 🚫')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening $name 📘')),
            );
            // You can add your navigation here
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
                  Icon(icon, size: 44, color: Colors.white),
                  if (locked)
                    const Icon(Icons.lock, size: 24, color: Colors.white),
                ],
              ),
              const Spacer(),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
