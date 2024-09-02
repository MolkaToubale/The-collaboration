import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  counterText: '',
  contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
  hintText: 'Tapez votre message ici...',
  hintStyle: TextStyle(fontFamily: "Poppins", fontSize: 15, color: Colors.grey),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration();
