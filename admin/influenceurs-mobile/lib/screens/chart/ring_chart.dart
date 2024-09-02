import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/style.dart' as cst;
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';

import '../../constants/constants.dart';
import '../../models/user.dart';

class RingChart extends StatefulWidget {
  const RingChart({Key? key}) : super(key: key);

  @override
  State<RingChart> createState() => _RingChartState();
}

class _RingChartState extends State<RingChart> {
  List<UserModel> influenceur = [];
  List<UserModel> entreprise = [];
  List<UserModel> users = [];
  List<UserModel> deletedusers = [];

  fetchinfluenceur() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('statut', isEqualTo: "Influenceur")
              .get();
      for (var doc in querySnapshot.docs) {
        UserModel inf = UserModel.fromMap(doc.data());
        influenceur.add(inf);

        setState(() {});
      }
    } catch (e) {
      log('erreur affichage des influenceurs $e');
    }
  }

  fetchentreprise() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('statut', isEqualTo: "Entreprise")
              .get();
      for (var doc in querySnapshot.docs) {
        UserModel entr = UserModel.fromMap(doc.data());
        entreprise.add(entr);

        setState(() {});
      }
    } catch (e) {
      log('erreur affichage des entreprises $e');
    }
  }

  fetchallusers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      for (var doc in querySnapshot.docs) {
        UserModel all = UserModel.fromMap(doc.data());
        users.add(all);

        setState(() {});
      }
    } catch (e) {
      log('erreur affichage des entreprises $e');
    }
  }

  fetchallusersdeleted() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('deleted_users').get();
      for (var doc in querySnapshot.docs) {
        UserModel all = UserModel.fromMap(doc.data());
        deletedusers.add(all);

        setState(() {});
      }
    } catch (e) {
      log('erreur affichage des entreprises $e');
    }
  }

  initState() {
    fetchinfluenceur();
    fetchentreprise();
    fetchallusers();
    fetchallusersdeleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    Map<String, double> dataMap1 = {
      'Influenceurs': influenceur.length.toDouble(),
      'Entreprises': entreprise.length.toDouble(),
    };
    List<Color> colorList1 = [
       const Color(0xffFFC107),
      const Color(0xffE91E63),
      
    ];

    Map<String, double> dataMap2 = {
      'Utilisateurs': users.length.toDouble(),
      'Utilisateurs supprimés': deletedusers.length.toDouble(),
    };
    List<Color> colorList2 = [
      const Color(0xffFFC107),
      const Color(0xffE91E63),
     
    ];

    return Row(
      children: [
        Expanded(
          child: PieChart(
            dataMap: dataMap1,
            colorList: colorList1,
            chartRadius: MediaQuery.of(context).size.width / 6,
            centerText: "Entreprise/Influenceurs",
            animationDuration: Duration(seconds: 5),
            chartType: ChartType.ring,
            chartValuesOptions: ChartValuesOptions(
              showChartValues: true,
              showChartValuesOutside: true,
              showChartValuesInPercentage: true,
            ),
            legendOptions: LegendOptions(
            legendTextStyle: TextStyle(color: style.invertedColor),
              showLegends: true,
              legendShape: BoxShape.rectangle,
            ),
          ),
        ),
        Expanded(
          child: PieChart(
            dataMap: dataMap2,
            colorList: colorList2,
            chartRadius: MediaQuery.of(context).size.width / 6,
            centerText: "Utilisateurs /Utilisateurs supprimées",
            animationDuration: Duration(seconds: 5),
            chartType: ChartType.ring,
            chartValuesOptions: ChartValuesOptions(
              showChartValues: true,
              showChartValuesOutside: true,
              showChartValuesInPercentage: true,
            ),
            legendOptions: LegendOptions(
              legendTextStyle:TextStyle(color: style.invertedColor) ,
              showLegends: true,
              legendShape: BoxShape.rectangle,
            ),
          ),
        ),
      ],
    );
  }
}
