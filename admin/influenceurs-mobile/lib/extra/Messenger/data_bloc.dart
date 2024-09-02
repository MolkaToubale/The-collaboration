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

  Future fetchInitialData() async {
    try {
      //fetch documents from firestore
      List<DocumentSnapshot> documents =
          (await query!.limit(numberToLoadAtATime!).get()).docs;

      //TODO: See what happens when no documents exists
      try {
        if (documents.isEmpty) {
          blocController!.sink.addError("No Data Available");
        } else {
          lastFetchedSnapshot = documents[documents.length - 1];
        }
      } catch (_) {}

      //Convert documentSnapshots to custom object
      for (var documentSnapshot in documents) {
        objectsList!.add(Message.fromFireStore(documentSnapshot));
        blocController!.sink.add(objectsList!);
      }
    } on SocketException {
      blocController!.sink
          .addError(const SocketException("No Internet Connection"));
    } catch (e) {
      blocController!.sink.addError(e);
    }
  }

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
          .addError(const SocketException("No Internet Connection"));
    } catch (e) {
      blocController!.sink.addError(e);
    }
  }

  addObjectToStream(Message object) {
    /*objectsList!.insert(0, object);
    blocController!.sink.add(objectsList!);*/
    int index;

    if (objectsList!.where((element) => element.id == object.id).isEmpty) {
      objectsList!.insert(0, object);
      //objectsList!.sort((b, a) => a.date!.compareTo(b.date!));
      blocController!.sink.add(objectsList!);
    } else {
      index = objectsList!.indexWhere((element) =>
          element.seenBy!.length != object.seenBy!.length &&
          element.id == object.id);
      if (index != -1) {
        objectsList!.remove(object);
        objectsList!.insert(index, object);
        blocController!.sink.add(objectsList!);
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
/*
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
    this.numberToLoadAtATime = 20,
    this.numberToLoadFromNextTime = 10,
  }) {
    objectsList = [];
    blocController = BehaviorSubject<List<Message>>();
    showIndicatorController = BehaviorSubject<bool>();
  }

  Stream get getShowIndicatorStream => showIndicatorController!.stream;
  Stream<List<Message>> get dataStream => blocController!.stream;

  Future fetchInitialData() async {
    try {
      //fetch documents from firestore
      List<DocumentSnapshot> documents =
          (await query!.limit(numberToLoadAtATime!).get()).docs;

      //TODO: See what happens when no documents exists
      try {
        if (documents.length == 0) {
          blocController!.sink.addError("No Data Available");
        } else {
          lastFetchedSnapshot = documents[documents.length - 1];
        }
      } catch (_) {}

      //Convert documentSnapshots to custom object
      documents.forEach((documentSnapshot) {
        
        objectsList!.add((Message.fromFireStore(documentSnapshot)));
        blocController!.sink.add(objectsList!);
      });
      //print('fahd ?');
    } on SocketException {
      blocController!.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      blocController!.sink.addError(e);
    }
  }

  Future<void> fetchNextSetOfData() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = (await query!
              .startAfterDocument(lastFetchedSnapshot!)
              .limit(numberToLoadFromNextTime!)
              .get())
          .docs;
      if (newDocumentList.length != 0) {
        lastFetchedSnapshot = newDocumentList[newDocumentList.length - 1];
        newDocumentList.forEach((documentSnapshot) {
          objectsList!.add((Message.fromFireStore(documentSnapshot)));
        });
        blocController!.sink.add(objectsList!);
      }
    } on SocketException {
      blocController!.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
     
      blocController!.sink.addError(e);
    }
  }

  addObjectToStream(DocumentSnapshot object) {
    //print('hey man');
    //print(objectsList!.contains(object));

    if (objectsList!.where((element) => element.id == object.id).isEmpty) {
      objectsList!.insert(0, Message.fromFireStore(object));
      blocController!.sink.add(objectsList!);
    }
  }

  removeObjectFromStream(T object) {
    objectsList!.remove(object);
    blocController!.sink.add(objectsList!);
  }

  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController!.sink.add(value);
  }

  void dispose() {
    blocController!.close();
    showIndicatorController!.close();
  }

  updateObjectToStream(String id) {
    objectsList!.where((element) => element.id == id).first;
  }
}
*/
