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
    await collection('accounts/${user.email}/single_games')
        .document(gamePin)
        .updateData(data);
  }

  Future<void> deleteSingleGame(BuildContext context, String pin) async {
    final user = await Auth.of(context).getCurrentUser();
    final singleGamesCollectionPath = 'accounts/${user.uid}/single_games';

    await collection(singleGamesCollectionPath).document(pin).delete();
  }

  Future<CollectionReference> singleGameCollectionReference(
    BuildContext context,
  ) async {
    final user = await Auth.of(context).getCurrentUser();
    return collection('accounts/${user.email}/single_games');
  }

  Future<void> createSingleGameCollection(
    BuildContext context, {
    String pin,
  }) async {
    final user = await Auth.of(context).getCurrentUser();
    final gameCollectionReference =
        await singleGameCollectionReference(context);

    final allDocs = await gameCollectionReference.getDocuments();
    final gamePaths = allDocs.documents.map((d) => d.reference.path);

    if (gamePaths.contains('$gameCollectionReference/$pin')) {
      throw Exception();
    } else {
      await collection('accounts')
          .document(user.email)
          .collection('single_games')
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
