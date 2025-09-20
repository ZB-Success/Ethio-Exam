import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/apiService.dart';
import '../services/local_storage.dart';
import '../widgets/theme_toggle_wrapper.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLoading = false;
  String? _message;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      final res = await ApiService.register(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
    print('data response $res');
  if (res["status"] == 200) {
    // success
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
   );
} else {
  final body = res["body"];
  setState(() {
    _message = body?["error"]?.toString() ?? body?["message"]?.toString() ?? "server error";
  });
}
    } catch (e) {
      setState(() {
        _message = "Something went wrong: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeToggleWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          leading: const BackButton(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (val) =>
                      val == null || !val.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (val) =>
                      val == null || val.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                  validator: (val) =>
                      val != _passwordCtrl.text ? 'Passwords don\'t match' : null,
                ),
                const SizedBox(height: 24),
                if (_message != null)
                  Text(
                    _message!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 12),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    :  ElevatedButton(
                                  onPressed: _register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Register Now',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color:Theme.of(context).textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
