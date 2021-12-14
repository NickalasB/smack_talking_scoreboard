import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'base_auth.dart';

class Cloudstore {
  final _fbCloudstore = Firestore.instance;

  static Cloudstore of(BuildContext context) =>
      Provider.of<Cloudstore>(context, listen: false);

  CollectionReference collection(String path) {
    return _fbCloudstore.collection(path);
  }

  Future<void> updateCollectionData(
    BuildContext context, {
    String gamePin,
    Map<String, dynamic> data,
  }) async {
    final user = await Auth.of(context).getCurrentUser();
    await _singleGameCollectionReference(user.email)
        .document(gamePin)
        .updateData(data);
  }

  Future<void> deleteSingleGame(BuildContext context, String pin) async {
    final user = await Auth.of(context).getCurrentUser();
    await _singleGameCollectionReference(user.email).document(pin).delete();
  }

  CollectionReference _singleGameCollectionReference(String userEmail) {
    return collection('accounts')
        .document(userEmail)
        .collection('single_games');
  }

  Future<void> createSingleGameCollection(
    BuildContext context, {
    String pin,
  }) async {
    final user = await Auth.of(context).getCurrentUser();
    final gameCollectionReference = _singleGameCollectionReference(user.email);

    final allDocs = await gameCollectionReference.getDocuments();
    final gamePaths = allDocs.documents.map((d) => d.reference.path);

    if (gamePaths.contains('${gameCollectionReference.document(pin).path}')) {
      throw Exception();
    } else {
      await _singleGameCollectionReference(user.email)
          .document(pin)
          .setData(gameElements);
    }
  }

  Map<String, dynamic> gameElements = {
    'player1Name': '',
    'player1Score': 0,
    'player1WinCount': 0,
    'player2Name': '',
    'player2Score': 0,
    'player2WinCount': 0,
    'ftwScore': 0,
    'numberOfRounds': null,
    'insult': ''
  };
}
