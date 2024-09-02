import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_admin_dashboard/models/admin.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/dash_board_screen.dart';
import 'package:responsive_admin_dashboard/screens/login-screen.dart';




class AdminProvider with ChangeNotifier {
  AdminModel? currentAdmin;

   Future<void> signIn(
       BuildContext context, String emailOrName, String password) async {
     try {
      // Recherche d'un utilisateur correspondant à l'email
       final emailQuery = FirebaseFirestore.instance
           .collection('Administrateurs')
           .where('email', isEqualTo: emailOrName)
           .limit(1);
       final emailSnapshot = await emailQuery.get();

       // Si aucun utilisateur n'a été trouvé pour l'email, recherche d'un utilisateur correspondant au nom et prénom
       if (emailSnapshot.docs.isEmpty) {
         final fullNameQuery = FirebaseFirestore.instance
             .collection('Administrateurs')
             .where('nomPrenom', isEqualTo: emailOrName)
             .limit(1);
         final fullNameSnapshot = await fullNameQuery.get();

         if (fullNameSnapshot.docs.isEmpty) {
           // Si aucun utilisateur n'a été trouvé pour l'email ou le nom et prénom, afficher un message d'erreur
           // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Erreur d'authentification"),
              content: const Text(
                "Impossible de se connecter avec les informations d'identification fournies.",
              ),
               actions: [
                 TextButton(
                   onPressed: () => Navigator.pop(context),
                   child: const Text('OK'),
                 ),
               ],
             ),
           );
           return;
         } else {
           // Si un utilisateur correspond au nom et prénom, utiliser cet utilisateur
           currentAdmin = AdminModel.fromMap(fullNameSnapshot.docs.first.data());
           log(currentAdmin.toString());
           notifyListeners();
     
     }
     } else {
         log(currentAdmin.toString());
         currentAdmin = AdminModel.fromMap(emailSnapshot.docs.first.data());
         startUserListen(currentAdmin!.id);
         notifyListeners();
  
        
       }

       // Vérifier que le mot de passe correspond à celui de l'utilisateur
       if (currentAdmin?.password == password) {
     log(currentAdmin.toString());
        // startUserListen(currentAdmin!.id);
         
           Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(
                 builder: (context) => DashBoardScreen()),
             (route) => false,
           );
        
       } else {
         // Si le mot de passe ne correspond pas, afficher un message d'erreur
         showDialog(
           context: context,
           builder: (context) => AlertDialog(
             title: const Text("Erreur d'authentification"),
             content: const Text(
               "Impossible de se connecter avec les informations d'identification fournies.",
             ),
             actions: [
               TextButton(
                 onPressed: () => Navigator.pop(context),
                 child: const Text('OK'),
               ),
             ],
           ),
         );
       }
     } catch (e) {
       print('$e');
     }
   }

  // //******Méthode de déconnexion***************//
  void signOut(BuildContext context) {
    // Réinitialiser l'utilisateur actuel
    currentAdmin = null;
    removeData();
   // stopUserListen();

     // Naviguer vers la page de connexion
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (context) => Login_screen()),
       (route) => false,
     );
   }

   Future<void> removeData() async {
     // await UserService.removeFcm(currentAdmin!);
    // removeNotificationStream();
     //stopUserListen();
     currentAdmin = null;
    
   }

  

   Future<bool> updateInfo(Map<String, dynamic> updatedInfo) async {
     try {
       await FirebaseFirestore.instance
           .collection('Administrateurs')
           .doc('WXUPs8D0ccgjTJfIM0FS')
           .update(updatedInfo);
      
       Fluttertoast.showToast(msg: "Modification avec succés");
       return true;
     } on Exception catch (e) {
       log("Erreur lors de la modification : $e");
       Fluttertoast.showToast(msg: "Erreur de modification");
       return false;
     }
   }

   Stream<QuerySnapshot<Map<String, dynamic>>>? userStream;

   startUserListen(String userId) {
     if (userStream != null) return;
     userStream =
         FirebaseFirestore.instance.collection('Administrateurs').where("id", isEqualTo: userId).snapshots();
     userStream?.listen((event) {}).onData((data) async {
       // for (var d in data.docChanges) {
       //   log(d.doc.data().toString());
       // }
       currentAdmin = AdminModel.fromMap(data.docChanges.first.doc.data()!);
       log("Admin mis à jour");
       notifyListeners();
     });
   }

  stopUserListen() {
    if (userStream == null) return;
    userStream?.listen((event) {}).cancel();
    userStream = null;
  }


}
