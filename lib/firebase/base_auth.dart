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

  Future<FirebaseUser> signInWithEmail(
      {@required String email, @required String password}) async {
    AuthResult result;

    result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    print('Successfully signed in with $email');

    return result.user;
  }

  Future<FirebaseUser> signUpWithEmail(
      {@required String email, @required String password}) async {
    AuthResult result;

    result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    print('Successfully signed up with $email');

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
    user = (await _firebaseAuth.signInWithCredential(credential)).user;
    print("Successfully signed in " + user.displayName);

    return user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("Successfully signed out ");
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }
}
