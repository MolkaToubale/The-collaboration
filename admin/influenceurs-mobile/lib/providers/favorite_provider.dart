import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';

import '../services/navigation_service.dart';

class FavoriteProvider extends ChangeNotifier{
  List<OffreModel>_offres=[];
  List <OffreModel> get offres=>_offres;
   var currentUser = NavigationService.navigatorKey.currentContext!
          .watch<UserProvider>()
         .currentUser;


  // Future<void>getFavorite()async{
  //  final data=await FirebaseFirestore.instance.collection('offres favorites').doc(currentUser!.id).collection('offres') .get();
  //  for(var offre in data.docs)
  //  {
  //   _offres.add(OffreModel.fromMap(offre.data()));
  //  }
  // }

  

  
  Future<void> addFavoriteToFirestore(OffreModel offre) async {
    
  try {
    final docRef =FirebaseFirestore.instance.collection('offres favorites').doc(currentUser!.id);
    final data = {
      'offreId': offre.id,
      'description':offre.description,
      'nomEntreprise':offre.nomEntreprise,
      'idEntreprise':offre.idEntreprise,
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
    final docRef = FirebaseFirestore.instance.collection('offres favorites').doc(currentUser!.id);
    await docRef.collection('offres').doc(offre.id).delete();
    Fluttertoast.showToast(msg: 'Je n\'aime plus');
  } catch (e) {
    print(e);
    Fluttertoast.showToast(msg: 'Impossible de supprimer des favoris');
  }
}

  void toggleFavorite(OffreModel offre)async{
   final isExist=_offres.contains(offre);
   if(isExist){
    _offres.remove(offre);
    removeFavoriteFromFirestore(offre);

   }else{
    _offres.add(offre);
  //    CollectionReference collectionRef=FirebaseFirestore.instance.collection('offres favorites');
  //    return collectionRef.doc(currentUser!.id).collection('Offres').doc().set({
  //    'affiche':offre.affiche,
  //    'libelle':offre.libelle,
  //    'description':offre.description,
  //    'idEntreprise':offre.idEntreprise,
  //    'idUtilisateur':currentUser!.id,
  //    'idOffre':offre.id,
  //  }).then((value) =>  Fluttertoast.showToast(msg:"J'aime"));
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