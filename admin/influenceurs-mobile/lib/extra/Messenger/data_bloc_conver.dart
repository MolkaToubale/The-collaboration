import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../models/messenger/conversation_model.dart';

class DataBloc<T> {
  T? dataType;
  Query? query;
  int? numberToLoadAtATime;
  int? numberToLoadFromNextTime;
  Function? documentSnapshotToT;

  bool? showIndicator = false;
  DocumentSnapshot? lastFetchedSnapshot;
  List<Conversation>? objectsList;
  BehaviorSubject<List<Conversation>>? blocController;
  BehaviorSubject<bool>? showIndicatorController;

  DataBloc({
    @required this.query,
    @required this.documentSnapshotToT,
    this.numberToLoadAtATime = 10,
    this.numberToLoadFromNextTime = 10,
  }) {
    objectsList = [];
    blocController = BehaviorSubject<List<Conversation>>();
    showIndicatorController = BehaviorSubject<bool>();
  }

  Stream get getShowIndicatorStream => showIndicatorController!.stream;

  Stream<List<Conversation>> get dataStream => blocController!.stream;

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
        objectsList!.add(Conversation.fromFireStore(documentSnapshot));
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
          objectsList!.add((Conversation.fromFireStore(documentSnapshot)));
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

  addObjectToStream(Conversation object) {
    /*objectsList!.insert(0, object);
    blocController!.sink.add(objectsList!);*/
    int index;

    if (objectsList!.where((element) => element.id == object.id).isEmpty) {
      objectsList!.insert(0, object);
      objectsList!.sort((b, a) => a.lastMsgSent!.compareTo(b.lastMsgSent!));
      blocController!.sink.add(objectsList!);
    } else {
      index = objectsList!.indexWhere((element) => element.id == object.id);
      if (index != -1) {
        objectsList!.removeAt(index);
        objectsList!.insert(index, object);
        objectsList!.sort((b, a) => a.lastMsgSent!.compareTo(b.lastMsgSent!));
        blocController!.sink.add(objectsList!);
      }
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

  sort() {
    objectsList!.sort(
        (b, a) => a.lastMsgSent!.toUtc().compareTo(b.lastMsgSent!.toUtc()));
    blocController!.sink.add(objectsList!);
  }
}
