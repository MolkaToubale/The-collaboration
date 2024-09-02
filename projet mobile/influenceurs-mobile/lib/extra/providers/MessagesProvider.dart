import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../services/navigation_service.dart';
import '../Messenger/data_bloc_conver.dart';
import '../models/messenger/conversation_model.dart';
import '../models/messenger/message_model.dart';
import '../models/messenger/user/user.dart';

class MessagesProvider extends ChangeNotifier {
  DataBloc<Conversation>? messagesDataBloc;
  StreamSubscription<QuerySnapshot<Object?>>? streamSubscription;
  Query? cr;
  bool? _isFetchingMessages = false;

  DataBloc<Conversation>? messagesDataBlocDoura;
  StreamSubscription<QuerySnapshot<Object?>>? streamSubscriptionDoura;
  bool? _isFetchingMessagesDoura = false;

  @override
  void dispose() {
    super.dispose();
    streamSubscription!.cancel();
    streamSubscriptionDoura!.cancel();
  }

  Future<void> listenStreamSubscription() async {
    streamSubscription =
        messagesDataBloc!.query!.snapshots().listen((event) async {
      if (event.docChanges.isNotEmpty) {
        if (event.docChanges.length == event.docs.length) {
          //first time listening
          messagesDataBloc!.sort();
        }

        if ((event.docChanges.length != event.docs.length &&
                event.docChanges.isNotEmpty &&
                event.docs.isNotEmpty) ||
            (event.docs.length == event.docChanges.length &&
                event.docChanges.length == 1)) {
          final list = event.docChanges
              .map((e) => Conversation.fromFireStore(e.doc))
              .toList();
          for (var el in list) {
            messagesDataBloc!.addObjectToStream((el));
          }
        }
      }
    });
  }
  //Cette méthode sert d'abonnement aux mises à jour des flux dans ce cas les blocs de messages
  Future<void> listenStreamSubscriptionDoura() async {
    streamSubscriptionDoura =
        messagesDataBlocDoura!.query!.snapshots().listen((event) async {});
  }
  //Cette méthode sert à convertir le document snapshot qui est un document Firestore en un objet "conversation"
  Conversation convertDocumentSnapshotToObject(DocumentSnapshot ds) {
    return ds["firestore-document-key"];
  }

  Future<void> disposeStreamSubscription() async {
    if (streamSubscription != null) await streamSubscription!.cancel();
    if (streamSubscriptionDoura != null) {
      await streamSubscriptionDoura!.cancel();
    }
  }
  
  //Cette méthode initialise les blocs de données pour gérer les conversations d'une "chatroom" à laquelle l'utilisateur connecté participe,
  // récupère les données initiales des conversations
  // et met en place des abonnements pour écouter les mises à jour des données et termine l'initialisation.

  Future<void> inite() async {
    cr = FirebaseFirestore.instance.collection('chatroom').where('users',
        arrayContains: NavigationService.navigatorKey.currentContext!
            .read<UserProvider>()
            .currentUser!
            .id);
   

    messagesDataBloc = DataBloc<Conversation>(
      query: cr!.orderBy('lastMsgSent', descending: true),
      documentSnapshotToT: convertDocumentSnapshotToObject,
      numberToLoadAtATime: 20,
    );

    messagesDataBlocDoura = DataBloc<Conversation>(
      query: cr!,
      documentSnapshotToT: convertDocumentSnapshotToObject,
      numberToLoadAtATime: 20,
    );
    //Affectation des données à partir de Firestore
    await messagesDataBlocDoura!.fetchInitialData();
    await messagesDataBloc!.fetchInitialData();
    //Abonnement aux flux des mises à jour des blocs de données 
    await listenStreamSubscriptionDoura();
    await listenStreamSubscription();
  }


//récupérer un utilisateur à partir de son identifiant
  Future<User?> _getUserToForMessage(String id) async {
    return (await UserService.getUserById(id))!.toUser();
  }

  List<User> cacheUserToMessanger = [];
 //Cette fonction permet de filtrer une liste de conversations en supprimant celles qui ont été supprimées par l'utilisateur et 
 //celles auxquelles l'utilisateur n'est pas associé et renvoie la liste filtrée des conversations valides.
  List<Conversation> sortConversation(List<Conversation>? conv, user) {
    if (conv == null || conv.isEmpty) return [];
    conv.removeWhere((element) => element.deletedBy!.contains(user.id));
    conv.removeWhere(
        (element) => element.users!.contains(user.id.toString()) == false);

    return conv;
  }
  
// Cette méthode récupère les utilisateurs associés à une conversation spécifique, récupère les messages de cette conversation à partir de la base de données
// et les renvoie sous la forme d'une liste contenant les utilisateurs et les messages.
  Future<List<dynamic>> getListMessagesFromConversation(
      Conversation conver) async {
    User? userTo;
    User? userFrom;

    if (NavigationService.navigatorKey.currentContext!
            .read<UserProvider>()
            .currentUser!
            .id ==
        conver.users![0]) {
      if (!cacheUserToMessanger.contains(User(
          id: NavigationService.navigatorKey.currentContext!
              .read<UserProvider>()
              .currentUser!
              .id))) {
        final user = await UserService.getUserById(NavigationService
            .navigatorKey.currentContext!
            .read<UserProvider>()
            .currentUser!
            .id);
        userFrom = user!.toUser();
        cacheUserToMessanger.add(userFrom);
      } else {
        userFrom = cacheUserToMessanger[cacheUserToMessanger.indexOf(User(
            id: NavigationService.navigatorKey.currentContext!
                .read<UserProvider>()
                .currentUser!
                .id))];
      }

      if (!cacheUserToMessanger.contains(User(id: conver.users![1]))) {
        final res = await _getUserToForMessage(conver.users![1]);
        userTo = res;
        cacheUserToMessanger.add(userTo!);
      } else {
        userTo = cacheUserToMessanger[
            cacheUserToMessanger.indexOf(User(id: conver.users![1]))];
      }
    } else {
      if (!cacheUserToMessanger.contains(User(id: conver.users![1]))) {
        userFrom = await _getUserToForMessage(conver.users![1]);

        cacheUserToMessanger.add(userFrom!);
      } else {
        userFrom = cacheUserToMessanger[
            cacheUserToMessanger.indexOf(User(id: conver.users![1]))];
      }

      if (!cacheUserToMessanger.contains(User(id: conver.users![0]))) {
        final res = await _getUserToForMessage(conver.users![0]);
        userTo = res;
        cacheUserToMessanger.add(userTo!);
      } else {
        userTo = cacheUserToMessanger[
            cacheUserToMessanger.indexOf(User(id: conver.users![0]))];
      }
    }

    final x = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(conver.id)
        .collection('messages')
        .orderBy('date', descending: false)
        .get();

    final List<Message> y =
        x.docs.map((list) => Message.fromFireStore(list)).toList();

    return [userFrom, userTo, y];
  }
  //ce code permet de charger plus de message si pas de chargement en cours 
  //alors le chargement commence si un chargement est en cours alors il y a arrêt de chargement
  Future<void> loadMore() async {
    if (_isFetchingMessages == false) {
      _isFetchingMessages = true;
      await messagesDataBloc!.fetchNextSetOfData();
      _isFetchingMessages = false;
    } else {
      return Future.value();
    }
  }
  

  Future<void> deleteConversation(String docid, String userId) async {
    await FirebaseFirestore.instance.collection('chatroom').doc(docid).update({
      "deletedBy": FieldValue.arrayUnion([
        NavigationService.navigatorKey.currentContext!
            .read<UserProvider>()
            .currentUser!
            .id
      ])
    });

  }

  Future<void> loadMoreDoura() async {
    if (_isFetchingMessagesDoura == false) {
      _isFetchingMessagesDoura = true;
      await messagesDataBlocDoura!.fetchNextSetOfData();
      _isFetchingMessagesDoura = false;
    } else {
      return Future.value();
    }
  }
}
