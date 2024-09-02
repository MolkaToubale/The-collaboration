// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';

import '../../constants/style.dart';

import '../../providers/theme_notifier.dart';

class OffreDetails extends StatefulWidget {
  var offre;
  OffreDetails(
    
    this.offre,
  ) ;

  @override
  State<OffreDetails> createState() => _OffreDetailsState();
}

class _OffreDetailsState extends State<OffreDetails> {

 
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    

    
    return Scaffold(
      backgroundColor: style.bgColor,
     
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundColor: red,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
        ),
         actions: [
          
          GestureDetector(
            child: Icon(
              Icons.delete_forever_outlined,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
              
                              showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: const Text("Suppression de l'offre"),
                            content: const Text(
                        "La suppression de l'offre conduit à sa suppression du profil du représentant de l'entreprise concerné",
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                       FirebaseFirestore.instance.collection('offres').doc(widget.offre.id).delete();
                        Fluttertoast.showToast( msg: "Suppression de l'offre avec succés");
                       Navigator.push(context,MaterialPageRoute(builder: (context) =>AllUsersScreen() ),);

                    },
                     child: const Text('OK'),
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
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        title:Text(widget.offre.libelle,style: style.title.copyWith(color: red, fontSize: 22),),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                     widget.offre!.affiche,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Libellé:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.offre.libelle,
                       style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.offre.description,
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dernier délai d'envoi des candidatures:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateFormat('EEE, dd/MM/yyyy')
                          .format(widget.offre.dateFin),
                       style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
               Padding(
                 padding: const EdgeInsets.all(15),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text(
                       "Catégorie(s):",
                       style: TextStyle(
                         color: red,
                         fontWeight: FontWeight.bold,
                         fontSize: 18,
                       ),
                     ),
                     Text(
                       widget.offre.categories.join(", "),
                      style: style.text18.copyWith(fontSize: 16),
                     ),
                   ],
                 ),
               ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Text(
                      "Publiée par: ",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.offre.nomEntreprise,
                       style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        )),
      ),
    );
  }
}
