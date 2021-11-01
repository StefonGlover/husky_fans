import 'package:cloud_firestore/cloud_firestore.dart';

class RankedModel {
  String ranked, rankedBy;
  double ranking;
  Timestamp timeSent;



  RankedModel(this.ranked, this.rankedBy, this.ranking, this.timeSent);


  // creating a user object from a firebase snapshot
  RankedModel.fromSnapshot(DocumentSnapshot doc)
      : ranked = doc.get('ranked'),
        rankedBy = doc.get('rankedBy'),
        ranking = doc.get('ranking'),
       timeSent = doc.get('timeSent');

}