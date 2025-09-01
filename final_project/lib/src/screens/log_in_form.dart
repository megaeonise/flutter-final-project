import 'package:final_project/src/screens/home.dart';
import 'package:final_project/src/service/backend_service.dart';
import 'package:flutter/material.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({super.key});

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _usernameFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _passVisible = false;
  final _logInFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> handleLogin(username, password) async {
    final status = await postLogin(username, password);
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
          key: _logInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                onPressed: () => handleLogin(
                  _usernameFieldController.text,
                  _passwordFieldController.text,
                ),
                child: Text("Log in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//SignUpForm
