import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/offre.dart';
import '../services/offre_service.dart';


class OffreProvider with ChangeNotifier{
  late OffreModel? currentOffre;

  List <OffreModel>_offres=[];
  List <OffreModel> get offres=>_offres;

     Future<void>getOffres()async{
      
    final data=await FirebaseFirestore.instance.collection('offres').get();
    for(var offre in data.docs)
    {
      
     _offres.add(OffreModel.fromMap(offre.data()));
     
    }
    
   }

  





  //   Stream<QuerySnapshot<Map<String, dynamic>>>? offreStream;

  //  startOffreListen(String offreId) {
  //    if (offreStream != null) return;
  //    offreStream =
  //       FirebaseFirestore.instance.collection("offres").where("id", isEqualTo:offreId).snapshots();
  //    offreStream?.listen((event) {}).onData((data) async {
  // //      // for (var d in data.docChanges) {
  // //      //   log(d.doc.data().toString());
  // //      // }
  //      currentOffre = OffreModel.fromMap(data.docChanges.first.doc.data()!);
  //       log("Offre mise à jour");
  //       notifyListeners();
  //     });
  //   }

  //  stopOffreListen() {
  //    if (offreStream == null) return;
  //    offreStream?.listen((event) {}).cancel();
  //    offreStream = null;
  //  }

  
}

