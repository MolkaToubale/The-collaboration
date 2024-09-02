import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet/models/user.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'navigation_service.dart';

class UserService {
  static final collection = FirebaseFirestore.instance.collection('users');
  //Ajout d'un utilisateur
  static Future<bool> addUser(UserModel user) async {
    try {
      await collection.doc(user.id).set(user.toMap());
      return true;
    } on Exception catch (e) {
      log('Erreur lors de l\'ajout de l\'utilisateur:$e');
      return false;
    }
  }


  UserModel? getCurrentUser() {
    return NavigationService.navigatorKey.currentContext!
        .read<UserProvider>()
        .currentUser!;
  }

  static Future<UserModel?> getUser(String nom, String password) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nomPrenom', isEqualTo: nom)
        .where('password', isEqualTo: password)
        .get();
    log('user found : ${snapshot.docs.length}');
    if (snapshot.docs.isNotEmpty) {
      UserModel user = UserModel.fromMap(snapshot.docs.first.data());
      return user;
    } else {
      return null;
    }
  }

  static Future<UserModel?> getUserById(String id) async {
    final data = await collection.doc(id).get();
    return data.exists ? UserModel.fromMap(data.data()!) : null;
  }
}
