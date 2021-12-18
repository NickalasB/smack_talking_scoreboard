import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  static Auth of(BuildContext context) =>
      Provider.of<Auth>(context, listen: false);

  Future<User> signInWithEmail(
      {@required String email, @required String password}) async {
    UserCredential result;

    result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print('Successfully signed in with $email');

    return result.user;
  }

  Future<User> signUpWithEmail(
      {@required String email, @required String password}) async {
    UserCredential result;

    result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print('Successfully signed up with $email');

    return result.user;
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    User user;
    user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print("Successfully signed in " + user.displayName);

    return user;
  }

  Future<User> getCurrentUser() async {
    User user = await _firebaseAuth.currentUser;
    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("Successfully signed out ");
  }

  Future<void> sendEmailVerification() async {
    User user = await _firebaseAuth.currentUser;
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    User user = await _firebaseAuth.currentUser;
    return user.emailVerified;
  }
}
