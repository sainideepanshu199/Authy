import 'dart:async';
import 'package:authentication_app/ui/auth/decide_screen.dart';
import 'package:authentication_app/ui/auth/login_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DecideScreen()));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}
