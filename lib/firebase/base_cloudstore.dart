import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Cloudstore {
  final _fbCloudstore = Firestore.instance;

  static Cloudstore of(BuildContext context) =>
      Provider.of<Cloudstore>(context, listen: false);

  CollectionReference collection(String path) {
    return _fbCloudstore.collection(path);
  }

  Future<void> setCollectionData(
    CollectionReference collection,
    String documentPath,
    Map<String, dynamic> data,
  ) async {
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
}
