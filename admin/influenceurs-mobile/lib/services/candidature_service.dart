import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/candidature.dart';


class CandidatureService{
  static final collection = FirebaseFirestore.instance.collection('Candidatures');
 //Add candidature
  static Future<bool>addcandidature(CandidatureModel candidature)async {
   try {
  await collection.doc(candidature.id).set(candidature.toMap());
  return true;
} on Exception catch (e) {
  log('Erreur lors de l\'ajout de candidature:$e');
  return false;
}
  }

   
}