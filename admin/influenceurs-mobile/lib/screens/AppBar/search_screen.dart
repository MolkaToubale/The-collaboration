import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:responsive_admin_dashboard/models/offre.dart';
import 'package:responsive_admin_dashboard/models/user.dart';
import 'package:responsive_admin_dashboard/providers/admin_provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/offre_details.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_entreprise.dart';
import 'package:responsive_admin_dashboard/screens/all_users/user_details_influenceur.dart';



class SearchScreen extends StatefulWidget {


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
   final TextEditingController _controller = TextEditingController();
  List<dynamic> suggestions = [];
  List<UserModel> allUsers = [];
  List<OffreModel>allOffres=[];


 @override
  void initState() {
    super.initState();
    initSearch();
    _controller.addListener(() {
      onChange();
    });
  }



  void onChange() {
  final searchText = _controller.text.toLowerCase();
  suggestions = [
    ...allUsers.where((user) =>
        user.nomPrenom.toLowerCase().contains(searchText)),
    ...allOffres.where((offre) =>
        offre.libelle.toLowerCase().contains(searchText)),
  ];
  setState(() {});
}





void initSearch() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .get();
    for (var d in userSnapshot.docs) {
      allUsers.add(UserModel.fromMap(d.data()));
    }
   // log(allUsers.toString());

    final offreSnapshot = await FirebaseFirestore.instance.collection("offres").get();
    for (var d in offreSnapshot.docs) {
      allOffres.add(OffreModel.fromMap(d.data()));
    }
   // log(allOffres.toString());

    suggestions = [...allUsers, ...allOffres];
    //log(suggestions.toString());
    setState(() {});
}
  
  @override
  Widget build(BuildContext context) {
     var style = context.watch<ThemeNotifier>();
     var user = context.watch<AdminProvider>().currentAdmin;
    
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: red,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        title:Text('Recherche',style: style.title.copyWith(color: red,fontSize: 22),),
      ),

      body:Padding(
        padding: EdgeInsets.only(top:10),
        child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                     child: TextFormField(
                                     decoration:  InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      suffixIconColor: red,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Effectuez votre recherche par ici",
                      hintStyle: style.text18,
                      
                                     ),
                                     controller: _controller,
                                    
                                   ),
                   ),
      
                      const SizedBox(
                        height: 10,
                      ),
                      ...suggestions
                  .where((e) =>
                      e is UserModel &&
                      e.nomPrenom
                          .toLowerCase()
                          .contains(_controller.text.toLowerCase()) ||
                      e is OffreModel &&
                      e.libelle
                          .toLowerCase()
                          .contains(_controller.text.toLowerCase()))
                  .map((e) {
                     if (e is UserModel) {
                        return Card(
                            elevation: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: ListTile(
                                
                                onTap: () async {
      
                                  print ('user');
                                   if(e.statut=='Entreprise'){
                                   Navigator.push(context,
                                   MaterialPageRoute(builder: (_) => ProfilEntrepriseDetails(entreprise: e,)));
                                   }
                                   else {
                                   Navigator.push(context,
                                   MaterialPageRoute(builder: (_) => ProfilInfluenceurDetails(influenceur: e,)));
                                   }
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      e.nomPrenom,
                                      style: style.title.copyWith(fontSize: 15),
                                    ),
                                    Text(e.statut,
                                    style: style.text18.copyWith(color: red,fontSize: 13),)
                                  ],
                                ),
                                leading: Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(left: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: style.bgColor,
                                      border: Border.all(
                                          color: Colors.orange, width: 3),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 4,
                                            color: Colors.black38)
                                      ],
                                    ),
                                    child: Container(
                                      
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: e.photo.isEmpty
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/ProfilPic.png",
                                                ),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(e.photo),
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                   

                                    ),
                              ),
                              color: style.bgColor,
                            ),
                          );
                          
                  }
                   else if(e is OffreModel) {
                        return Card(
                            elevation: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 5),
                              child: ListTile(
                                onTap: () async {
                                  print('offre');
                                  
                                     Navigator.push(context,
                                   MaterialPageRoute(builder: (_) => OffreDetails(e)));
                                  
                                  
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [     
                                    Text(
                                      e.libelle,
                                      style: style.title.copyWith(fontSize: 15),
                                    ),
                                    Text("Offre",
                                    style: style.text18.copyWith(color: red,fontSize: 13),)
                                  ],
                                ),
                                leading: Container(
                                    height: 60,
                                    width: 60,
                                    margin: const EdgeInsets.only(left: 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: style.bgColor,
                                      border: Border.all(
                                          color: Colors.orange, width: 3),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 4,
                                            color: Colors.black38)
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: e.affiche.isEmpty
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                  "assets/images/ProfilPic.png",
                                                ),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image: NetworkImage(e.affiche),
                                                fit: BoxFit.cover),
                                      ),
                                    )),
                              ),
                              color: style.bgColor,
                            ),
                          );
                          
                  }
                  else{
                    return Text("Aucun résultat disponnible");
                  }
                 
                  }
                  )  
                    ],
                  ),
                ),
      )
              );
              
    
  }
}





















































