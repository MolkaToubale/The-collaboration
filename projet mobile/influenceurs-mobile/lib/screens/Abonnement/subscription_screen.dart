import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/models/abonnement.dart';
import 'package:projet/screens/Abonnement/payment_screen.dart';

import 'package:projet/widgets/delayed_animation.dart';
import 'package:provider/provider.dart';
import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
 
  List<AbonnementModel> abonnements = [];

  fetchAbonnement() async {
    
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Abonnements').get();
  for (var doc in querySnapshot.docs) {
       AbonnementModel abonnement = AbonnementModel.fromMap(doc.data());
       abonnements.add(abonnement);
   
    setState(() {});
  }
  log(abonnements.toString());
   }
  

  @override
  void initState() {
  
    fetchAbonnement();
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
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
       
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
          'L\'application dispose à présent de trois types d\'abonnements à savoir un abonnement mensuel à 30 dollars canadiens, un abonement trimestriel à 50 dollars canadiens et un abonnement annuel à 80 dollars canadiens . Pour vous inscrire à un abonnement, il vous suffit de cliquer sur l\'abonnement de votre choix et passer à la phase de paiement de ce dernier.Pour revenir en arrière il vous suffit de cliquer sur la flêche en haut de la page.');

     
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
          child: Column(
            children: [
               Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 15),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 40,
                          horizontal: 30,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedAnimation(
                              delay: 200,
                              child: Text(
                                "Liste des abonnements",
                                style: GoogleFonts.poppins(
                                  color: red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 22),
                            DelayedAnimation(
                              delay: 200,
                              child: Text(
                                "Veuillez choisir votre abonnement.",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: abonnements.length==0 ? Center(child: Text("Pas d'abonnements pour le moment",style: style.title.copyWith(fontSize: 13),)) :
                SingleChildScrollView(
                  child:Column(
                    children: [
                      ...abonnements.map((e) { 
                       
                         return  GestureDetector(
                          onTap: (){
                            showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title:  Text(e.titre),
                            content:  Text(
                       e.description,
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                      
                      Navigator.push(context,MaterialPageRoute(builder: (context) => PaymentScreen(abonnement: e)),);

                    },
                     child: const Text('S\'inscrire'),
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
                           child: Card(
                                           shape: RoundedRectangleBorder(
                                       borderRadius: BorderRadius.circular(10.0),
                                           ),
                                           child: Container(
                                       height: 100.0,
                                       width: 300,
                                       child: Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                         child: Center(
                                           child: Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(
                                                 e.titre,
                                                 style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                               SizedBox(height: 8.0),
                                               Text(
                                                 e.prix,
                                                 style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                           ),
                                         ),
                         );
        
                       
                      }
                        )
                    ],
                  ),
                ),
                   
                  ),
            ],
          ),
            ]
          )
        )
    );
  }
}
