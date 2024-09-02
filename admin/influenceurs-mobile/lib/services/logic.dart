import 'package:crossplat_objectid/crossplat_objectid.dart';


String generateId(){
  ObjectId id = ObjectId();
  return id.toHexString();
}
