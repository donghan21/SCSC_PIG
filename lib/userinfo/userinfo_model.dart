import 'package:flutter/material.dart';
import 'package:scscpig/utils/model_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfoModel extends Model {
  final unFocusNode = FocusNode();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String get email => firebaseAuth.currentUser!.email!;
  String get emailForCheck => firebaseAuth.currentUser!.email! + ")";
  // get reservation list from firebase

  var db = FirebaseFirestore.instance;

  Future<List<String>> reservationList() async {
    QuerySnapshot querySnapshot = await db.collection('reservation').get();
    List<String> reservationList = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String email2 = data['user'].toString().split('/')[1];
      if (email2 == emailForCheck) {
        DateTime start = data['start_time'].toDate();
        DateTime end = data['end_time'].toDate();
        reservationList.add(start.toString() + '~' + end.toString());
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
