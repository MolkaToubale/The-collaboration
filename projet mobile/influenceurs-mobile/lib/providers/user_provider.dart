import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:projet/screens/welcome_screen.dart';

import '../services/shared_data.dart';
import '../services/shared_preferences.dart';
import '../extra/models/messenger/message_model.dart';
import '../extra/models/messenger/user/user.dart';
import '../models/user.dart';
import '../services/navigation_service.dart';
import '../services/user_service.dart';
import '../widgets/buttom_bar.dart';

class UserProvider with ChangeNotifier {
  UserModel? currentUser;

  Future<void> signIn(
      BuildContext context, String emailOrName, String password) async {
    try {
      // Recherche d'un utilisateur correspondant à l'email
      final emailQuery = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: emailOrName)
          .limit(1);
      final emailSnapshot = await emailQuery.get();

      // Si aucun utilisateur n'a été trouvé pour l'email, recherche d'un utilisateur correspondant au nom et prénom
      if (emailSnapshot.docs.isEmpty) {
        final fullNameQuery = FirebaseFirestore.instance
            .collection('users')
            .where('nomPrenom', isEqualTo: emailOrName)
            .limit(1);
        final fullNameSnapshot = await fullNameQuery.get();

        if (fullNameSnapshot.docs.isEmpty) {
          // Si aucun utilisateur n'a été trouvé pour l'email ou le nom et prénom, afficher un message d'erreur
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Erreur d'authentification"),
              content: const Text(
                "Impossible de se connecter avec les informations d'identification fournies.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        } else {
          // Si un utilisateur correspond au nom et prénom, utiliser cet utilisateur
          currentUser = UserModel.fromMap(fullNameSnapshot.docs.first.data());
          log(currentUser.toString());
          notifyListeners();
          startUserListen(currentUser!.id);
          //navigation
          DataPrefrences.setLogin(emailOrName);
          DataPrefrences.setPassword(password);
          SharedPreferenceHelper().saveUserEmail(currentUser!.email);
          SharedPreferenceHelper().saveUserId(currentUser!.id);
          SharedPreferenceHelper().saveUserName(currentUser!.nomPrenom);
          SharedPreferenceHelper().saveUserStatut(currentUser!.statut);
          SharedPreferenceHelper().saveUserProfileUrl(currentUser!.photo);
          // log(SharedPreferenceHelper.nomPrenomKey);
        }
      } else {
        log(currentUser.toString());
        currentUser = UserModel.fromMap(emailSnapshot.docs.first.data());
        startUserListen(currentUser!.id);
        notifyListeners();
        //navigation
        DataPrefrences.setLogin(emailOrName);
        DataPrefrences.setPassword(password);
        SharedPreferenceHelper().saveUserEmail(currentUser!.email);
        SharedPreferenceHelper().saveUserId(currentUser!.id);
        SharedPreferenceHelper().saveUserName(currentUser!.nomPrenom);
        SharedPreferenceHelper().saveUserStatut(currentUser!.statut);
        SharedPreferenceHelper().saveUserProfileUrl(currentUser!.photo);

        // Si un utilisateur correspond à l'email, utiliser cet utilisateur
      }

      // Vérifier que le mot de passe correspond à celui de l'utilisateur
      if (currentUser?.password == password) {
        SharedPreferenceHelper().saveUserEmail(currentUser!.email);
        SharedPreferenceHelper().saveUserId(currentUser!.id);
        SharedPreferenceHelper().saveUserName(currentUser!.nomPrenom);
        SharedPreferenceHelper().saveUserStatut(currentUser!.statut);
        SharedPreferenceHelper().saveUserProfileUrl(currentUser!.photo);
        log(currentUser.toString());
        startUserListen(currentUser!.id);

        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BottomNavController()));
      } else {
        // Si le mot de passe ne correspond pas, afficher un message d'erreur
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Erreur d'authentification"),
            content: const Text(
              "Impossible de se connecter avec les informations d'identification fournies.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('$e');
    }
  }

  //******Méthode de déconnexion***************//
  void signOut(BuildContext context) {
    // Réinitialiser l'utilisateur actuel
    currentUser = null;
    removeData();
    stopUserListen();
    SharedPreferenceHelper().saveUserEmail('');
    SharedPreferenceHelper().saveUserId('');
    SharedPreferenceHelper().saveUserName('');
    SharedPreferenceHelper().saveUserStatut('');
    SharedPreferenceHelper().saveUserProfileUrl('');
    // Naviguer vers la page de connexion
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> removeData() async {
    
    stopUserListen();
    currentUser = null;
    DataPrefrences.setLogin("");
    DataPrefrences.setPassword("");
  }

  // login & signup
  Future<void> logOut(context) async {
    await removeData();
    Navigator.pushReplacement(NavigationService.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => const WelcomeScreen()));
  }

  Future<bool> updateInfo(Map<String, dynamic> updatedInfo) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.id)
          .update(updatedInfo);
     
      Fluttertoast.showToast(msg: "Modification avec succés");
      return true;
    } on Exception catch (e) {
      log("Erreur lors de la modification : $e");
      Fluttertoast.showToast(msg: "Erreur de modification");
      return false;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? userStream;

  startUserListen(String userId) {
    if (userStream != null) return;
    userStream =
        UserService.collection.where("id", isEqualTo: userId).snapshots();
    userStream?.listen((event) {}).onData((data) async {
      
      currentUser = UserModel.fromMap(data.docChanges.first.doc.data()!);
      log("utilisateur mis à jour");
      notifyListeners();
    });
  }

  stopUserListen() {
    if (userStream == null) return;
    userStream?.listen((event) {}).cancel();
    userStream = null;
  }

  Future<bool> checkLogin() async {
    log("${DataPrefrences.getLogin()} , ${DataPrefrences.getPassword()}");
    if (DataPrefrences.getLogin().isEmpty ||
        DataPrefrences.getPassword().isEmpty) return false;
   

    var u = await UserService.getUser(
        DataPrefrences.getLogin(), DataPrefrences.getPassword());
    

    if (u != null) {
      currentUser = u;
      startUserListen(u.id);
     
      log("connecté");

      Navigator.of(NavigationService.navigatorKey.currentContext!)
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const BottomNavController()),
              (Route<dynamic> route) => false);
    
      return true;
    } else {
      return false;
    }
  }

  bool isProcessing = false;
  bool isLoading = false;

  int? unReadMsgsCount = 0;
  StreamSubscription<QuerySnapshot<Object?>>? streamSubscription;

 // Méthode pour ajouter un nouveau message dans une chatroom existante
  Future<void> addNewMessage(String? chatRoomId, String? msg,
      String? fromUserId, String? msgType) async {
    final mesgDocRef = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'date': DateTime.now(),
      'from': fromUserId,
      'msg': msg,
      'msgType': msgType,
      'seenBy': []
    });

    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatRoomId)
        .update({
      "lastMsgSent": DateTime.now(),
      'lastMsgDocumentRefId': mesgDocRef.id,
      "deletedBy": []
    });
  }
//Cette méthode vérifie si la chatroom est existante ou pas et par la suite appeler les méthodes concernées par le traitement qui va en suivre
  Future addChat(User userF, User userT, String? msg, String? msgType) async {
    var test = false;
    String userToId = userT.id.toString();
    String userFromId = userF.id.toString();
    final newRoomId = _generateUniqueRoomChatId(userFromId, userToId); //génération d'une chatroom car l'image pour être envoyée ne nécessite pas l'appui sur l'icone envoyer

    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(newRoomId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        test = true;
      } else {}
    });

    if (test) {
      addNewMessage(newRoomId, msg, userFromId, msgType);
    } else {
      addNewRoomChat(userF, userT, msg, msgType);
    }
   
  }

  //Si la chatroom est existante alors ajout d'un nouveau message et mise à jour des champs de la chatroom dans firestore
  Future addNewRoomChat(
      User userF, User userT, String? msg, String? msgType) async {
    String userToId = userT.id!;
    String userFromId = userF.id!;
    final newRoomId = _generateUniqueRoomChatId(userFromId, userToId);
    final refRoomChat = FirebaseFirestore.instance.collection('chatroom');
    List<dynamic> users = [userFromId, userToId];

    await refRoomChat.doc(newRoomId).set({
      "createdAt": DateTime.now(),
      "lastMsgSent": DateTime.now(),
      "users": users,
      "lastMsgDocumentRefId": "",
      "deletedBy": [],
    });
    //Ajout d'une ref à cette chatroom dans le document des utilisateurs concernés par cette conversation
    final ref = await refRoomChat.doc(newRoomId).get();
    await FirebaseFirestore.instance.collection('users').doc(userF.id).update({
      "chatrooms": FieldValue.arrayUnion([ref.reference])
    });

    await FirebaseFirestore.instance.collection('users').doc(userT.id).update({
      "chatrooms": FieldValue.arrayUnion([ref.reference])
    });

    addNewMessage(newRoomId, msg, userFromId, msgType);
  }

  

  Future deleteRoomChat(
      String? userFromId, String? userToId, String? currentUserId) async {
    final roomId = _generateUniqueRoomChatId(userFromId!, userToId!);
    final refRoomChat = FirebaseFirestore.instance.collection('chatroom');
    final ref = await refRoomChat.doc(roomId).get();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userFromId)
        .update({
      "chatrooms": FieldValue.arrayUnion([ref.reference])
    });
  }

  String? _generateUniqueRoomChatId(String? a, String? b) {
    int length = a!.length > b!.length ? b.length : a.length;
    for (int x = 0; x < length; x++) {
      if (a.codeUnitAt(x) != b.codeUnitAt(x)) {
        if (a.codeUnitAt(x) > b.codeUnitAt(x)) {
          return a + b;
        } else {
          return b + a;
        }
      }
    }
    return null;
  }

  Future<void> cancelSub() async {
    if (streamSubscription != null) streamSubscription!.cancel();
  }
   
   //Vérifier si une écoute est en cours et dans ce cas l'arrêter puis recommencer l'écoute sinon commencer l'écoute
  void reStartListeningForMessagesUnReadCount() async {
    await cancelSub();
    await _listenToSub();
  }

//établissement d'un abonnement aux mises à jour de la collection "chatroom" de Firestore + compter les messages non lus
  Future<void> _listenToSub() async {
    streamSubscription = FirebaseFirestore.instance
        .collection('chatroom')
        .where('users', arrayContainsAny: [currentUser!.id])
        .orderBy("lastMsgSent", descending: true)
        .snapshots()
        .listen((_) {});

    streamSubscription!.onData((data) async {
      unReadMsgsCount = 0;
      notifyListeners();

      for (var element in data.docs) {
        final ms = await FirebaseFirestore.instance
            .collection("chatroom")
            .doc(element.id)
            .collection("messages")
            .get();

        List<Message> messages =
            ms.docs.map((e) => Message.fromFireStore(e)).toList();

        messages.sort((b, a) => a.date!.compareTo(b.date!));
        if (messages.isNotEmpty &&
            !messages[0].seenBy!.contains(currentUser!.id) &&
            messages[0].from != currentUser!.id) {
          unReadMsgsCount = unReadMsgsCount! + 1;
          notifyListeners();
        }
      }
    });
  }

  Future<void> startListeningForMessagesUnReadCount() async {
    await _listenToSub();
  }

  Future<void> userLoginUpdateToFireBase() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.id)
        .update({
      'lastLoginDate': DateTime.now().millisecondsSinceEpoch,
      'isLoggedIn': true
    });
  }

  Future<void> userLogoutUpdateToFireBase() async {
    await cancelSub();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.id)
        .update({
      'lastLogoutDate': DateTime.now(),
      'isLoggedIn': false,
      'fcmToken': ''
    });
  }

  Future<void> deleteUser(String userId, String userStatus) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      // Sauvegarder les données de l'utilisateur dans la collection "deleted_users"
      await FirebaseFirestore.instance
          .collection('deleted_users')
          .doc(userId)
          .set(userSnapshot.data() as Map<String, dynamic>);
      // Supprimer l'utilisateur de la collection "users"
      await userRef.delete();
      // Vérifier le statut de l'utilisateur
      if (userStatus == 'Entreprise') {
        // Supprimer toutes les offres associées à l'utilisateur de la collection "offres"
        QuerySnapshot offresSnapshot = await FirebaseFirestore.instance
            .collection('offres')
            .where('idEntreprise', isEqualTo: userId)
            .get();
        for (var offre in offresSnapshot.docs) {
          offre.reference.delete();
        }
       
      } else if (userStatus == 'Influenceur') {
        // Supprimer toutes les candidatures associées à l'utilisateur de la collection "candidatures"
        QuerySnapshot candidaturesSnapshot = await FirebaseFirestore.instance
            .collection('Candidatures')
            .where('idInfluenceur', isEqualTo: userId)
            .get();
        for (var candidature in candidaturesSnapshot.docs) {
          candidature.reference.delete();
        }
       
      }
    }
  }
}
