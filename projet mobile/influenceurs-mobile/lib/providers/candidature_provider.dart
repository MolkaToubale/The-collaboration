import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/candidature.dart';
import '../services/navigation_service.dart';

class CandidatureProvider extends ChangeNotifier {
  List<CandidatureModel> _candidatures = [];

  List<CandidatureModel> get candidatures => _candidatures;
  var currentUser = NavigationService.navigatorKey.currentContext!
      .watch<UserProvider>()
      .currentUser;
  
  Future<void> acceptAndUpdateCandidature(CandidatureModel candidature) async {
    try {
      FirebaseFirestore.instance
          .collection('Candidatures')
          .doc(candidature.id)
          .update({
        'reponse': 'Acceptee',
      });
      Fluttertoast.showToast(msg: 'Acceptation avec succés');
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Echec d\'acceptation');
    }
  }
  
    Future<void> refuseAndUpdateCandidature(CandidatureModel candidature) async {
     
      try{
         FirebaseFirestore.instance
          .collection('Candidatures')
          .doc(candidature.id)
          .update({
        'reponse': 'Declinee',
      });
      Fluttertoast.showToast(msg: 'Refus avec succés ');
      } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Echec du refus');
    }
  
    }
 Future<void> deleteCandidature(CandidatureModel candidature) async {
     
      try{
         FirebaseFirestore.instance
          .collection('Candidatures')
          .doc(candidature.id)
          .delete();
      Fluttertoast.showToast(msg: 'Ma candature supprimée avec succés ');
      } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: 'Echec de suppression');
    }
  
    }

}