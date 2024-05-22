// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todotask/controller/auth_provider.dart';
import 'package:todotask/view/authentication/sign_up.dart';
import 'package:todotask/view/home_screen.dart'; // Make sure to create and import your HomeScreen widget
import 'package:todotask/widgets/app_bar.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<AuthController>(context, listen: false);

    return Scaffold(
      appBar: AppBarWidget(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: CustomText(
                text: "Sign up",
                color: Color.fromARGB(255, 17, 126, 194),
                size: 15,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset("assets/todo-cloud-hero.png"),
                ),
                CustomText(
                  text: 'Glad to see you again!',
                  size: 20,
                ),
                CustomText(
                  size: 13,
                  bold: false,
                  textAlign: TextAlign.start,
                  text: 'Log in to continue managing your tasks!',
                ),
                SizedBox(
                  height: size.width * 0.03,
                ),
                TextFormField(
                  controller: provider.emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: provider.passwordController,
                  decoration: InputDecoration(
                    labelText: 'Passwor',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final error = await provider.signInWithEmail(
                          provider.emailController.text.trim(),
                          provider.passwordController.text.trim());
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login successful!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                        );
                      }
                    }
                  },
                  child: Center(child: Text('Log In')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
