import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/logic_service.dart';

class Message {
  String? id;
  String? from;
  String? msg;
  String? msgType;
  DateTime? date;
  List<String>? seenBy;

  Message({this.id, this.from, this.msg, this.msgType, this.seenBy, this.date});

  factory Message.fromMap(Map data) {
    return Message(
        id: data['id'] ?? '',
        from: data['from'] ?? '',
        date: data['date'].toDate() ?? '',
        msg: data['msg'],
        msgType: data['msgType'] ?? '',
        seenBy: data['seenBy'] ?? []);
  }

  factory Message.fromFireStore(DocumentSnapshot doc) {
    return Message(
        id: doc.id,
        from: doc['from'].toString(),
        date: doc['date'].toDate() ?? '',
        msg: doc['msg'],
        msgType: doc['msgType'],
        seenBy: (doc['seenBy'] as List<dynamic>).cast<String>());
  }

  @override
  String toString() {
    return 'Message(id: $id, msg: $msg, msgType: $msgType, from: $from, date: $date, seenBy: $seenBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id && other.msgType == msgType;
  }

  @override
  int get hashCode {
    return id.hashCode ^ msgType.hashCode;
  }
}
