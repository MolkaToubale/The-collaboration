import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet/models/candidature.dart';
import 'package:projet/screens/BottomNavScreens/favorite.dart';
import 'package:projet/screens/candidatures/candidature_request_entreprise_screen.dart';
import 'package:projet/screens/candidatures/mes_candidatures.dart';
import 'package:projet/services/navigation_service.dart';

import 'package:provider/provider.dart';

import '../constants/style.dart';
import '../providers/theme_notifier.dart';
import '../providers/user_provider.dart';
import '../screens/BottomNavScreens/Home_entreprise_screen.dart';
import '../screens/profil_entreprise/profil.dart';
import 'package:projet/screens/profil_influenceur/profil_influenceur.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final screensEntreprise = [
    const HomeScreen(),
    FavoriteScreen(),
    const CandidatureRequestEntreprise(),
    const ProfilEntreprise()
  ];
  final screensInfluenceur = [
    const HomeScreen(),
    FavoriteScreen(),
    MesCandidatures(),
    const ProfilInfluenceur()
  ];
  int currentIndex = 0;

  List<CandidatureModel>candEnAttente=[];
  


fetchCandidatures() async {
     if(NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!.statut=='Influenceur'){
       QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Candidatures').where('reponse',isEqualTo:'En attente').where('idInfluenceur', isEqualTo:NavigationService.navigatorKey.currentContext!.read<UserProvider>()
        .currentUser!.id ).get();
  for (var doc in querySnapshot.docs) {
       CandidatureModel candidature = CandidatureModel.fromMap(doc.data());
       candEnAttente.add(candidature);      
   
    setState(() {});
  }
     }
     else{
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Candidatures').where('reponse',isEqualTo:'En attente').where('idEntreprise', isEqualTo:NavigationService.navigatorKey.currentContext!.read<UserProvider>()
        .currentUser!.id ).get();
  for (var doc in querySnapshot.docs) {
       CandidatureModel request = CandidatureModel.fromMap(doc.data());
       candEnAttente.add(request);
      
    setState(() {});
  }

     }
 
}

@override
  void initState() {
    
    super.initState();
    fetchCandidatures();

  }


  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>().currentUser;
    var style = context.watch<ThemeNotifier>();

    return Scaffold(
      backgroundColor: style.navBarColor,
      //backgroundColor: style.bgColor,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: style.navBarColor,
        // backgroundColor: Colors.red,
        currentIndex: currentIndex,
        selectedItemColor: red,
        unselectedItemColor: style.invertedColor,
        selectedLabelStyle:
             TextStyle(color: style.invertedColor, fontWeight: FontWeight.bold),
        items: [
           BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
            backgroundColor:style.navBarColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: 'Favoris',
              backgroundColor:style.navBarColor),
          BottomNavigationBarItem(
              icon: Badge(
                child: const Icon(Icons.bookmark),
              label: Text(candEnAttente.length.toString(),style:TextStyle(color: Colors.white))
              ),
              label: 'Candidatures',
              backgroundColor:style.navBarColor),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'Profil',
             backgroundColor:style.navBarColor),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: user!.statut == 'Entreprise'
          ? screensEntreprise[currentIndex]
          : screensInfluenceur[currentIndex],
    );
  }
}
