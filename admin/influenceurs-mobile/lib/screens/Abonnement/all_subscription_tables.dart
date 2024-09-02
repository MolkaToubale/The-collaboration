import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/Abonnement/all_subscription_dashbord.dart';
import 'package:responsive_admin_dashboard/screens/Abonnement/modify_subscription.dart';

import 'package:responsive_admin_dashboard/screens/dashbord/dash_board_screen.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../models/user.dart';

class AllSubscriptionTable extends StatefulWidget {
  AllSubscriptionTable({Key? key}) : super(key: key);

  @override
  State<AllSubscriptionTable> createState() => _AllSubscriptionTableState();
}

class _AllSubscriptionTableState extends State<AllSubscriptionTable> {
  String selectedValue = "Tous les utilisateurs";
  List<UserModel> users = [];
  List<UserModel> filteredSubscription = [];

  fetchAbonnement() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('statut',isEqualTo: "Entreprise")
              .get();

       for (var doc in querySnapshot.docs) {
         UserModel user = UserModel.fromMap(doc.data());
         users.add(user);

        setState(() {
          filteredSubscription = users;
        });
       }
    } catch (e) {
      log('erreur affichage users abonnés $e');
    }
  }

  initState() {
    fetchAbonnement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const defaultPadding = 16.0;
    var style = context.watch<ThemeNotifier>();

    return  Container(
        height:1500,
        width: 2500,
         padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: style.bgColor,
         // color: Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Liste abonnement",
                    style: style.title.copyWith(fontSize: 15,color: style.invertedColor),
                  ),
                  DropdownButton(
                    
                    value: selectedValue, 
                    hint: Text("Tous les utilisateurs",style: style.title.copyWith(fontSize: 15,color: style.invertedColor),),
                    items: [
                      DropdownMenuItem(
                        value: "Tous les utilisateurs",
                        child: Text("Tous les utilisateurs"),
                      ),
                      DropdownMenuItem(
                        value: "Mensuel",
                        child: Text("Mensuel"),
                      ),
                      DropdownMenuItem(
                        value: "Trimestriel",
                        child: Text("Trimestriel"),
                      ),
                      DropdownMenuItem(
                        value: "Annuel",
                        child: Text("Annuel"),
                      ),
                      
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                        if (selectedValue == "Tous les utilisateurs") {
                          filteredSubscription = List.from(users);

                        } else if (selectedValue == "Mensuel") {
                          filteredSubscription=users
                              .where((user) => user.abonnement == "MENSUEL")
                              .toList();

                        } else if (selectedValue == "Trimestriel") {
                          filteredSubscription=users
                              .where((user) => user.abonnement == "TRIMESTRIEL")
                              .toList();

                        } else if (selectedValue == "Annuel") {
                          filteredSubscription=users 
                              .where((user) => user.abonnement == "ANNUEL")
                              .toList();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
           Container(
             //color: Colors.green,
             color: style.bgColor,
             width: 2300,
             height: 1000,
              child: DataTable(
                columnSpacing: 20.0,
                columns: [
                  DataColumn(
                    label: Text(
                      "Nom d'utilisateur",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Type d'abonnement",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Date d'inscription",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      " Date de fin abonnement",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Actions",
                      style: TextStyle(color: red),
                    ),
                  ),
                 
                ],
                rows: List.generate(
                  filteredSubscription.length,
                  (index) =>
                      recentFileDataRow(context, filteredSubscription[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentFileDataRow(BuildContext context, UserModel user) {
  var style = context.watch<ThemeNotifier>();
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            ClipOval(
              child: Image.network(
                user.photo,
                height: 30,
                width: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                user.nomPrenom,
                style: TextStyle(color: style.invertedColor),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        user.abonnement==null?Text('Aucun',style: TextStyle(color: style.invertedColor),):
        Text(
        user.abonnement.toString(),
          style: TextStyle(color: style.invertedColor),
        ),
      ),
      DataCell(
          user.abonnement==null?Text('_',style: TextStyle(color: style.invertedColor),):
        Text(
        user.dateInscription.toString(),
          style: TextStyle(color: style.invertedColor),
        ),
      ),
      DataCell(
          user.abonnement==null?Text('_',style: TextStyle(color: style.invertedColor),):Text(
        user.dateFinAbonnement.toString(),
        style: TextStyle(color: style.invertedColor),
      )),
      
      DataCell(
        Row(
          children: [
            GestureDetector(
              onTap: () {
                
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ModifySubscription(user: user)));
                
                
              },
              child: Icon(
                Icons.edit,
                color: primaryColor,
              ),
            ),
            SizedBox(width:20),
             GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Révocation de l'abonnement"),
                content: const Text(
                  "Vous êtes sur le point de supprimer l'abonnement de cet utilisateur , l'utilisateur perdera son abonnement",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      
                   if (user.abonnement!=null) {
                     FirebaseFirestore.instance.collection('users').doc(user.id).update({
  'abonnement': FieldValue.delete(),
  'dateInscription': FieldValue.delete(),
  'dateFinAbonnement': FieldValue.delete(),

})
.then((value) => print("Révocation de l'abonnement avec succés"))
.catchError((error) => print("Erreur lors de la révocation de l'abonnement : $error"));
                      
                      Fluttertoast.showToast(
                          msg: "Révocation de l'abonnement avec succés");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoardScreen()),
                      );
                   }
                   else{
                    Fluttertoast.showToast(
                          msg: "Echec de la révocation, cet utilisateur ne possède aucun abonnement!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllSubscriptionScreen()),
                      );
                   }

                    },
                    child: const Text('Confirmer'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Annuler'),
                  ),
                ],
              ),
            );
          },
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
        ),
          ],
        ),
      ),

     
    ],
  );
}
