// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AbonnementModel {
  final String titre;
  final String prix;
  final String description;
  
  AbonnementModel({
    required this.titre,
    required this.prix,
    required this.description,
  });

 
Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'titre': titre,
      'prix': prix,
      'description': description,
      
    };
  }

  factory AbonnementModel.fromMap(Map<String, dynamic> map) {
   
    return AbonnementModel(
      titre: map['titre'] as String,
      prix: map['prix'] as String ,
      description: map['description'] as String,
     
    );
  }

  String toJson() => json.encode(toMap());

  factory AbonnementModel.fromJson(String source) =>
      AbonnementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  

  @override
  String toString() {
    return 'AbonnementModel(titre: $titre, prix: $prix, description: $description)';
  }
}

