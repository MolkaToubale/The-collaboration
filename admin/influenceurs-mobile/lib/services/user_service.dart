

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/user.dart';

import '../providers/user_provider.dart';
import 'navigation_service.dart';

class UserService{
  static final collection = FirebaseFirestore.instance.collection('users');
 //Ajout d'un utilisateur 
  static Future<bool>addUser(UserModel user)async {
   try {
  await collection.doc(user.id).set(user.toMap());
  return true;
} on Exception catch (e) {
  log('Erreur lors de l\'ajout de l\'utilisateur:$e');
  return false;
}
  }
  
  // //Methode de recherche dans la messagerie en utilisant le nom d'utilisateur saisi dans la barre de recherche
  // Future<Stream<QuerySnapshot>> getUserByNomPrenom (String nomPrenom) async{
  //  return  FirebaseFirestore.instance.collection('users').where('nomPrenom', isEqualTo: nomPrenom).snapshots();

  // }

  
  UserModel? getCurrentUser() {
    return NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!;
  }
  static Future<UserModel?> getUser(String email, String password) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .get();

    if (snapshot.docs.isNotEmpty) {
      UserModel user = UserModel.fromMap(snapshot.docs.first.data());
      return user;
    } else {
      return null;
    }
  }

    static Future<UserModel?> getUserById(String id) async {
    final data = await collection.doc(id).get();
    return data.exists?  UserModel.fromMap(data.data()!) : null;
  }

   




}



