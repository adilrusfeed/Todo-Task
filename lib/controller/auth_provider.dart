import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todotask/model/user_model.dart';
import 'package:todotask/service/auth_service.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  Future<dynamic> signUpWithEmail() async {
    final name = textToCamelCase(text: usernameController.text.trim());

    final data = UserModel(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        userName: name);

    final error = await _authService.signUpWithEmail(data);
    if (error is FirebaseException) {
      return error.message;
    }
  }

  Future<dynamic> signInWithEmail(String email, String password) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final error = await _authService.signInWithEmail(email, password);
    if (error is String) {
      return error; // Error message returned by FirebaseAuthException
    }
    clearControllers();
    notifyListeners();
  }

  Future<void> signIout() async {
    await _authService.signOut();
    notifyListeners();
  }

  void clearControllers() {
    emailController.clear();
    usernameController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    notifyListeners();
  }
}

String textToCamelCase({required String text}) {
  List splited = text.split(' ');
  List<String> capitalLetter = [];
  for (var x in splited) {
    capitalLetter.add(x[0].toUpperCase() + x.substring(1));
  }
  String join = capitalLetter.join(' ');
  return join;
}
