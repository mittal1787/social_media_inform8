

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Future<bool> loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var user = _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      print(user.toString());
      return user != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signupWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      print(email);
      print(password);
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

}