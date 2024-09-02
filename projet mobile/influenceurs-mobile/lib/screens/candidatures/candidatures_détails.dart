import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:projet/extra/Messenger/const.dart';
import 'package:projet/main.dart';
import 'package:projet/providers/candidature_provider.dart';
import 'package:projet/screens/offres/edit_offre_screen.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/offre_provider.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/navigation_service.dart';
import '../../widgets/delayed_animation.dart';
import '../../widgets/view.dart';

class CandidatureDetails extends StatefulWidget {
  
  var candidature;
  CandidatureDetails(this.candidature, {super.key});

  @override
  State<CandidatureDetails> createState() => _CandidatureDetailsState();
}

class _CandidatureDetailsState extends State<CandidatureDetails> {

  bool isSpeaking = false;
  
  final FlutterTts flutterTts=FlutterTts();
  speak(String text) async{
    try {
      await flutterTts.setLanguage('fr');
      await flutterTts.setPitch(0.5);
      await flutterTts.setVolume(1);
      
      await flutterTts.speak(text);


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
       

    
    return Scaffold(
      backgroundColor: style.bgColor,
     
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundColor: red,
              child: IconButton(
                  onPressed: (){
                      Navigator.pop(context); 
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
        ),
         title:Text(widget.candidature.libelleOffre,style: style.title.copyWith(color: red, fontSize: 19),),
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
    if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
      await speak(
          'Libellé de l\'offre ${widget.candidature.libelleOffre} nom de l\'entreprise ${widget.candidature.nomEntreprise} nom du candidat  ${widget.candidature.nomInfluenceur} Motivation  ${widget.candidature.motivation} Cliquez sur le bouton en bas de la page pour consulter le CV');
         
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
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
                      color: style.bgColor,
                      
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                     widget.candidature!.photo,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
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
                          widget.candidature.libelleOffre,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nom de l\'entreprise:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.candidature.nomEntreprise,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
              
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nom du Candidat:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.candidature.nomInfluenceur,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Motivation:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      widget.candidature.motivation,
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: DelayedAnimation(
                          delay: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: red,
                              padding: const EdgeInsets.symmetric(horizontal:50),
                            ),
                            child: const Text("Voir CV"),
                            onPressed: () async {
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPDF(url: widget.candidature.fileUrl)));
                              
                            },
                          ),
                        ),
                      ),
              
            ],
          ),
        )
        ),
      ),
    );
  }
}
