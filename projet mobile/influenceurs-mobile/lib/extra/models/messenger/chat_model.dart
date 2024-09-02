import 'dart:convert';

import '../../../models/user.dart';

class Chat {
  int? id;
  UserModel? user1;
  UserModel? user2;
  DateTime? dateCreated;

  Chat({
    this.id,
    this.user1,
    this.user2,
    this.dateCreated,
  });

  Chat copyWith({
    int? id,
    UserModel? user1,
    UserModel? user2,
    DateTime? dateCreated,
  }) {
    return Chat(
      id: id ?? this.id,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1': user1?.id,
      'user2': user2?.id,
      'dateCreated': dateCreated?.millisecondsSinceEpoch,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['_id'],
      user1: UserModel.fromJson(map['user1']),
      user2: UserModel.fromJson(map['user2']),
      dateCreated: DateTime.tryParse(map['dateCreated']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Chat(id: $id, user1: $user1, user2: $user2, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.id == id &&
        other.user1 == user1 &&
        other.user2 == user2 &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^ user1.hashCode ^ user2.hashCode ^ dateCreated.hashCode;
  }
}
