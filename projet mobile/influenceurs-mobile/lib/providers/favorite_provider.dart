import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projet/models/offre.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../services/navigation_service.dart';

class FavoriteProvider extends ChangeNotifier{
  List<OffreModel>_offres=[];
  List<String>_offresId=[];
  List <OffreModel> get offres=>_offres;
   List <String> get offresId=>_offresId;

   var currentUser = NavigationService.navigatorKey.currentContext!
          .watch<UserProvider>()
         .currentUser;


  Future<void>getFavorite()async{
   final data=await FirebaseFirestore.instance.collection('users').doc(currentUser!.id).collection('offres').get();
    for(var offre in data.docs)
    {
    _offres.add(OffreModel.fromMap(offre.data()));
    _offresId.add(offre.id);
    }
   }



  
  Future<void> addFavoriteToFirestore(OffreModel offre) async {
    
  try {
    final docRef =FirebaseFirestore.instance.collection('users').doc(currentUser!.id);
    final data = {
      'id':offre.id ,
                                          'libelle': offre.libelle,
                                          'idEntreprise': offre.idEntreprise,
                                          'nomEntreprise': offre.nomEntreprise,
                                          'description': offre.description,
                                          'dateDebut': offre.dateDebut,
                                          'dateFin': offre.dateFin,
                                          'affiche': offre.affiche,
                                          'categories': offre.categories
    };
    await docRef.collection('offres').doc(offre.id).set(data);
    Fluttertoast.showToast(msg: 'J\'aime');
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: 'Echec de l\'ajout à la liste des favoris');
  }
}

Future<void> removeFavoriteFromFirestore(OffreModel offre) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.id);
    await docRef.collection('offres').doc(offre.id).delete();
    Fluttertoast.showToast(msg: 'Je n\'aime plus');
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: 'Impossible de supprimer des favoris');
  }
}


  void toggleFavorite(OffreModel offre) async {
  final isExist = _offresId.contains(offre.id); // vérifie si l'offre est déjà dans les favoris
  if (isExist) {
    _offresId.remove(offre.id); // retire l'ID de l'offre des favoris
    _offres.remove(offre);
    removeFavoriteFromFirestore(offre);
  } else {
    _offresId.add(offre.id); // ajoute l'ID de l'offre aux favoris
    _offres.add(offre);
    addFavoriteToFirestore(offre);
  }
  notifyListeners();
}


  bool isExist (OffreModel offre){
   final isExit=_offres.contains(offre);
   return isExit;
  }

  void clearFavorite(){
    _offres=[];
    notifyListeners();
  }
  
}