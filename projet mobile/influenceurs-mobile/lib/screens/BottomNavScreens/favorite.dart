import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/models/offre.dart';


import 'package:projet/providers/favorite_provider.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/providers/user_provider.dart';

import 'package:provider/provider.dart';



import '../../extra/Messenger/Messenger_ui.dart';

import '../../widgets/offre_widget.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<OffreModel> offresFav = [];
  fetchFav() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users').doc(context.read<UserProvider>().currentUser!.id)
        .collection('offres')
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreFav= OffreModel.fromMap(doc.data());
      offresFav.add(offreFav);
     
    }
    setState(() {
      
    });
  
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
  void initState() {
   fetchFav();
   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<FavoriteProvider>(context);
    var style = context.watch<ThemeNotifier>();
    final offres=provider.offres;

    return Scaffold(
      appBar:AppBar(
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
         await speak('Cette interface vous permet de visualiser vos offres favorites à savoir  ${offresFav.length.toString()} offres.');

     
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
      body: offresFav.isEmpty?  Container(
        color: style.bgColor,
        child: Center(
          child: Text("Aucune offre favorite pour le moment!",style: style.title.copyWith(fontSize: 13),)),
      ) 
       :Container(
                   color: style.bgColor,
                  child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: offresFav.length,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10),
                              itemBuilder: (_, index) {
                  return OffreWidget(offre: offresFav[index]);
                              },
                            ),
                
            ),
    );
  }
}