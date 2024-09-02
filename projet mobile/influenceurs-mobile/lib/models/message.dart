// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'package:meta/meta.dart';

// @immutable

// class MessageModel {
//   final String id;
//   final String emetteur;
//   final String message;
//   final DateTime dateDernierMessage;
//   final String photoDeProfil;

  
//   MessageModel({
//     required this.id,
//     required this.emetteur,
//     required this.message,
//     required this.dateDernierMessage,
//     required this.photoDeProfil,
//   });



//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id':id,
//       'emetteur': emetteur,
//       'message': message,
//       'dateDernierMessage': dateDernierMessage.millisecondsSinceEpoch,
//       'photoDeProfil': photoDeProfil,
//     };
//   }

//   factory MessageModel.fromMap(Map<String, dynamic> map) {
//     return MessageModel(
//       id:map['id'] as String,
//       emetteur: map['emetteur'] as String,
//       message: map['message'] as String,
//       dateDernierMessage: DateTime.fromMillisecondsSinceEpoch(map['dateDernierMessage'] as int),
//       photoDeProfil: map['photoDeProfil'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory MessageModel.fromJson(String source) => MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

//   @override
//   String toString() {
//     return 'MessageModel(id: $id ,emetteur: $emetteur, message: $message, dateDernierMessage: $dateDernierMessage, photoDeProfil: $photoDeProfil)';
//   }
// }
