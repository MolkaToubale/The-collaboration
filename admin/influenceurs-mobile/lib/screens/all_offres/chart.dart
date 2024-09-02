import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';

import '../../constants/constants.dart';


class Chart extends StatefulWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<OffreModel> offres = [];
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
    
    void initState(){
      fetchOffres();
      super.initState();
    }


  @override
  Widget build(BuildContext context) {
     const primaryColor = Color(0xFF2697FF);
var style = context.watch<ThemeNotifier>();
const defaultPadding = 16.0;
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionDatas,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  offres.length.toString(),
                  style: style.title.copyWith(
                        
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("Au Total",style: TextStyle(color: style.invertedColor),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> paiChartSelectionDatas = [
  
  PieChartSectionData(

     
    color: primaryColor,
    value: 25,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: Color(0xFF26E5FF),
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.1),
    value: 25,
    showTitle: false,
    radius: 13,
  ),
];