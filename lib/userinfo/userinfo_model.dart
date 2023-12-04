import 'package:flutter/material.dart';
import 'package:scscpig/utils/model_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel extends Model {
  final unFocusNode = FocusNode();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String get email => firebaseAuth.currentUser!.email!;
  // get reservation list from firebase

  var db = FirebaseFirestore.instance;

  Future<List<String>> reservationList() async {
    QuerySnapshot querySnapshot = await db.collection('reservation').get();
    List<String> reservationList = [];
    for (var doc in querySnapshot.docs) {
      if (doc['user'] == email) {
        reservationList.add(doc['start_time'] + '~' + doc['end_time']);
      }
    }
    return reservationList;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unFocusNode.dispose();
  }
}
