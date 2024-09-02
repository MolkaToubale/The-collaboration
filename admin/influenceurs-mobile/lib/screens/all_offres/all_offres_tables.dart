import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/all_offres_dashboard.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/offre_details.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_content.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';
import '../../constants/constants.dart';
import '../../constants/style.dart';
import '../../models/offre.dart';


class OffresFiles extends StatefulWidget {
  const OffresFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<OffresFiles> createState() => _OffresFilesState();
}

class _OffresFilesState extends State<OffresFiles> {
   String selectedValue = "Toutes les catégories";
   List<OffreModel> offres = [];
   List<OffreModel> filteredOffres = [];

    fetchOffres() async {
      try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('offres').get();
      for (var doc in querySnapshot.docs) {
        OffreModel offre = OffreModel.fromMap(doc.data());
        offres.add(offre);
    
        setState(() {

          filteredOffres=offres;

        });
      } 
      } catch (e) {
       log('erreur affichage des offres $e') ;
      }
      
    
  

    }
   
   initState() {
       fetchOffres();
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
                       "Listes des Offres",
                       style: style.title.copyWith(fontSize: 15),
                     ),
               DropdownButton(
                value: selectedValue, 
                 hint: Text("Toutes les catégories",style: style.title.copyWith(fontSize: 15,color: style.invertedColor),),
                 items: [
                   DropdownMenuItem(
                     value: "Toutes les catégories",
                     child: Text("Toutes les offres"),
                   ),
                   DropdownMenuItem(
                     value: "Beauté et Bien-être",
                     child: Text("Beauté et Bien-être"),
                   ),
                   DropdownMenuItem(
                     value: "Gastronomie",
                     child: Text("Gastronomie"),
                   ),
                    DropdownMenuItem(
                     value: "Photographie",
                     child: Text("Photographie"),
                   ),
                   DropdownMenuItem(
                     value: "Sport",
                     child: Text("Sport"),
                   ),
                   DropdownMenuItem(
                     value: "IT",
                     child: Text("IT"),
                   ),
                     DropdownMenuItem(
                     value: "Education et Formation",
                     child: Text("Education et Formation"),
                   ),
                      DropdownMenuItem(
                     value: "Paramédical",
                     child: Text("Paramédical"),
                   ),
                    DropdownMenuItem(
                     value: "Autres",
                     child: Text("Autres"),
                   ),
                           
                 ],
                           
                 onChanged: (value) {
                      setState(() {
                         selectedValue = value.toString();

                        if (selectedValue == "Toutes les catégories") {
                          filteredOffres = List.from(offres);
                        } else if (selectedValue== "Beauté et Bien-être") {
                          filteredOffres = offres
                              .where((offre) =>
                                  offre.categories.contains("Beauté et Bien-être") )
                              .toList();
                        } else if (selectedValue == "Gastronomie") {
                          filteredOffres = offres
                              .where((offre) =>
                                  offre.categories.contains("Gastronomie") )
                              .toList();
                        }else if (selectedValue == "Photographie") {
                         filteredOffres = offres
                              .where((offre) =>
                                  offre.categories.contains("Photographie"))
                              .toList();
                        } else if (selectedValue == "Sport") {
                          filteredOffres = offres
                              .where((offre) =>
                                 offre.categories.contains("Sport"))
                              .toList();
                        }else if (selectedValue == "IT") {
                          filteredOffres = offres
                              .where((offre) =>
                                 offre.categories.contains("IT"))
                              .toList();
                        }else if (selectedValue == "Education et Formation") {
                          filteredOffres = offres
                              .where((offre) =>
                                  offre.categories.contains("Education et Formation"))
                              .toList();
                      }else if (selectedValue == "Paramédical") {
                          filteredOffres = offres
                              .where((offre) =>
                                 offre.categories.contains("Paramédical"))
                              .toList();
                      }else if (selectedValue == "Autres") {
                          filteredOffres = offres
                              .where((offre) =>
                                 offre.categories.contains("Autres"))
                              .toList();
                      }
                      }
                      );
                    },
                  ),
                ],
              ),
            ),
        
             
          Container(
                //color: Colors.green,
                color: style.bgColor,
             width: 2300,
             height: 1300,
            child: DataTable(
              columnSpacing: defaultPadding,
             
              columns: [
                DataColumn(
                  label: Text("Libellé de l'offre",style: TextStyle(color: red),),
                ),
                DataColumn(
                  label: Text("Nom de l'entreprise",style: TextStyle(color: red),),
                ),
                DataColumn(
                  label: Text("Dernier Délai",style: TextStyle(color: red),),
                ),
                DataColumn(
                  label: Text("Actions",style: TextStyle(color: red),),
                ),
               
      
              ],
              rows: List.generate(
                filteredOffres.length,
                (index) => recentFileDataRow(context,filteredOffres[index]),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}

DataRow recentFileDataRow(BuildContext context ,OffreModel offre) {
  var style = context.watch<ThemeNotifier>();
  const defaultPadding = 16.0;
  return DataRow(
         
    cells: [
       DataCell(
        Row(
          children: [
             ClipOval(
               child: Image.network(
                 offre.affiche,
                 height: 30,
                 width: 30,
               ),
             ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(offre.libelle, style: TextStyle(color: style.invertedColor),),
            ),
          ],
        ),
      ),
     
      DataCell(Text(offre.nomEntreprise,style: TextStyle(color: style.invertedColor),)),
      DataCell(Text(DateFormat('EEE, dd/MM/yyyy').format(offre.dateFin,),style: TextStyle(color: style.invertedColor),),),
    DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Suppression de l'offre"),
                    content: const Text(
                      "Vous êtes sur le point de supprimer cette offre, les utilisateurs ne pourront plus la consulter",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance.collection('offres').doc(offre.id).delete();
                          Fluttertoast.showToast(
                              msg: "Suppressionn de l'offre' avec succés");
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
            ),
           SizedBox(width: 20,),
            IconButton(
          icon: Icon(
            Icons.remove_red_eye,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OffreDetails(offre),
              ),
            );
          },
        ),
          ],
        ),
      ),

    ],
    
  );
}