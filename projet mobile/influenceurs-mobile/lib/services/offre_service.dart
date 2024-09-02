import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet/models/offre.dart';

class OffreService{
  static final collection = FirebaseFirestore.instance.collection('offres');
 //Ajout d'un utilisateur 
  static Future<bool>addOffre(OffreModel offre)async {
   try {
  await collection.doc(offre.id).set(offre.toMap());
  return true;
} on Exception catch (e) {
  log('Erreur lors de l\'ajout de l\'offre:$e');
  return false;
}
  }
}
