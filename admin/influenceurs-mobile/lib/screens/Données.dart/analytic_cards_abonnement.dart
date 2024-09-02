import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import '../../models/abonnement.dart';
import '../../models/user.dart';
import '../../providers/abonnement_provider.dart';
import '../../providers/theme_notifier.dart';
import 'analytic_info_card.dart';

class AnalyticCardsAbonnement extends StatefulWidget {
  const AnalyticCardsAbonnement({Key? key}) : super(key: key);

  @override
  State<AnalyticCardsAbonnement> createState() =>
      _AnalyticCardsAbonnementState();
}

class _AnalyticCardsAbonnementState extends State<AnalyticCardsAbonnement> {
  List<AbonnementModel> abonnements = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Responsive(
        mobile: AnalyticInfoCardGridViewAbonnement(
          crossAxisCount: size.width < 650 ? 2 : 4,
          childAspectRatio: size.width < 650 ? 2 : 1.5,
        ),
        tablet: AnalyticInfoCardGridViewAbonnement(),
        desktop: AnalyticInfoCardGridViewAbonnement(
          childAspectRatio: size.width < 1400 ? 1.5 : 2.1,
        ),
      ),
    );
  }
}

class AnalyticInfoCardGridViewAbonnement extends StatefulWidget {
  const AnalyticInfoCardGridViewAbonnement({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.4,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridViewAbonnement> createState() =>
      _AnalyticInfoCardGridViewAbonnementState();
}

class _AnalyticInfoCardGridViewAbonnementState
    extends State<AnalyticInfoCardGridViewAbonnement> {
  List<UserModel> abonnements = [];
  List<UserModel> abonnementannuel = [];
 List<UserModel> abonnementmensuel = [];
 List<UserModel> abonnementtrimestriel = [];

  fetchAbonnement() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('users')
          .where('statut',isEqualTo: 'Entreprise')
           //.where('dateInscription', isEqualTo: null)
           .where('abonnement', whereIn: ['ANNUEL', 'MENSUEL', 'TRIMESTRIEL'])
              .get();
      for (var doc in querySnapshot.docs) {
        UserModel abonnement = UserModel.fromMap(doc.data());
        abonnements.add(abonnement);

        setState(() {});
      }
    } catch (e) {
      log('erreur affichage abonnement $e');
    }
  }

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
    fetchAbonnement();
    fetchAbonnementmensuel();
    fetchAbonnementAnnuel();
    fetchAbonnementtrimestriel();
    //context.read<AbonnementProvider>().getAbonnements();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();

    //var abonnement = context.watch<AbonnementProvider>();
    //final abonnements = Provider.of<AbonnementProvider>(context).abonnements;
    List analyticData = [
      AnalyticInfo(
        backgroundColor: style.bgColor,
        title: "Abonnement",
        count: abonnements.length,
        svgSrc: "assets/icons/abo.svg",
        color: primaryColor,
      ),
      AnalyticInfo(
        backgroundColor: style.bgColor,
        title: "Abonnement Annuel",
        count: abonnementannuel.length,
        svgSrc: "assets/icons/annuel.svg",
        color: purple,
      ),
     
      AnalyticInfo(
        backgroundColor: style.bgColor,
        title: "Abonnement Trimestriel",
        count: abonnementtrimestriel.length,
        svgSrc: "assets/icons/trimestriel.svg",
        color: green,
      ),
       AnalyticInfo(
        backgroundColor: style.bgColor,
        title: "Abonnement Mensuel",
        count: abonnementmensuel.length,
        svgSrc: "assets/icons/mensuel.svg",
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
