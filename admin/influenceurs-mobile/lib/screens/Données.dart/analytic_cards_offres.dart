import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/models/candidature.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/models/user.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';

import 'analytic_info_card.dart';

class AnalyticCardsOffres extends StatefulWidget {
  const AnalyticCardsOffres({Key? key}) : super(key: key);

  @override
  State<AnalyticCardsOffres> createState() => _AnalyticCardsOffresState();
}

class _AnalyticCardsOffresState extends State<AnalyticCardsOffres> {
  
  @override
  
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
   

    Size size = MediaQuery.of(context).size;

    return Container(
      color: style.bgColor.withOpacity(.02),
      child: Responsive(
        mobile: AnalyticInfoCardGridViewOffres(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridViewOffres(),
        desktop: AnalyticInfoCardGridViewOffres(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridViewOffres extends StatefulWidget {
  const AnalyticInfoCardGridViewOffres({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridViewOffres> createState() => _AnalyticInfoCardGridViewOffresState();
}

class _AnalyticInfoCardGridViewOffresState extends State<AnalyticInfoCardGridViewOffres> {
  List<OffreModel> offres = [];
  List<OffreModel> offresEnCours = [];
  List<OffreModel> anciennesOffres = [];


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
       log('erreur affichage offres $e') ;
      }
    }


    

  fetchAnciennesOffres() async {
   QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
  .collection('offres')
  .where('dateFin', isLessThan: DateTime.now().millisecondsSinceEpoch)
  .get();
    for (var data in qn.docs) {
      anciennesOffres.add(OffreModel.fromMap(data.data()));
     
    }

    setState(() {});
  }

  fetchOffresEnCours() async {
   QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
    .collection('offres')
    .where('dateFin', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
    .get();
    for (var data in qn.docs) {
      offresEnCours.add(OffreModel.fromMap(data.data()));
    }

    setState(() {});
  }




   initState() {
       
       fetchOffres();
       
       fetchAnciennesOffres();
       fetchOffresEnCours();



       super.initState();
   }

  @override
  Widget build(BuildContext context) {
     var style = context.watch<ThemeNotifier>();

    List analyticData = [
  AnalyticInfo(
    backgroundColor: style.bgColor,
    title: "Offres",
    count: offres.length,
    svgSrc: "assets/icons/Post.svg",
    color: primaryColor,
  ),
  AnalyticInfo(
    backgroundColor: style.bgColor,
    title: "Anciennes Offres",
    count: anciennesOffres.length,
    svgSrc: "assets/icons/anciennes.svg",
    color: purple,
  ),
  AnalyticInfo(
    backgroundColor: style.bgColor,
    title: "Offres En Cours",
    count: offresEnCours.length,
    svgSrc: "assets/icons/enattente.svg",
    color: orange,
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
