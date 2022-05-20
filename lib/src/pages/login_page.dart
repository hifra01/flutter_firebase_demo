import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/pages/home_page.dart';
import 'package:flutter_firebase_demo/src/pages/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const routeName = "/login";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 128,
                ),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const LoginForm(),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'atau',
                  style: TextStyle(fontSize: 12),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      RegisterPage.routeName,
                    );
                  },
                  child: const Text(
                    'Buat akun baru',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _hidePassword = true;
  bool _isLoginDisabled = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _doLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoginDisabled = true;
      });
      String email = _emailController.text;
      String password = _passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mencoba login...'),
        ),
      );
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _showPassword = _hidePassword
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    return Form(
      key: _formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                label: Text('E-mail'),
              ),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-mail tidak boleh kosong';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Password'),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                  icon: _showPassword,
                ),
              ),
              obscureText: _hidePassword,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoginDisabled ? null : _doLogin,
                child: _isLoginDisabled
                    ? const CircularProgressIndicator()
                    : const Text('LOGIN'),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.infinity, 48),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
