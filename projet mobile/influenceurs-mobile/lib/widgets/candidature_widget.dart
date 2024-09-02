import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet/models/candidature.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:projet/screens/candidatures/candidature_details_influenceur_perso.dart';
import 'package:projet/screens/candidatures/candidatures_d%C3%A9tails.dart';
import 'package:projet/screens/profil_influenceur/profil_influenceur.dart';
import 'package:provider/provider.dart';

import '../providers/theme_notifier.dart';

class CandidatureWidget extends StatelessWidget {
   final CandidatureModel candidature;

  const CandidatureWidget({super.key, required this.candidature});

  @override
  Widget build(BuildContext context) {
    
    var style = context.watch<ThemeNotifier>();
     var user = context.watch<UserProvider>().currentUser;
    return GestureDetector(
      onTap: () {
       if (candidature.idInfluenceur==user!.id) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CandidatureDetailsInfluenceurPerso(candidature)));
       }else{
         Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CandidatureDetails(candidature)));
                  
       }
         
       
      },
      child: Container(
        height: 50,
        width: 100,
       
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
                        imageUrl: candidature.affiche,
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
                              candidature.libelleOffre,
                              style: style.text18.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          Text(
                            candidature.nomEntreprise,
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