import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projet/constants/style.dart';
import 'package:projet/models/candidature.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/screens/candidatures/candidature_details_influenceur_perso.dart';
import 'package:projet/screens/candidatures/candidatures_d%C3%A9tails.dart';
import 'package:provider/provider.dart';

import '../../providers/candidature_provider.dart';
import '../../widgets/buttom_bar.dart';

class CandidaturePersoCard extends StatefulWidget {
  var candidature;
  CandidaturePersoCard({
    Key? key,
    required this.candidature,
  }) : super(key: key);

  @override
  _CandidaturePersoCardState createState() => _CandidaturePersoCardState();
}

class _CandidaturePersoCardState extends State<CandidaturePersoCard> {
    
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<CandidatureProvider>(context);
    var style = context.watch<ThemeNotifier>();
    final candidatures=provider.candidatures;
    return Container(
      color: style.bgColor,
      child: Container(
        child: Card(
          color: style.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  height: 100,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.candidature.affiche),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        widget.candidature.libelleOffre,
                        style: style.title.copyWith(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "Ma candidature",
                        style:style.text18.copyWith(fontSize: 13) ,
                      ),
                    ),
                    
                  
                    
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                        ElevatedButton(
                          onPressed: () {

                               Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => CandidatureDetailsInfluenceurPerso(widget.candidature)),
                             
                               );
                             print('voir détails');
                          },
                          child: Text('Voir Détails'),
                          style: ElevatedButton.styleFrom(
                            primary:red,
                            onPrimary: style.bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                         SizedBox(width: 8.0),
                          OutlinedButton(
                          onPressed: () {


                            
                              showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: const Text("Annulation de la candidature"),
                            content: const Text(
                        "Si vous supprimez votre candiature, le représentant de l'entreprise ne pourra pas la voir! ",
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                       
                       provider.deleteCandidature(widget.candidature);
                       Fluttertoast.showToast( msg: "Annulation de la candidature avec succés");

                            Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const BottomNavController()),
                             (route) => false,
                               );
                  

                    },
                     child: const Text('Confirmer'),
              ),
               TextButton(
                    onPressed: () {
                       Fluttertoast.showToast( msg: "Suppression de l'offre annulée");
                       Navigator.pop(context);

                    },
                     child: const Text('Annuler'),
              ),
            ],
          ),
        );
                           
                          },
                          child: Text('Supprimer'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.pink[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                                color: Color(0xFFE91E63), width: 2.0),
                          ),
                        ),





                       
                        
                        
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
