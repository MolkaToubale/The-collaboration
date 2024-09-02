import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Messenger/data_bloc.dart';
import '../models/messenger/message_model.dart';
import '../models/messenger/user/user.dart';

class ChatRoomProvider extends ChangeNotifier {
  String? currentRoomId = "";
  String? currentUserId;
  bool? showMsgDatee = false;

  DataBloc<Message>? messagesDataBloc;
  Query? cr;
  bool? _isFetchingMessages = false;

  late User? userfrom;
  late User? userto;

  bool? newI = true;

  StreamSubscription<QuerySnapshot<Object?>>? streamSubscription;

  void showMsgDate() {
    showMsgDatee = !showMsgDatee!;
    notifyListeners();
  }

  Message convertDocumentSnapshotToObject(DocumentSnapshot ds) {
    return ds["firestore-document-key"];
  }

  Future<void> disposeStreamSubscription() async {
    newI = true;
    if (streamSubscription != null) {
      await streamSubscription!.cancel();
    }
  }

  Future<void> listenStreamSubscription() async {
    streamSubscription =
        messagesDataBloc!.query!.snapshots().listen((event) async {
      if (event.docChanges.isNotEmpty) {
        if (event.docChanges.length == event.docs.length) {
          await _seenByConfiguration(
              event.docs.map((e) => Message.fromFireStore(e)).toList());
        }

        if ((event.docChanges.length != event.docs.length &&
                event.docChanges.isNotEmpty &&
                event.docs.isNotEmpty) ||
            (event.docs.length == event.docChanges.length &&
                event.docChanges.length == 1)) {
          final list = event.docChanges
              .map((e) => Message.fromFireStore(e.doc))
              .toList();
          //list.sort((b, a) => a.date!.toLocal().compareTo(b.date!.toLocal()));
          for (var el in list) {
            messagesDataBloc!.addObjectToStream((el));
          }
          _seenByConfiguration2(event.docChanges);
        }
      }
    });
  }

  Future<void> inite() async {
    cr = FirebaseFirestore.instance
        .collection("chatroom")
        .doc(currentRoomId)
        .collection("messages");

    messagesDataBloc = DataBloc<Message>(
      query: cr!.orderBy('date', descending: true),
      documentSnapshotToT: convertDocumentSnapshotToObject,
      numberToLoadAtATime: 20,
    );

    await messagesDataBloc!.fetchInitialData();

    await listenStreamSubscription();
    notifyListeners();
  }

  Future _seenByConfiguration(List<Message> messages) async {
    for (var message in messages) {
      //messages.sort((a, b) => a.date!.compareTo(b.date!));

      if (message.from.toString() != currentUserId.toString() &&
          !message.seenBy!.contains(currentUserId.toString())) {
        await FirebaseFirestore.instance
            .collection("chatroom")
            .doc(currentRoomId)
            .collection("messages")
            .doc(message.id)
            .update({
          "seenBy": FieldValue.arrayUnion([currentUserId])
        });
      }
    }
    /*await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(currentRoomId)
        .update({'test': DateTime.now()});*/
  }

  Future _seenByConfiguration2(List<dynamic> messages) async {
    for (var message in messages) {
      //messages.sort((a, b) => a['date'].compareTo(b['date']));
      Message m = Message.fromFireStore(message.doc);

      if (m.from.toString() != currentUserId.toString()) {
        await FirebaseFirestore.instance
            .collection("chatroom")
            .doc(currentRoomId)
            .collection("messages")
            .doc(m.id)
            .update({
          "seenBy": FieldValue.arrayUnion([currentUserId])
        });
      }
    }
  }

  Future<void> loadMore() async {
    if (_isFetchingMessages == false) {
      _isFetchingMessages = true;
      await messagesDataBloc!.fetchNextSetOfData();
      _isFetchingMessages = false;
    } else {
      return Future.value();
    }
  }

  void setCurrentRoomId(User a, User b) {
    userfrom = a;
    userto = b;
    currentRoomId = _generateUniqueRoomChatId(userfrom!.id, userto!.id);
    currentUserId = userfrom!.id;
    notifyListeners();
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
}
