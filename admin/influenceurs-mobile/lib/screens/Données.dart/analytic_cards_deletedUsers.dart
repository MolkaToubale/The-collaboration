import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart' as cst;
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/models/candidature.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/models/user.dart';

import 'analytic_info_card.dart';

class AnalyticCardsUsersDeleted extends StatefulWidget {
  const AnalyticCardsUsersDeleted({Key? key}) : super(key: key);

  @override
  State<AnalyticCardsUsersDeleted> createState() => _AnalyticCardsUsersDeletedState();
}

class _AnalyticCardsUsersDeletedState extends State<AnalyticCardsUsersDeleted> {
  
  @override
  
  Widget build(BuildContext context) {
   

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridViewUsers(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridViewUsers(),
        desktop: AnalyticInfoCardGridViewUsers(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridViewUsers extends StatefulWidget {
  const AnalyticInfoCardGridViewUsers({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridViewUsers> createState() => _AnalyticInfoCardGridViewUsersState();
}

class _AnalyticInfoCardGridViewUsersState extends State<AnalyticInfoCardGridViewUsers> {

 List<UserModel> usersDeleted = [];
 List<UserModel> entreprisesDeleted = [];
 List<UserModel> influenceursDeleted = [];


   fetchUsersDeleted() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('deleted_users').get();
      for (var doc in querySnapshot.docs) {
        UserModel userDeleted= UserModel.fromMap(doc.data());
        usersDeleted.add(userDeleted);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users deleted $e') ;
      }
    }

    fetchEntrepriseDeleted() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('deleted_users').where('statut', isEqualTo: 'Entreprise').get();
      for (var doc in querySnapshot.docs) {
        UserModel entrepriseDeleted= UserModel.fromMap(doc.data());
        entreprisesDeleted.add(entrepriseDeleted);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users deleted $e') ;
      }
    }
     fetchInfluenceursDeleted() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('deleted_users').where('statut', isEqualTo: 'Influenceur').get();
      for (var doc in querySnapshot.docs) {
        UserModel influenceurDeleted= UserModel.fromMap(doc.data());
        influenceursDeleted.add(influenceurDeleted);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users deleted $e') ;
      }
    }

   initState() {
      
       fetchUsersDeleted();
       fetchEntrepriseDeleted();
       fetchInfluenceursDeleted();
       super.initState();
   }

  @override
  Widget build(BuildContext context) {
    
    List analyticData = [


 AnalyticInfo(
    title: "Comptes Supprimés",
    count: usersDeleted.length,
    svgSrc: "assets/icons/denied.svg",
    color: purple,
  ),

  
   AnalyticInfo(
    title: "Influenceurs Supprimés",
    count: influenceursDeleted.length,
    svgSrc: "assets/icons/influencer.svg",
    color: red,
  ),

   AnalyticInfo(
    title: "Entreprises Supprimés",
    count: entreprisesDeleted.length,
    svgSrc: "assets/icons/entreprise.svg",
    color: red,
  ),
];

    
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: analyticData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: cst.appPadding,
        mainAxisSpacing: cst.appPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        info: analyticData[index],
      ),
    );
  }
}
