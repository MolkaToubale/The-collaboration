// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class OffreModel {
  final String id;
  String libelle;
  String idEntreprise;
  String nomEntreprise;
  String description;
  final DateTime dateFin;
  final DateTime dateDebut;
  String affiche;
  List<String> categories;
  OffreModel(
      {required this.id,
      required this.libelle,
      required this.idEntreprise,
      required this.nomEntreprise,
      required this.description,
      required this.dateFin,
      required this.dateDebut,
      required this.affiche,
      required this.categories});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'libelle': libelle,
      'idEntreprise': idEntreprise,
      'nomEntreprise': nomEntreprise,
      'description': description,
      'dateFin': dateFin.millisecondsSinceEpoch,
      'dateDebut': dateDebut.millisecondsSinceEpoch,
      'affiche': affiche,
      'categories': categories
    };
  }

  factory OffreModel.fromMap(Map<String, dynamic> map) {
    return OffreModel(
      id: map['id'] as String,
      libelle: map['libelle'] as String,
      idEntreprise: map['idEntreprise'] as String,
      nomEntreprise: map['nomEntreprise'] as String,
      description: map['description'] as String,
      dateFin: DateTime.fromMillisecondsSinceEpoch(map['dateFin'] is Timestamp
          ? (map['dateFin'] as Timestamp).millisecondsSinceEpoch
          : map['dateFin']),
      dateDebut: DateTime.fromMillisecondsSinceEpoch(map['dateDebut'] is Timestamp
          ? (map['dateDebut'] as Timestamp).millisecondsSinceEpoch
          : map['dateDebut']),
      affiche: map['affiche'] as String,
      categories: List<String>.from(
          (map['categories'] as List<dynamic>).map((e) => e.toString())),
    );
  }

  String toJson() => json.encode(toMap());

  factory OffreModel.fromJson(String source) =>
      OffreModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OffreModel(id: $id,libelle: $libelle, idEntreprise: $idEntreprise, nomEntreprise:$nomEntreprise, description: $description, dateFin: $dateFin, dateDebut: $dateDebut, affiche: $affiche,categories:$categories)';
  }
}
