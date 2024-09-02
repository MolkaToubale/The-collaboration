import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String utilisateurIdKey = "UTILISATEURKEY";
  static String nomPrenomKey = "NOMPRENOMKEY";
  static String statutKey = "STATUTKEY";
   static String displayNomPrenomKey = "UTILISATEURDISPLAYNOMPRENOMKEY";
  static String utilisateurEmailKey = "UTILISATEUREMAILKEY";
  static String utilisateurPhotoKey = "UTILISATEURPHOTOKEY";

  //save data
  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(nomPrenomKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(utilisateurEmailKey, getUseremail);
  }
  Future<bool> saveUserStatut(String getUserStatut) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(statutKey, getUserStatut);
    // return prefs.setString(nomPrenomKey, getUserStatut);
  }

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(utilisateurIdKey, getUserId);
  }


  Future<bool> saveUserProfileUrl(String getUserProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(utilisateurPhotoKey, getUserProfile);
  }

  // get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(nomPrenomKey);
  }
   Future<String?> getUserStatut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(statutKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(utilisateurEmailKey);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(utilisateurIdKey);
  }

  Future<String?> getUserProfileUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(utilisateurPhotoKey);
  }

}