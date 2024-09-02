import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_entreprise.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_influenceur.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs_detail.dart';


import '../../models/user.dart';

class Utilisateur extends StatefulWidget {
  const Utilisateur({Key? key}) : super(key: key);

  @override
  State<Utilisateur> createState() => _UtilisateurState();
}

class _UtilisateurState extends State<Utilisateur> {
  @override
  List<UserModel> users = [];
  

    fetchUser() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in querySnapshot.docs) {
        UserModel user = UserModel.fromMap(doc.data());
        users.add(user);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users $e') ;
      }
      
    
  

    }
   
   initState() {
       fetchUser();
       super.initState();
   }



  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(

      height: 540,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Utilisateurs',
                style: style.text18.copyWith(
                  
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsersScreen()),);
                },
                child: Text(
                  'Voir plus',
                  style: TextStyle(
                    color: red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: appPadding,
          ),
          Expanded(
            child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    child: UtilisateurDetails(user: users[index],),
                    onTap: () {
                      if(users[index].statut=='Influenceur'){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilInfluenceurDetails(influenceur: users[index])),);
                      }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilEntrepriseDetails(entreprise: users[index])),);
                      }
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
