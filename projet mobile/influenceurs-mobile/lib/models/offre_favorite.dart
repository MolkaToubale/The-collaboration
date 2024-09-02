import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class OffreFavoriteModel {
      final String offreId;
     String description;
     String nomEntreprise;
     String idEntreprise;
     String userId;
    
  OffreFavoriteModel({
    required this.offreId,
    required this.description,
    required this.nomEntreprise,
    required this.idEntreprise,
    required this.userId,
    
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'offreId': offreId,
      'description': description,
      'nomEntreprise': nomEntreprise,
      'idEntreprise': idEntreprise,
      'userId': userId,
      
    };
  }

  factory OffreFavoriteModel.fromMap(Map<String, dynamic> map) {
    return OffreFavoriteModel(
      offreId: map['offreId'] as String,
      description: map['description'] as String,
      nomEntreprise: map['nomEntreprise'] as String,
      idEntreprise: map['idEntreprise'] as String,
      userId: map['userId'] as String,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory OffreFavoriteModel.fromJson(String source) => OffreFavoriteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OffreFavorite(offreId: $offreId, description: $description, nomEntreprise: $nomEntreprise, idEntreprise: $idEntreprise, userId: $userId)';
  }
}
