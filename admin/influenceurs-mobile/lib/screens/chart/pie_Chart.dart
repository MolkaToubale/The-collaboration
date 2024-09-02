import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';

import '../../models/user.dart';
import '../../providers/abonnement_provider.dart';

class PieChartWidget extends StatefulWidget {
  PieChartWidget({Key? key}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {

   List<UserModel> abonnements = [];

   List<UserModel> abonnementannuel = [];

   List<UserModel> abonnementmensuel = [];

   List<UserModel> abonnementtrimestriel = [];

   fetchAbonnementAnnuel() async {
     try {
       QuerySnapshot<Map<String, dynamic>> querySnapshot =
           await FirebaseFirestore.instance
               .collection('users')
               .where('abonnement', isEqualTo: "ANNUEL")
               .get();
       for (var doc in querySnapshot.docs) {
         UserModel abonnement = UserModel.fromMap(doc.data());
         abonnementannuel.add(abonnement);

         setState(() {});
       }
     } catch (e) {
       log('erreur affichage abonnement annuel $e');
     }
   }

   fetchAbonnementmensuel() async {
     try {
       QuerySnapshot<Map<String, dynamic>> querySnapshot =
           await FirebaseFirestore.instance
               .collection('users')
               .where('abonnement', isEqualTo: "MENSUEL")
               .get();
       for (var doc in querySnapshot.docs) {
         UserModel abonnement = UserModel.fromMap(doc.data());
         abonnementmensuel.add(abonnement);

         setState(() {});
       }
     } catch (e) {
       log('erreur affichage abonnement mensuel $e');
     }
   }

   fetchAbonnementtrimestriel() async {
     try {
       QuerySnapshot<Map<String, dynamic>> querySnapshot =
           await FirebaseFirestore.instance
               .collection('users')
               .where('abonnement', isEqualTo: "TRIMESTRIEL")
               .get();
       for (var doc in querySnapshot.docs) {
         UserModel abonnement = UserModel.fromMap(doc.data());
         abonnementtrimestriel.add(abonnement);

         setState(() {});
       }
     } catch (e) {
       log('erreur affichage abonnement trimestiel $e');
     }
   }

   initState() {
     fetchAbonnementmensuel();
     fetchAbonnementAnnuel();
     fetchAbonnementtrimestriel();
     context.read<AbonnementProvider>().getAbonnements();

     super.initState();
   }

  Widget build(BuildContext context) {
     var style = context.watch<ThemeNotifier>();
    Map<String, double> dataMap = {
      'Abonnement Annuel ': abonnementannuel.length.toDouble(),
      'Abonnement Mensuel ': abonnementmensuel.length.toDouble(),
      'Abonnement Trimestriel': abonnementtrimestriel.length.toDouble(),
    };
    List<Color> colorList = [
         const Color(0xffE91E63),
       const Color(0xffFFC107),
        const Color (0xff3398f6),

    ];

    return PieChart(
      dataMap: dataMap,
      colorList: colorList,
      chartRadius: MediaQuery.of(context).size.width / 6,  //le rayon est défini en fonction de la largeur de l'écran 
       centerText: "Abonnement",  //définir le texte affiché au centre du graphique circulaire
       
       
       chartValuesOptions:ChartValuesOptions(
        
        showChartValues: true,  //les valeurs du graphique doivent être affichées.
        showChartValuesOutside: true, //les valeurs du graphique doivent être affichées à l'extérieur des segments.
        showChartValuesInPercentage: true // les valeurs du graphique doivent être affichées en pourcentage.

       
       ) ,
       legendOptions: LegendOptions(
        legendTextStyle: TextStyle(color: style.invertedColor), //le style du texte de la légende avec une couleur spécifique 
           showLegends: true, // la légende doit être affichée.
           legendShape: BoxShape.rectangle 
       ) ,  //pour personnaliser les options de la légende du graphique
      );
  }
}
