// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:provider/provider.dart';
import '../models/offre.dart';

class OffreProvider with ChangeNotifier {
  late OffreModel? currentOffre;
  List<OffreModel> offres = [];
  List<OffreModel> offresCourantes = [];

  Future<void> getOffres() async {
    offres = [];
    offresCourantes = [];
    final data = await FirebaseFirestore.instance.collection('offres').get();
    for (var offre in data.docs) {
      OffreModel o = OffreModel.fromMap(offre.data());
      offres.add(o);
      if (o.dateFin.isAfter(DateTime.now())) {
        offresCourantes.add(o);
      }

      
    }
    
    fetchOffres(NavigationService.navigatorKey.currentContext!
          .read<UserProvider>()
          .currentUser!
          .id);
  }

//-------------------
  List<OffreModel> userOffres = [];
  List<OffreModel> userAnciennesOffres = [];
  List<OffreModel> userOffresEnCours = [];


  //Méthodes pour récupérer la liste des offres
  fetchOffres(String userId) {
    userOffres = offres.where((offre) => offre.idEntreprise == userId).toList();
    userAnciennesOffres = userOffres
        .where((offre) => offre.dateFin.isBefore(DateTime.now()))
        .toList();
    userOffresEnCours = userOffres
        .where((offre) => offre.dateFin.isAfter(DateTime.now()))
        .toList();
    log(userOffres.length.toString());
    notifyListeners();
  }

}
