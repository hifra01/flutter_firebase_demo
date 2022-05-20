import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/src/pages/home_page.dart';
import 'package:flutter_firebase_demo/src/pages/login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const routeName = "/register";

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
                  'Buat akun baru',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                const RegisterForm(),
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
                      LoginPage.routeName,
                    );
                  },
                  child: const Text(
                    'Login',
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

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isRegisterDisabled = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _doRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isRegisterDisabled = true;
      });
      String fullName = _fullNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sedang membuat akun...'),
          duration: Duration(seconds: 3),
        ),
      );

      try {
        UserCredential result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        User user = result.user!;
        user.updateDisplayName(fullName);
        Navigator.pushReplacementNamed(context, HomePage.routeName);
      } on FirebaseException catch (e) {
        setState(() {
          _isRegisterDisabled = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Terjadi kesalahan'),
              content: Text(e.message ?? "Terjadi kesalahan"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Tutup"),
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _showPassword = _hidePassword
        ? const Icon(Icons.visibility)
        : const Icon(Icons.visibility_off);
    Widget _showConfirmPassword = _hideConfirmPassword
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
                label: Text('Nama lengkap'),
              ),
              controller: _fullNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mohon masukkan nama Anda';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text('E-mail'),
              ),
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'E-mail tidak boleh kosong';
                } else if (!EmailValidator.validate(value)) {
                  return 'Format e-mail tidak valid';
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
                } else if (value.length < 6) {
                  return 'Panjang password minimal 6 karakter';
                }
                return null;
              },
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: const Text('Konfirmasi Password'),
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _hideConfirmPassword = !_hideConfirmPassword;
                    });
                  },
                  icon: _showConfirmPassword,
                ),
              ),
              obscureText: _hideConfirmPassword,
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value != _passwordController.text) {
                  return 'Konfirmasi password tidak sesuai';
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
                onPressed: _isRegisterDisabled ? null : _doRegister,
                child: _isRegisterDisabled
                    ? const CircularProgressIndicator()
                    : const Text('REGISTER'),
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
