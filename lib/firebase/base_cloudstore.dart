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

  Future<void> setCollectionData({
    CollectionReference collection,
    String documentPath,
    Map<String, dynamic> data,
  }) async {
    await collection.document(documentPath).setData(data);
  }

  Future<void> updateCollectionData(
    CollectionReference collection,
    String documentPath,
    Map<String, dynamic> data,
  ) async {
    await collection.document(documentPath).updateData(data);
  }

  Future<void> post(
    CollectionReference collectionRef, {
    @required Map<String, dynamic> newData,
  }) async {
    _fbCloudstore.runTransaction((tx) async {
      final allDocs = await collectionRef.getDocuments();
      final toBeRetrieved =
          allDocs.documents.sublist(allDocs.documents.length ~/ 2);
      final toBeDeleted =
          allDocs.documents.sublist(0, allDocs.documents.length ~/ 2);
      await Future.forEach(toBeDeleted, (DocumentSnapshot snapshot) async {
        await tx.delete(snapshot.reference);
      });

      await Future.forEach(toBeRetrieved, (DocumentSnapshot snapshot) async {
        await tx.update(snapshot.reference, newData);
      });
    });
  }

  Future<void> deleteDocument(
    CollectionReference collectionRef,
    String documentPath,
  ) async {
    _fbCloudstore.runTransaction((tx) async {
      await tx.delete(collectionRef.document(documentPath));
    });
  }

  Future<void> deleteSingleGame(BuildContext context, String pin) async {
    final user = await Auth.of(context).getCurrentUser();
    final singleGamesCollectionPath = 'accounts/${user.uid}/single_games';

    await collection(singleGamesCollectionPath).document(pin).delete();
  }

  Future<void> createSingleGameCollection(BuildContext context,
      {String pin}) async {
    final user = await Auth.of(context).getCurrentUser();
    final singleGamesCollectionPath = 'accounts/${user.uid}/single_games';
    final singleGamesCollection = collection(singleGamesCollectionPath);
    final allDocs = await singleGamesCollection.getDocuments();

    final gamePaths = allDocs.documents.map((d) => d.reference.path);

    if (gamePaths.contains('$singleGamesCollectionPath/$pin')) {
      throw Exception();
    } else {
      await collection('accounts')
          .document(user.uid)
          .collection('single_games')
          .document(pin)
          .setData(gameElements);
    }
  }
}
