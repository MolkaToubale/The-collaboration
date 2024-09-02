// ignore: file_names

import 'package:email_otp/email_otp.dart';

String? Function(dynamic) validateEmail = (value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer une adresse email';
  }
  if (!RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
      .hasMatch(value)) {
    return 'Adresse email invalide';
  }
  return null;
};

String? Function(dynamic) validatePassword = (value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un mot de passe';
  }
  if (value.length < 8) {
    return 'Le mot de passe doit contenir au moins 8 caractères';
  }
  if (!value.contains(new RegExp(r'[A-Z]'))) {
    return 'Le mot de passe doit contenir au moins une lettre majuscule';
  }
  if (!value.contains(new RegExp(r'[a-z]'))) {
    return 'Le mot de passe doit contenir au moins une lettre minuscule';
  }
  if (!value.contains(new RegExp(r'[0-9]'))) {
    return 'Le mot de passe doit contenir au moins un chiffre';
  }
  if (!value.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Le mot de passe doit contenir au moins un caractère spécial';
  }
  return null;
};

String? Function(dynamic) validateNotEmpty = (value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez remplir ce champs';
  }
  return null;
};


String? Function(dynamic) validateTel= (value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez remplir ce champ';
  }

  String stringValue = value.toString();

  if (stringValue.length != 8) {
    return 'Le numéro doit avoir une longueur de 8 chiffres';
  }

  if (!RegExp(r'^[0-9]+$').hasMatch(stringValue)) {
    return 'Le numéro doit contenir uniquement des chiffres';
  }

  return null;
};

