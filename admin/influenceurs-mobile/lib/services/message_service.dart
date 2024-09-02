

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import '../models/message.dart';

class MessageService {
  
  Future addMessage(String conversationId, String messageId, Map<String,dynamic> messageInfoMap) async{
    //Cast de la messageInfoMap
    // Map<dynamic, dynamic> messageInfoMap = {'key': 'value'};
    // Map<String, dynamic> stringKeyMap = messageInfoMap.cast<String, dynamic>();

    return FirebaseFirestore.instance.collection('Conversations')
    .doc(conversationId).collection('Messages').doc(messageId).set(messageInfoMap);
  }

  updateDernierMessageEnvoye(String conversationId,Map<String,dynamic> dernierMessageInfoMap) async{
    //Cast du dernierMessageInfoMap
    // Map<dynamic, dynamic> dernierMessageInfoMap = {'key': 'value'};
    // Map<String, dynamic> stringKeyMap2 = dernierMessageInfoMap.cast<String, dynamic>();
    return FirebaseFirestore.instance
    .collection('Conversations').doc(conversationId).update(dernierMessageInfoMap); 
  }

  createConversation(String conversationId, Map<String,dynamic> conversationInfoMap) async{
    final snapshot=await FirebaseFirestore.instance
    .collection('Conversations').doc(conversationId).get();

    if (snapshot.exists) {
      //La conversation existe déjà
      return true;

    }
    else{
      //La conversation n'existe pas
      //Cast du conversationInfoMap
    // Map<dynamic, dynamic> conversationInfoMap = {'key': 'value'};
    // Map<String, dynamic> stringKeyMap3 = conversationInfoMap.cast<String, dynamic>();
      return FirebaseFirestore.instance.collection('Conversations').doc(conversationId).set(conversationInfoMap);

    }

  }

}