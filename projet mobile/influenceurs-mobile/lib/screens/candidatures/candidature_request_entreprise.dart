import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:projet/widgets/request_card.dart';

import 'package:provider/provider.dart';

import '../../extra/Messenger/Messenger_ui.dart';
import '../../models/candidature.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';

class CandidatureRequestEntreprise extends StatefulWidget {
  const CandidatureRequestEntreprise({super.key});

  @override
  State<CandidatureRequestEntreprise> createState() => _CandidatureRequestEntrepriseState();
}

class _CandidatureRequestEntrepriseState extends State<CandidatureRequestEntreprise> {
 
  List<CandidatureModel> requests = [];
  

  fetchRequest() async {
      
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Candidatures').where('reponse',isEqualTo:'En attente').where('idEntreprise', isEqualTo:NavigationService.navigatorKey.currentContext!.read<UserProvider>()
        .currentUser!.id ).get();
  for (var doc in querySnapshot.docs) {
       CandidatureModel request = CandidatureModel.fromMap(doc.data());
       requests.add(request);
      
    setState(() {});
  }
   }

  @override
  void initState() {
  
    fetchRequest();
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
         await speak('Cette interface vous permet de visualiser les candidatures en attente à savoir  ${requests.length.toString()} candidatures.');

     
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: requests.length==0 ? Center(child: Text("Aucune candidature en attente pour le moment!",style: style.title.copyWith(fontSize: 13),)) :
          SingleChildScrollView(
            child:Column(
              children: [
                ...requests.map((e) { 
                 
                   return  RequestWidget(candidature: e);

                 
                }
                  )
              ],
            ),
          ),
      ),
    );
  }
}
