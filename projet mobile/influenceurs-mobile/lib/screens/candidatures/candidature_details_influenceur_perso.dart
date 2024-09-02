import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:projet/providers/candidature_provider.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';

import '../../providers/theme_notifier.dart';
import '../../widgets/delayed_animation.dart';
import '../../widgets/view.dart';

class CandidatureDetailsInfluenceurPerso extends StatefulWidget {
  
  var candidature;
  CandidatureDetailsInfluenceurPerso(this.candidature, {super.key});

  @override
  State<CandidatureDetailsInfluenceurPerso> createState() => _CandidatureDetailsInfluenceurPersoState();
}

class _CandidatureDetailsInfluenceurPersoState extends State<CandidatureDetailsInfluenceurPerso> {

 
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
   final provider=Provider.of<CandidatureProvider>(context);

   
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
                      Navigator.pop(context) ; 
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
          'Libellé de l\'offre ${widget.candidature.libelleOffre} nom de l\'entreprise ${widget.candidature.nomEntreprise} nom du candidat  ${widget.candidature.nomInfluenceur} Motivation  ${widget.candidature.motivation} Cliquez sur le bouton à gauche pour consulter votre CV ou bien sur le bouton à droite pour supprimer votre candidature acceptée');
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
                     widget.candidature!.affiche,
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
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DelayedAnimation(
                              delay:200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: red,
                                  padding: const EdgeInsets.symmetric(horizontal:50),
                                ),
                                child: const Text("Supprimer"),
                                onPressed: () async {
                                  
                               
                              showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: const Text("Suppression de la collaboration"),
                            content: const Text(
                        "La suppression de la collaboration conduit à sa suppression définitive de votre profil ainsi que dans le profil du représentant de l'entreprise ",
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                       
                        provider.deleteCandidature(widget.candidature);
                        Fluttertoast.showToast( msg: "Suppression de la collaboration avec succés");
                       Navigator.push(context,MaterialPageRoute(builder: (context) =>BottomNavController() ),);

                    },
                     child: const Text('OK'),
              ),
               TextButton(
                    onPressed: () {
                       Fluttertoast.showToast( msg: "Suppression de la collaboration annulée");
                       Navigator.pop(context);

                    },
                     child: const Text('Annuler'),
              ),
            ],
          ),
        );



                                  
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              
            ],
          ),
        )
        ),
      ),
    );
  }
}
