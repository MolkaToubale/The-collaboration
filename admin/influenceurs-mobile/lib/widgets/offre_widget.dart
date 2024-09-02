import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/offre_details.dart';

import '../providers/theme_notifier.dart';


class OffreWidget extends StatelessWidget {
   final OffreModel offre;

  const OffreWidget({ required this.offre});

  @override
  Widget build(BuildContext context) {
    
    var style = context.watch<ThemeNotifier>();
     var user = context.watch<UserProvider>().currentUser;
    return GestureDetector(
      onTap: () {
       
   Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => OffreDetails(offre)));

          
        
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
