import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/storageinfo.dart';


import 'chart.dart';


class StarageDetails extends StatefulWidget {
  const StarageDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<StarageDetails> createState() => _StarageDetailsState();
}


class _StarageDetailsState extends State<StarageDetails> {


    List<OffreModel> offresIT = [];
  List<OffreModel> offresBeaute = [];
  List<OffreModel> offresSport = [];
  List<OffreModel> offresPara = [];
  List<OffreModel> offresAutres = [];
  List<OffreModel> offresGastronomie = [];
  List<OffreModel> offresEducation = [];
  List<OffreModel> offresPhotographie = [];


    fetchOffresAutres() async {
    try {
       QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Autres')
        .get();

    for (var doc in querySnapshot.docs) {
      
      OffreModel offreAutre = OffreModel.fromMap(doc.data());
      offresAutres.add(offreAutre);
      
    }
    
    setState(() {});
    } catch (e) {
      log('erreur fetchAutres $e');
    }
   
  }
  
  fetchOffresBeaute() async {
    
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Beauté et Bien-être')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreBeaute = OffreModel.fromMap(doc.data());
      offresBeaute.add(offreBeaute);
      
    }
    setState(() {});
  }

  fetchOffresEducation() async {
    
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Education et Formation')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreEducation = OffreModel.fromMap(doc.data());
      offresEducation.add(offreEducation);
      
    }
    setState(() {});
  }

  fetchOffresGastronomie() async {
    
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Gastronomie')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreGastronomie = OffreModel.fromMap(doc.data());
      offresGastronomie.add(offreGastronomie);
      
    }
    setState(() {});
  }

  fetchOffresIt() async {
    
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'IT')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreIT = OffreModel.fromMap(doc.data());
      offresIT.add(offreIT);
      
    }
    setState(() {});
  }

  fetchOffresPara() async {

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Paramédical')
        
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreParamedicale = OffreModel.fromMap(doc.data());
      offresPara.add(offreParamedicale);
    }
    setState(() {});
  }

  fetchOffresPhotographie() async {
    // await Future.delayed(Duration(milliseconds: 50));
    // setState(() {});
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Photographie')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offrePhotographie = OffreModel.fromMap(doc.data());
      offresPhotographie.add(offrePhotographie);
      // await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {});
  }


  fetchOffresSport() async {
    
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Sport')
        .get();
    for (var doc in querySnapshot.docs) {
      OffreModel offreSport = OffreModel.fromMap(doc.data());
      offresSport.add(offreSport);
    }
    setState(() {});
  }

  @override
  void initState() {
    fetchOffresAutres();
    fetchOffresBeaute();
    fetchOffresEducation();
    fetchOffresGastronomie();
    fetchOffresIt();
    fetchOffresPara();
    fetchOffresPhotographie();
    fetchOffresSport();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    const primaryColor = Color(0xFF2697FF);

const defaultPadding = 16.0;

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Offres Détails",
            style: style.title.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: "assets/icons/Documents.svg",
            title: "Offres IT",
            amountOfFiles: offresIT.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Offres Gastronomie",
            amountOfFiles: offresGastronomie.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Offre Beauté et Bien-être",
            amountOfFiles: offresBeaute.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Offre Education",
            amountOfFiles: offresEducation.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Offre Paramédicale",
            amountOfFiles: offresPara.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Offre Sport",
            amountOfFiles: offresSport.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Autres Offres",
            amountOfFiles: offresAutres.length.toString(),
            
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Offre Photographie",
            amountOfFiles: offresPhotographie.length.toString(),
            
          ),
        ],
      ),
    );
  }
}