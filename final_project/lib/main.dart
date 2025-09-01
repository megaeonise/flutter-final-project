import 'package:final_project/src/screens/log_in_form.dart';
import 'package:final_project/src/screens/sign_up_form.dart';
import 'package:final_project/src/service/backend_service.dart';
import 'package:flutter/material.dart';

void main() {
  initDio();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TempButtons());
  }
}

class TempButtons extends StatelessWidget {
  const TempButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LogInForm()),
                );
              },
              child: Text("Log in"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpForm()),
                );
              },
              child: Text("Sign up"),
            ),
          ],
        ),
      ),
    );
  }
}
