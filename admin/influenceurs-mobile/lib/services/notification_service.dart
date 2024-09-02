import'package:firebase_messaging/firebase_messaging.dart';



class NotificationService{

   static void initialize(){
     
     
     FirebaseMessaging.onMessage.listen((event){
     print('A new onMessage event was published !');
     });

     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("A new onMessageOpenedApp event was published");
      });

   }


   static Future<String?> getToken()async{
     return FirebaseMessaging.instance.getToken(vapidKey:"BFYSxyEzKsgUzeTA9iKrmMfMBNCiG7EssIAqS8ntQd6TwBr4IG9hNTtw-Erq--sW5USEVsRLaUr0lH9x1QkJm0Y");
   }

}
