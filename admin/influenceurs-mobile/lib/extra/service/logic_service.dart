import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'dart:math';

String generateId() {
  ObjectId id1 = ObjectId();
  return id1.toHexString();
}

String generateId2(){
  ObjectId id = ObjectId();
  return id.toHexString();
}


int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

class Scrypt {
  static String crypt(String data) {
    int key = (data.length / 2).round();
    String s = "";
    for (int i = 0; i < data.length; i++) {
      s += String.fromCharCode(data.codeUnitAt(i) * key);
    }
    return s;
  }

  static String decrypt(String data) {
    int key = (data.length / 2).round();
    String s = "";
    for (int i = 0; i < data.length; i++) {
      s += String.fromCharCode(data.codeUnitAt(i) ~/ key);
    }
    return s;
  }

  static String chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  static String generatePassword(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => chars.codeUnitAt(Random().nextInt(chars.length))));
}
