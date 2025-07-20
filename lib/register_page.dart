import 'package:flutter/material.dart';
import 'widgets/theme_toggle_wrapper.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeToggleWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: const Center(child: Text('Register Screen')),
      ),
    );
  }
}
