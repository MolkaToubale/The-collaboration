import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/candidature_provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/all_candidatures_dashboard.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/candidature_details.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../models/candidature.dart';


class CandidatureFiles extends StatefulWidget {
  const CandidatureFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<CandidatureFiles> createState() => _CandidatureFilesState();
}

class _CandidatureFilesState extends State<CandidatureFiles> {
  List<CandidatureModel> candidatures = [];
  List<CandidatureModel> filteredCandidature = [];
  String selectedValue = "Toutes les candidatures";

  fetchCand() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Candidatures').get();
      for (var doc in querySnapshot.docs) {
        CandidatureModel candidature = CandidatureModel.fromMap(doc.data());
        candidatures.add(candidature);

        setState(() {
          filteredCandidature = candidatures;
        });
      }
    } catch (e) {
      log('erreur affichage cands $e');
    }
  }

  initState() {
    fetchCand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const defaultPadding = 16.0;
    var style = context.watch<ThemeNotifier>();

    return  Container(
        height:1500,
        width: 2500,
         padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: style.bgColor,
          //color: Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
              
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Liste des candidatures",
                    style: style.title.copyWith(fontSize: 15),
                  ),
                  DropdownButton(
                     value: selectedValue, 
                    hint: Text("Toutes les candidatures",style: style.title.copyWith(fontSize: 15,color: style.invertedColor),),
                    items: [
                      DropdownMenuItem(
                        value: "Toutes les candidatures",
                        child: Text("Toutes les candidatures"),
                      ),
                      DropdownMenuItem(
                        
                        value: "Acceptées",
                        child: Text("Acceptées"),
                      ),
                      DropdownMenuItem(
                        value: "Refusées",
                        child: Text("Refusées"),
                      ),
                      DropdownMenuItem(
                        value: "En attente",
                        child: Text("En attente"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value.toString();
                        if (selectedValue == "Toutes les candidatures") {
                          filteredCandidature = List.from(candidatures);
                        } else if (selectedValue == "Refusées") {
                          filteredCandidature = candidatures
                              .where((candiadature) =>
                                  candiadature.reponse == "Declinee")
                              .toList();
                        } else if (selectedValue == "En attente") {
                          filteredCandidature = candidatures
                              .where((candiadature) =>
                                  candiadature.reponse == "En attente")
                              .toList();
                        } else if (selectedValue == "Acceptées") {
                          filteredCandidature = candidatures
                              .where((candiadature) =>
                                  candiadature.reponse == "Acceptee")
                              .toList();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
           Container(
             //color: Colors.green,
             color: style.bgColor,
             width: 2300,
             height: 1000,
              child: DataTable(
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(
                    label: Text(
                      "Nom de l'entreprise",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Nom de l'influenceur",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Réponse",
                      style: TextStyle(color: red),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Actions",
                      style: TextStyle(color: red),
                    ),
                  ),
                 
                ],
                rows: List.generate(
                  filteredCandidature.length,
                  (index) =>
                      recentFileDataRow(context, filteredCandidature[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentFileDataRow(BuildContext context, CandidatureModel candiadature) {
  const defaultPadding = 16.0;
  var style = context.watch<ThemeNotifier>();
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            ClipOval(
              child: Image.network(
                candiadature.affiche,
                height: 30,
                width: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                candiadature.nomEntreprise,
                style: TextStyle(color: style.invertedColor),
              ),
            ),
          ],
        ),
      ),
      DataCell(
        Text(
          candiadature.nomInfluenceur,
          style: TextStyle(color: style.invertedColor),
        ),
      ),
      DataCell(Text(
        candiadature.reponse,
        style: TextStyle(color: style.invertedColor),
      )),
      DataCell(
        Row(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Suppression de la candidature"),
                    content: const Text(
                      "Vous êtes sur le point de supprimer cette candidature, les utilisateurs ne pourront plus la consulter",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () async{
                          await FirebaseFirestore.instance.collection('Candidatures').doc(candiadature.id).delete();
                          
                          Fluttertoast.showToast(
                              msg: "Suppression de la candidature avec succès");
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => AllUsersScreen(),
                             ),
                           );
                          
                        },
                        child: const Text('Confirmer'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Annuler'),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 10,),
             IconButton( 
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CandidatureDetails(candiadature)),
            );
          },
          icon: Icon(
            Icons.visibility,
            color: primaryColor,
          ),
        ),
          ],
        ),
      ),
     
    ],

    //  onLongPress:()  {

    //   showDialog(
    //                           context: context,
    //                          builder: (context) => AlertDialog(
    //                          title: const Text("Suppression de la candidature"),
    //                         content: const Text(
    //                     "Vous êtes sur le point de supprimer cette candidature, les utilisateurs ne pourront plus la consulter",
    //                   ),
    //                 actions: [
    //                  TextButton(
    //                 onPressed: () {
    //                    context.read<CandidatureProvider>().deleteCandidature(candiadature);
    //                     Fluttertoast.showToast( msg: "Suppressionn de la candidature avec succés");
    //                    Navigator.push(context,MaterialPageRoute(builder: (context) => AllCandidaturesScreen()),);

    //                 },
    //                  child: const Text('Confirmer'),
    //           ),

    //           TextButton(onPressed:(){
    //              Navigator.push(context, MaterialPageRoute(builder: (context) => CandidatureDetails(candiadature)),);
    //               }
    //           ,child: const Text("Consulter Candidature")
    //           ),
    //            TextButton(
    //                 onPressed: () {
    //                    Navigator.pop(context);
    //                 },
    //                  child: const Text('Annuler'),
    //           ),
    //         ],
    //       ),
    //     );

    // },
  );
}
