import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/candidature.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/candidature_details.dart';

import '../providers/theme_notifier.dart';

class CandidatureWidget extends StatelessWidget {
   final CandidatureModel candidature;

  const CandidatureWidget({required this.candidature});

  @override
  Widget build(BuildContext context) {
    
    var style = context.watch<ThemeNotifier>();
     var user = context.watch<UserProvider>().currentUser;
    return GestureDetector(
      onTap: () {
       
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CandidatureDetails(candidature)));
      
       
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