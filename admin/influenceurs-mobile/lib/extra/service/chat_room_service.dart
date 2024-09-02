import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatRoomService {


  // createConversation(String userId, String conversationId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.getString('token');
  //   var tokenuser = prefs.getString('token');
  //   final response = await http.post(
  //     Uri.parse("$baseUrl/api/messages/create-conversation/$userId"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': 'Bearer $tokenuser',
  //       'Accept': 'application/json',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'conversationId': conversationId,
  //     }),
  //   );
  //   log("create conversation");
  //   log(response.body);
  //   final jsonData = jsonDecode(response.body);

  //   log(jsonData.toString());
  // }

//   uploadFile() async {
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.getString('token');

//     var tokenuser = prefs.getString('token');
//     String apiUrl =
//         "$API_PROD/api/posts/$id/update";
//     Map<String, String> headers = {
//       'Content-Type': 'multipart/form-data',
//       'Authorization': 'Bearer $tokenuser',
//     };

//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
//         ..fields.addAll(body)
//         ..headers.addAll(headers)
//         ..files.add(await http.MultipartFile.fromPath('files', filepath.path));
//       var response = await request.send();

//       if (response.statusCode == 201) {
//         return true;
//       } else {
//         return false;
//       }
//   }

  getFile() async {}
}
