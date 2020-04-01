import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

enum AuthStatus {
  UNKNOWN,
  LOGGED_IN,
  LOGGED_OUT,
}

class Auth {
  final _firebaseAuth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();

  AuthStatus _authStatus;

  static Auth of(BuildContext context) =>
      Provider.of<Auth>(context, listen: false);

  Future<FirebaseUser> signInWithEmail(
      {@required String email, @required String password}) async {
    AuthResult result;

    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      _authStatus = AuthStatus.LOGGED_IN;
      print('Successfully signed in with $email');
    } catch (e) {
      print('Problem logging in $e');
      _authStatus = AuthStatus.LOGGED_OUT;
    }
    return result.user;
  }

  Future<FirebaseUser> signUpWithEmail(
      {@required String email, @required String password}) async {
    AuthResult result;

    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      _authStatus = AuthStatus.LOGGED_IN;
      print('Successfully signed up with $email');
    } catch (e) {
      print('Problem logging in $e');
      _authStatus = AuthStatus.LOGGED_OUT;
    }
    return result.user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user;
    try {
      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      print("Successfully signed in " + user.displayName);
      _authStatus = AuthStatus.LOGGED_IN;
    } catch (e) {
      print('Problem logging in $e');
      _authStatus = AuthStatus.LOGGED_OUT;
    }
    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _authStatus = AuthStatus.LOGGED_OUT;
    } catch (e) {
      print('Problem logging out: $e');
      _authStatus = AuthStatus.UNKNOWN;
    }
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  AuthStatus get authStatus => _authStatus;
}
