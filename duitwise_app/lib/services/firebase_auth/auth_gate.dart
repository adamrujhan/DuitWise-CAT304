import 'package:duitwise_app/modules/auth/view/sign_in_page.dart';
import 'package:duitwise_app/modules/onboarding/view/start_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return StartPage(); // your home screen
        }

        return SignInPage(); // your login screen
      },
    );
  }
}
