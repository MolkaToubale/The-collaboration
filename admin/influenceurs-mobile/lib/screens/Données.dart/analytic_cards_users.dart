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

class AnalyticCardsUsers extends StatefulWidget {
  const AnalyticCardsUsers({Key? key}) : super(key: key);

  @override
  State<AnalyticCardsUsers> createState() => _AnalyticCardsUsersState();
}

class _AnalyticCardsUsersState extends State<AnalyticCardsUsers> {
  
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
 List<UserModel> users = [];
 List<UserModel> influenceurs = [];
 List<UserModel> entreprises = [];



    fetchUsers() async {
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
    fetchInfluenceurs() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').where('statut',isEqualTo: 'Influenceur').get();
      for (var doc in querySnapshot.docs) {
        UserModel influenceur = UserModel.fromMap(doc.data());
        influenceurs.add(influenceur);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users $e') ;
      }
    }

    fetchEntreprises() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').where('statut',isEqualTo: 'Entreprise').get();
      for (var doc in querySnapshot.docs) {
        UserModel entreprise= UserModel.fromMap(doc.data());
        entreprises.add(entreprise);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage users $e') ;
      }
    }

 

   initState() {
       fetchUsers();
       fetchInfluenceurs();
       fetchEntreprises();
       super.initState();
   }

  @override
  Widget build(BuildContext context) {
    String? filterValue;
    List analyticData = [


 AnalyticInfo(
    title: "Utilisateurs actifs",
    count: users.length,
    svgSrc: "assets/icons/denied.svg",
    color: purple,
  ),

  AnalyticInfo(
    title: "Influenceurs",
    count: influenceurs.length,
    svgSrc: "assets/icons/influencer.svg",
    color: orange,
  ),
  
  AnalyticInfo(
    title: "Entreprises",
    count: entreprises.length,
    svgSrc: "assets/icons/entreprise.svg",
    color: cst.green,
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
