import 'package:final_project/src/screens/home.dart';
import 'package:final_project/src/service/backend_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _emailFieldController = TextEditingController();
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _passVisible = false;
  final _signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleRegister(email, username, password) async {
    final status = await postRegister(email, username, password);
    if (status && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _signUpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailFieldController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Email",
                ),
              ),
              TextField(
                controller: _usernameFieldController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Username",
                ),
              ),
              TextField(
                controller: _passwordFieldController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passVisible = !_passVisible;
                      });
                    },
                    icon: Icon(
                      _passVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !_passVisible,
              ),
              ElevatedButton(
                onPressed: () => handleRegister(
                  _emailFieldController.text,
                  _usernameFieldController.text,
                  _passwordFieldController.text,
                ),
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//SignUpForm