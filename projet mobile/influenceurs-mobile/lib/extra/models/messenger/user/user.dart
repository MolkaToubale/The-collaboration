// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';


import '../../../service/logic_service.dart';

class User {
  String? id;
  String? name;
  String? image;
  String? token;
  DateTime? lastLoginDate;
  User({
    this.id,
    this.name,
    this.image,
    this.token,
    this.lastLoginDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name ?? "",
      'image': image ?? "",
      'token': token,
      'lastLoginDate': lastLoginDate?.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      name: map['name'] != null ?map['name'] as String : null,
      image:
          map['image'] != null ? map['image'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      lastLoginDate: map['lastLoginDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastLoginDate'] as int)
          : null,
     
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        token.hashCode ^
        lastLoginDate.hashCode;
  }

  User toUser() {
    return User(
      id: id.toString(),
      image: image ?? "",
      name: name ?? "",
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, image: $image, token: $token, lastLoginDate: $lastLoginDate)';
  }
}
