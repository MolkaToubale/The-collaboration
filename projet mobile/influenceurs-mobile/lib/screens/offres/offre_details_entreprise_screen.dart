import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:projet/extra/Messenger/const.dart';
import 'package:projet/main.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/offre_provider.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/delayed_animation.dart';
import '../candidatures/candidature_screen.dart';

class OffreDetailsEntreprise extends StatefulWidget {
  var offre;
  OffreDetailsEntreprise(this.offre, {super.key});

  @override
  State<OffreDetailsEntreprise> createState() => _OffreDetailsEntrepriseState();
}

class _OffreDetailsEntrepriseState extends State<OffreDetailsEntreprise> {
   var currentUser = NavigationService.navigatorKey.currentContext!
         .watch<UserProvider>()
         .currentUser;
  
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
       var currentUser = NavigationService.navigatorKey.currentContext!
           .watch<UserProvider>()
           .currentUser;
       
    final provider=Provider.of<FavoriteProvider>(context);
    final offres=Provider.of<FavoriteProvider>(context).offresId;
    return Scaffold(
      backgroundColor: style.bgColor,
     

      appBar: AppBar(
  backgroundColor: style.panelColor,
  
  leading: Padding(
    padding: const EdgeInsets.all(2.0),
    child: CircleAvatar(
      backgroundColor:red,
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    ),
  ),
   title:Text(widget.offre.libelle,style: style.title.copyWith(color: red, fontSize: 22),),
   actions: [
          
          const SizedBox(
            width: 25,
          ),
          GestureDetector(
            child: Icon(
              CupertinoIcons.speaker_2_fill,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () async {
              if (currentUser!.statut=='Influenceur') {
                  if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
                 await speak('Libellé de l\'offre   ${widget.offre.libelle} description   ${widget.offre.description}   dernier délai d\'envoi des candidatures   ${DateFormat('dd/MM/yyyy').format(widget.offre.dateFin)} Catégories ${widget.offre.categories.toString()} publiée par ${widget.offre.nomEntreprise} Le dernier délai d\'envoi des candidatures a été dépassé. Vous ne pouvez plus postuler pour cette offre');
             print('pressed');}
              isSpeaking = !isSpeaking; 
    print('pressed');
              }else{
                 if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
                 await speak('Libellé de l\'offre   ${widget.offre.libelle} description   ${widget.offre.description}   dernier délai d\'envoi des candidatures   ${DateFormat('dd/MM/yyyy').format(widget.offre.dateFin)} Catégories ${widget.offre.categories.toString()} publiée par ${widget.offre.nomEntreprise} ');
             print('pressed');
              }
                  isSpeaking = !isSpeaking; 
    print('pressed');
              }
             
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
 
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
                      color:style.bgColor,
                      // border: Border.all(
                      //   color: red,
                      //   width: 2.0,
                      // ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                     widget.offre!.affiche,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                     SizedBox(
       width: 60, // ajuster cette valeur en fonction de votre mise en page
       child:  CircleAvatar(
             backgroundColor: red,
             child: IconButton(
               onPressed: () {
                 provider.toggleFavorite(widget.offre);
                 setState(() {
                   
                 });
               },
               icon: offres.contains(widget.offre.id) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
             ),
           )
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
