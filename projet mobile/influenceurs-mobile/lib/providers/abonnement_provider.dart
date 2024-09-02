import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/abonnement.dart';


class AbonnementProvider with ChangeNotifier {
  late AbonnementModel? currentAbonnement;

  final List<AbonnementModel> _abonnements = [];
  List<AbonnementModel> get abonnements => _abonnements;

  Future<void> getAbonnements() async {
    try {
      

       final data = await FirebaseFirestore.instance.collection('Abonnement').get();
    for (var abonnement in data.docs) {
      _abonnements.add(AbonnementModel.fromMap(abonnement.data()));
    }



    } catch (e) {
      log("erreur abo prov : $e");
    }
   
  }
}
