import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';

import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';

import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/models/user.dart';


import 'analytic_info_card.dart';

class AnalyticCards extends StatefulWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  State<AnalyticCards> createState() => _AnalyticCardsState();
}

class _AnalyticCardsState extends State<AnalyticCards> {
  
  @override
  
  Widget build(BuildContext context) {
  
   

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridView(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridView(),
        desktop: AnalyticInfoCardGridView(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatefulWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridView> createState() => _AnalyticInfoCardGridViewState();
}

class _AnalyticInfoCardGridViewState extends State<AnalyticInfoCardGridView> {
 List<UserModel> users = [];
 List<UserModel> influenceurs = [];
 List<UserModel> entreprises = [];
 List<OffreModel> offres = [];

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

   fetchOffres() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('offres').get();
      for (var doc in querySnapshot.docs) {
        OffreModel offre= OffreModel.fromMap(doc.data());
        offres.add(offre);
    
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
       fetchOffres();
       super.initState();
   }

  @override
  Widget build(BuildContext context) {
    List analyticData = [
  AnalyticInfo(
    title: "Utilisateurs",
    count: users.length,
    svgSrc: "assets/icons/user.svg",
    color: primaryColor,
  ),
  AnalyticInfo(
    title: "Offres",
    count: offres.length,
    svgSrc: "assets/icons/Post.svg",
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
    color: green,
  ),
];

    
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: analyticData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: appPadding,
        mainAxisSpacing: appPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        info: analyticData[index],
      ),
    );
  }
}
