import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/messenger/message_model.dart';

class DataBloc<T> {
  T? dataType;
  Query? query;
  int? numberToLoadAtATime;
  int? numberToLoadFromNextTime;
  Function? documentSnapshotToT;

  bool? showIndicator = false;
  DocumentSnapshot? lastFetchedSnapshot;
  List<Message>? objectsList;
  BehaviorSubject<List<Message>>? blocController;
  BehaviorSubject<bool>? showIndicatorController;

  DataBloc({
    @required this.query,
    @required this.documentSnapshotToT,
    this.numberToLoadAtATime = 10,
    this.numberToLoadFromNextTime = 10,
  }) {
    objectsList = [];
    blocController = BehaviorSubject<List<Message>>();
    showIndicatorController = BehaviorSubject<bool>();
  }

  Stream get getShowIndicatorStream => showIndicatorController!.stream;

  Stream<List<Message>> get dataStream => blocController!.stream;
   

   //Cette méthode sert à initialiser les blocs de données à partir de firestore et d'indiquer les erreurs s'il y'en a
  Future fetchInitialData() async {
    try {
      //fetch documents from firestore
      List<DocumentSnapshot> documents =
          (await query!.limit(numberToLoadAtATime!).get()).docs;

      
      try {
        if (documents.isEmpty) {
          blocController!.sink.addError("Aucune donnée disponnible");
        } else {
          lastFetchedSnapshot = documents[documents.length - 1];
        }
      } catch (_) {}

      //Convert documentSnapshots to conversation object
      for (var documentSnapshot in documents) {
        objectsList!.add(Message.fromFireStore(documentSnapshot));
        blocController!.sink.add(objectsList!);
      }
    } on SocketException {
      blocController!.sink
          .addError(const SocketException("Vous n'êtes pas connecté à Internet."));
    } catch (e) {
      blocController!.sink.addError(e);
    }
  }
   //Lors de LoadMore() ce code affecte un nouveau bloc de messages
  //Cette méthode sert à initialiser les blocs de données suivants à partir de firestore et d'indiquer les erreurs s'il y'en a
  Future<void> fetchNextSetOfData() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = (await query!
              .startAfterDocument(lastFetchedSnapshot!)
              .limit(numberToLoadFromNextTime!)
              .get())
          .docs;
      if (newDocumentList.isNotEmpty) {
        lastFetchedSnapshot = newDocumentList[newDocumentList.length - 1];
        for (var documentSnapshot in newDocumentList) {
          objectsList!.add((Message.fromFireStore(documentSnapshot)));
        }
        blocController!.sink.add(objectsList!);
      }
    } on SocketException {
      blocController!.sink
          .addError(const SocketException("Vous n'êtes pas connecté à Internet."));
    } catch (e) {
      blocController!.sink.addError(e);
    }
  }

//Cette fonction gère l'ajout d'un nouvel objet Message dans une liste d'objets ou la mise à jour d'un objet existant dans la liste.

  addObjectToStream(Message object) {
    int index;

    if (objectsList!.where((element) => element.id == object.id).isEmpty) {
      objectsList!.insert(0, object); //Insérer l'objet en haut de la liste si il est inexistant
      blocController!.sink.add(objectsList!);
    } else {
      index = objectsList!.indexWhere((element) =>
          element.seenBy!.length != object.seenBy!.length &&
          element.id == object.id);
      if (index != -1) {//L'objet est existant
        objectsList!.remove(object);//supprimer cet objet de la liste
        objectsList!.insert(index, object);//ajouter le nouvel objet mis à jour dans la liste
        blocController!.sink.add(objectsList!); //ajouter la liste d'objet au blocController
      }
    }
  }

  removeObjectFromStream(T object) {
    objectsList!.remove(object);
    objectsList!.sort((b, a) => a.date!.compareTo(b.date!));
    blocController!.sink.add(objectsList!);
  }

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController!.sink.add(value);
  }

  updateObjectToStream(Message message, String uid) {
    int index = objectsList!.indexWhere((element) => element.id == message.id);

    if (index != -1 && !objectsList![index].seenBy!.contains(uid)) {
      Message m = Message(
          id: objectsList![index].id,
          from: objectsList![index].from,
          seenBy: objectsList![index].seenBy,
          date: objectsList![index].date,
          msg: objectsList![index].msg,
          msgType: objectsList![index].msgType);

      m.seenBy!.add(uid);

      objectsList!.remove(objectsList![index]);

      objectsList!.sort((b, a) => a.date!.compareTo(b.date!));
      blocController!.sink.add(objectsList!);
    }
  }

  void dispose() {
    blocController!.close();
    showIndicatorController!.close();
  }
}
