import 'package:cloud_firestore/cloud_firestore.dart';

import 'message_model.dart';

class Conversation {
  String? id;
  DateTime? lastMsgSent;
  DateTime? createdAt;
  String? lastMsgDocumentRefId;
  List<String>? users;
  List<String>? deletedBy;
  Stream<List<Message>?>? messagesList;
  DateTime? test;

  Conversation(
      {this.id,
      this.lastMsgSent,
      this.createdAt,
      this.lastMsgDocumentRefId,
      this.users,
      this.deletedBy,
      this.messagesList});

  factory Conversation.fromMap(Map data) {
    return Conversation(
        id: data['id'] ?? '',
        lastMsgSent: data['lastMsgSent'].toDate() ?? '',
        createdAt: data['createdAt'].toDate() ?? '',
        lastMsgDocumentRefId: data['lastMsgDocumentRefId'] ?? '',
        deletedBy: data['deletedBy'] ?? [],
        users: data['users'] ?? []);
  }

  factory Conversation.fromFireStore(DocumentSnapshot doc) {
    return Conversation(
      id: doc.id,
      lastMsgSent: doc['lastMsgSent'].toDate() ?? '',
      createdAt: doc['createdAt'].toDate() ?? '',
      lastMsgDocumentRefId: doc['lastMsgDocumentRefId'] ?? '',
      users: (doc['users'] as List<dynamic>).cast<String>(),
      deletedBy: (doc['deletedBy'] as List<dynamic>).cast<String>(),
      messagesList: FirebaseFirestore.instance
          .collection('chatroom')
          .doc(doc.id)
          .collection('messages')
          .snapshots()
          .map((list) =>
              list.docs.map((doc) => Message.fromFireStore(doc)).toList()),
    );
  }



  @override
  String toString() {
    return 'Conversation(id: $id, lastMsgSent: $lastMsgSent, createdAt: $createdAt, lastMsgDocumentRefId: $lastMsgDocumentRefId, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation &&
        other.id == id &&
        other.lastMsgDocumentRefId == lastMsgDocumentRefId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ lastMsgDocumentRefId.hashCode;
  }
}
