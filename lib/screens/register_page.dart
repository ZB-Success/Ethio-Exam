import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import 'login_page.dart';
import '../widgets/theme_toggle_wrapper.dart';

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

  void _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    

    final db = DBHelper();

    try {
      final exists = await db.userExists(_emailCtrl.text.trim());

      if (exists) {
        setState(() {
          _message = 'Email already registered.';
          _isLoading = false;
        });
        return;
      }

      await db.registerUser(_emailCtrl.text.trim(), _passwordCtrl.text);

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      setState(() {
        _message = 'Something went wrong: $e';
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
                  validator: (val) => val == null || !val.contains('@')
                      ? 'Enter valid email'
                      : null,
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
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
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
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Create Account'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
