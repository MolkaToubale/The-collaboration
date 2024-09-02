import 'dart:convert';

import 'package:projet/extra/models/messenger/user/user.dart';


class RoomChat {
  String? id;
  dynamic createdAt;
  List<dynamic>? users;

  RoomChat({this.id, this.createdAt, this.users});

  RoomChat copyWith({String? id, DateTime? createdAt, List<User>? users}) {
    return RoomChat(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        users: users ?? this.users);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'users': users != null ? List<dynamic>.from(users!.map((x) => x)) : null,
    };
  }

  factory RoomChat.fromMap(Map<String, dynamic> map) {
    return RoomChat(
      id: map['_id'],
      createdAt:
          map["createdAt"] == null ? null : DateTime.parse(map["createdAt"]),
      users: map["users"].length > 0
          ? map["users"][0] is Map
              ? List<User>.from(map["users"].map((x) => User.fromJson(x)))
              : map["users"]
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory RoomChat.fromJson(String source) =>
      RoomChat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RoomChat(id: $id, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoomChat && other.id == id && other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ createdAt.hashCode;
  }
}
