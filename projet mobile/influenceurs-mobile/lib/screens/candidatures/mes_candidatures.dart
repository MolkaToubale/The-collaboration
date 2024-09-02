import 'dart:developer';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path/path.dart';
import 'package:projet/services/navigation_service.dart';

import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../extra/Messenger/Messenger_ui.dart';
import '../../main.dart';
import '../../models/candidature.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/candidature_perso_card.dart';


class MesCandidatures extends StatefulWidget {
  const MesCandidatures({super.key});

  @override
  State<MesCandidatures> createState() => _MesCandidaturesState();
}

class _MesCandidaturesState extends State<MesCandidatures> {
 
  List<CandidatureModel> candidatures = [];




  fetchCandidatures() async {
   
 

     //try {
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Candidatures').where('reponse',isEqualTo:'En attente').where('idInfluenceur', isEqualTo:NavigationService.navigatorKey.currentContext!.read<UserProvider>()
        .currentUser!.id ).get();
  for (var doc in querySnapshot.docs) {
       CandidatureModel candidature = CandidatureModel.fromMap(doc.data());
       candidatures.add(candidature);    
   //  }
    setState(() {});
  }

   }
  

  @override
  void initState() {
  
    fetchCandidatures();
    super.initState();
  }
    bool isSpeaking = false;
  
  final FlutterTts flutterTts=FlutterTts();
  speak(String text) async{
    try {
      await flutterTts.setLanguage('fr');
      await flutterTts.setPitch(0.5);
      await flutterTts.setVolume(1);
      
      await flutterTts.speak(text);

    log('5edmet');

    } catch (e) {
      log('erreur speak $e');
    }
   

  }

   stopSpeaking() async{
    await flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    var user = context.watch<UserProvider>().currentUser;
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        elevation: 1,
        actions: [
         
          const SizedBox(
            width: 25,
          ),
          GestureDetector(
            child: Icon(
              CupertinoIcons.bubble_left_bubble_right_fill,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessengerUI()),
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),
            GestureDetector(
  child: Icon(
    CupertinoIcons.speaker_2_fill,
    color: style.invertedColor.withOpacity(.8),
  ),
  onTap: () async {
  
   
      if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
         await speak('Cette interface vous permet de visualiser vos candidatures en attente à savoir  ${candidatures.length.toString()} candidatures.');

     
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
    
  },
),
          const SizedBox(
            width: 15,
          ),
        ],
       
        title:Row(
    children: [
      Image.asset(
        'images/logoGris.png', 
        height: 50,
      ),
      const SizedBox(width: 10),
      
    ],
  ),

        // centerTitle: true,
        automaticallyImplyLeading: false,
      ),
        body: candidatures.isEmpty? Center(child: Text("Aucune candidature en attente pour le moment!",style: style.title.copyWith(fontSize: 13),))
             :Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:  SingleChildScrollView(
            child: Column(
              children: [ 
                ...candidatures.map((e) { 
                  
                   return CandidaturePersoCard(candidature: e,);

                 
                }
                  )
              ],
            ),
          ),
        
      ),
    );
  }
}
