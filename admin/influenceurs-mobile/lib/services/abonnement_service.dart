// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../models/abonnement.dart';

// class AbonnementService {
//   static final collection = FirebaseFirestore.instance.collection('Abonnement');
//   //Ajout d'un utilisateur
//   static Future<bool> addAbonnement(AbonnementModel abonnement) async {
//     try {
//       await collection.doc(abonnement.titre).set(abonnement.toMap());
//       return true;
//     } on Exception catch (e) {
//       log('Erreur lors de l\'ajout de l\'abonnement:$e');
//       return false;
//     }
//   }
// }
