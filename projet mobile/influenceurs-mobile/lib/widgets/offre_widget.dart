import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:projet/models/offre.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:projet/screens/offres/offre_details_entreprise_perso.dart';
import 'package:provider/provider.dart';

import '../providers/theme_notifier.dart';
import '../screens/offres/offre_details_entreprise_screen.dart';
import '../screens/offres/offre_details_influenceur_screen.dart';

class OffreWidget extends StatefulWidget {
  final OffreModel offre;

  const OffreWidget({super.key, required this.offre});

  @override
  State<OffreWidget> createState() => _OffreWidgetState();
}

class _OffreWidgetState extends State<OffreWidget> {
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    var user = context.watch<UserProvider>().currentUser;
    log(widget.offre.toString());

    OffreModel offre = widget.offre;
    return GestureDetector(
      onTap: () {
        if (user!.statut == 'Influenceur') {
          if (offre.dateFin.millisecondsSinceEpoch >=
              DateTime.now().millisecondsSinceEpoch) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OffreDetailsInfluenceur(offre)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OffreDetailsEntreprise(offre)));
          }
        } else {
          if (offre.idEntreprise == user.id) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OffreDetailsEntreprisePerso(offre)));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => OffreDetailsEntreprise(offre)));
          }
        }
      },
      child: Container(
        height: 50,
        width: 100,
        // margin: index % 2 == 0
        //     ? const EdgeInsets.only(left: 22)
        //     : const EdgeInsets.only(right: 22),
        decoration: BoxDecoration(
            color: style.bgColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(2, 2), blurRadius: 4, color: Colors.black45)
            ]),
        child: Container(
          decoration: BoxDecoration(
            color: style.invertedColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              children: [
                Expanded(
                    flex: 6,
                    child: SizedBox(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: offre.affiche,
                        fit: BoxFit.cover,
                      ),
                    )),
                Expanded(
                    flex: 3,
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                            ),
                            child: Text(
                              offre.libelle,
                              style: style.text18.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          Text(
                            offre.nomEntreprise,
                            style: style.text18.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
