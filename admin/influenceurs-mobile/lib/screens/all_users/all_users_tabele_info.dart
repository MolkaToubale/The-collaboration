import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_entreprise.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_influenceur.dart';
import 'package:responsive_admin_dashboard/screens/all_usersDeleted/all_usersDeleted_dashbord.dart';

import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../models/user.dart';

class Allusertableinfo extends StatefulWidget {
  Allusertableinfo({Key? key}) : super(key: key);

  @override
  State<Allusertableinfo> createState() => _AllusertableinfoState();
}

class _AllusertableinfoState extends State<Allusertableinfo> {
  String selectedValue = "Tous les utilisateurs";
  List<UserModel> users = [];
  List<UserModel> deletedusers = [];

  List<UserModel> filteredUsers = [];

  fetchUser() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in querySnapshot.docs) {
        UserModel user = UserModel.fromMap(doc.data());
        users.add(user);

        setState(() {
          filteredUsers = users;
        });
      }
    } catch (e) {
      log('erreur affichage users $e');
    }
  }

  initState() {
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const defaultPadding = 16.0;
    var style = context.watch<ThemeNotifier>();

    return Container(
      height: 1500,
      width: 2500,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: style.bgColor,
        //color: Colors.amber,
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
                    "Liste des utilisateurs",
                    style: style.title.copyWith(fontSize: 15),
                  ),
                  DropdownButton(
                    value: selectedValue, 
                    hint: Text("Tous les utilisateurs"),
                    items: [
                      DropdownMenuItem(
                        value: "Tous les utilisateurs",
                        child: Text("Tous les utilisateurs"),
                      ),
                      DropdownMenuItem(
                        value: "Tous les influenceurs",
                        child: Text("Tous les influenceurs"),
                      ),
                      DropdownMenuItem(
                        value: "Toutes les entreprises",
                        child: Text("Toutes les entreprises"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();

                        if (selectedValue == "Tous les utilisateurs") {
                          filteredUsers = List.from(users);
                        } else if (selectedValue == "Tous les influenceurs") {
                          filteredUsers = users
                              .where((user) => user.statut == "Influenceur")
                              .toList();
                        } else if (selectedValue == "Toutes les entreprises") {
                          filteredUsers = users
                              .where((user) => user.statut == "Entreprise")
                              .toList();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.green,
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
                      "Date de création",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Statut",
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
                  filteredUsers.length,
                  (index) => recentFileDataRow(context, filteredUsers[index]),
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
        Text(
          DateFormat('EEE, dd/MM/yyyy').format(user.creeLe),
          style: TextStyle(color: style.invertedColor),
        ),
      ),
      DataCell(Text(
        user.statut,
        style: TextStyle(color: style.invertedColor),
      )),
      DataCell(
        Row(
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Suppression du compte"),
                    content: const Text(
                      "Vous êtes sur le point de supprimer ce profil, l'utilisateur perdera l'accés à son compte",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          context
                              .read<UserProvider>()
                              .deleteUser(user.id, user.statut);

                          Fluttertoast.showToast(
                              msg: "Suppressionn du Profil avec succés");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllusersdeltedScreen()),
                          );
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
            SizedBox(width: 20,),
             GestureDetector(
          onTap: () {
            if (user.statut == 'Influenceur') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilInfluenceurDetails(influenceur: user)),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilEntrepriseDetails(entreprise: user)),
              );
            }
          },
          child: Icon(
            Icons.remove_red_eye,
            color: primaryColor,
          ),
        ),
          ],
        ),
      ),
      
    ],
  );
}
