import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/models/candidature.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/models/user.dart';

import 'analytic_info_card.dart';


class AnalyticCardsCandidatures extends StatefulWidget {
  const AnalyticCardsCandidatures({Key? key}) : super(key: key);

  @override
  State<AnalyticCardsCandidatures> createState() => _AnalyticCardsCandidaturesState();
}

class _AnalyticCardsCandidaturesState extends State<AnalyticCardsCandidatures> {
  
  @override
  
  Widget build(BuildContext context) {
   

    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridViewCandidatures(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridViewCandidatures(),
        desktop: AnalyticInfoCardGridViewCandidatures(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridViewCandidatures extends StatefulWidget {
  const AnalyticInfoCardGridViewCandidatures({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridViewCandidatures> createState() => _AnalyticInfoCardGridViewCandidaturesState();
}

class _AnalyticInfoCardGridViewCandidaturesState extends State<AnalyticInfoCardGridViewCandidatures> {
 List<CandidatureModel> candidatures = [];
 List<CandidatureModel> candidaturesAcceptees = [];
 List<CandidatureModel> candidaturesEnAttentes = [];
 List<CandidatureModel> candidaturesDeclinees = [];
 



    fetchCandidatures() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Candidatures').get();
      for (var doc in querySnapshot.docs) {
        CandidatureModel cand = CandidatureModel.fromMap(doc.data());
        candidatures.add(cand);
    
        setState(() {});
      } 
      } catch (e) {
       log('erreur affichage candidatures $e') ;
      }
    }


    fetchCandidaturesAcceptees() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('reponse',isEqualTo:'Acceptee')
        .get();

    for (var data in qn.docs) {
      candidaturesAcceptees.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }

  fetchCandidaturesEnAttente() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('reponse',isEqualTo:'En attente')
        .get();

    for (var data in qn.docs) {
      candidaturesEnAttentes.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }

    fetchCandidaturesDeclinees() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('reponse',isEqualTo:'Declinee')
        .get();

    for (var data in qn.docs) {
      candidaturesDeclinees.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }
    

   initState() {
       fetchCandidatures();
       fetchCandidaturesAcceptees();
       fetchCandidaturesDeclinees();
       fetchCandidaturesEnAttente();
       super.initState();
   }

  @override
  Widget build(BuildContext context) {
    List analyticData = [
  AnalyticInfo(
    title: "Candidatures",
    count: candidatures.length,
    svgSrc: "assets/icons/cand.svg",
    color: primaryColor,
  ),
  AnalyticInfo(
    title: "Candidatures Acceptées",
    count: candidaturesAcceptees.length,
    svgSrc: "assets/icons/accepted.svg",
    color: purple,
  ),
  AnalyticInfo(
    title: "Candidatures Déclinées",
    count: candidaturesDeclinees.length,
    svgSrc: "assets/icons/denied.svg",
    color: orange,
  ),
  AnalyticInfo(
    title: "Candidatures En Attentes",
    count: candidaturesEnAttentes.length,
    svgSrc: "assets/icons/enattente.svg",
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
