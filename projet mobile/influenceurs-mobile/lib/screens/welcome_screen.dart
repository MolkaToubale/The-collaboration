import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:projet/widgets/delayed_animation.dart'; //Importation du fichier d'animation
import 'package:provider/provider.dart';
import '../constants/style.dart';
import 'authentification/login_screen.dart';
import 'package:projet/screens/authentification/signUp_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
 
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
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
              elevation: 0,
             backgroundColor: style.panelColor.withOpacity(0),
              
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
         await speak(' Bienvenu à The collaboration, l\'univers des collaborations. Cliquez sur le premier bouton pour vous inscrire à l\'application ou le deuxième bouton pour vous connecter');
     
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
          child: FutureBuilder<bool>(
              future: context.read<UserProvider>().checkLogin(),
              builder: (context, snapshot) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                     
                       DelayedAnimation(delay: 500,child: Container(
                          height: 100,
                          child: Image.asset('images/logoGris.png'),
                        )),
    
                      DelayedAnimation(
                          delay: 500,
                          child: SizedBox(
                            height: 200,
                            child: Image.asset('images/logo.png'),
                          )),
    
                      DelayedAnimation(
                          delay: 500,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top: 30,
                              bottom: 20,
                            ),
                            child: Text(
                              "Rejoignez la première plateforme de collaboration entre entreprises et influenceurs!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          )),
                      //Créer un compte
                      DelayedAnimation(
                          delay: 500,
                          child: SizedBox(
                            width: double
                                .infinity, //Pour que le boutton occupe la largeur de toute la page avec une marge
    
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: red,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(13),
                              ),
                              child: const Text('S\'INSCRIRE'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp_screen(),
                                  ),
                                );
                              },
                            ),
                          )),
    
                      //Se Connecter
    
                      DelayedAnimation(
                          delay: 500,
                          child: SizedBox(
                            width: double
                                .infinity, //Pour que le boutton occupe la largeur de toute la page avec une marge
    
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: red,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.all(13),
                              ),
                              child: const Text('SE CONNECTER'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login_screen(),
                                  ),
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                );
              })),
    ); //Pour scroller le contenu à l'intérieur de la page et ne pas avoir de problème de dépassement
  }
}
