import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todotask/model/user_model.dart';

class AuthService {
  String collection = "user";
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<dynamic> signUpWithEmail(
    UserModel userinfo,
  ) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: userinfo.email!, password: userinfo.password!);
      final UserModel data =
          UserModel(email: userinfo.email, userName: userinfo.userName);
      await firestore
          .collection(collection)
          .doc(userCredential.user!.uid)
          .set(data.toJson());
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log("Error during sigh up:$e");
      return e.message;
    }
  }

  Future<dynamic> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      log("Error during sign in:$e");
      return e.message;
    }
  }

  Future<void> signOut() async {
    try {
      firebaseAuth.signOut();
    } catch (e) {
      log("error sign-out: $e");
      rethrow;
    }
  }
}
