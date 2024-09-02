import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/extra/service/logic_service.dart';
import 'package:projet/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/delayed_animation.dart';

class SocialMediaLinks extends StatefulWidget {
  const SocialMediaLinks({super.key});

  @override
  State<SocialMediaLinks> createState() => _SocialMediaLinksState();
}

class _SocialMediaLinksState extends State<SocialMediaLinks> {

  final instgramController = TextEditingController();
  final linkedinController = TextEditingController();
  final youtubeController = TextEditingController();
  final facebookController = TextEditingController();



  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();

  bool loading = false;


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
     var user = context.read<UserProvider>().currentUser;
     instgramController.text = user!.insta;
     linkedinController.text = user.linkedin;
     youtubeController.text  = user.youtube;
     facebookController.text = user.facebook;
   
     super.initState();
   }
 


  @override
  Widget build(BuildContext context) {
      var style = context.watch<ThemeNotifier>();
       var user = context.watch<UserProvider>().currentUser!;

       setState(() {});
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
          'Formulaire de modification des liens de vos réseaux sociaux  le premier champs correspond au lien de votre instagram ${instgramController.text}, le deuxième lien correspond au lien de votre compte LinkedIn ${linkedinController.text}, le troisième champs correspond au lien de votre chaîne Youtube ${youtubeController.text} et pour finir le quatrième champs correspond au lien de votre compte ou page Facebook ${facebookController.text} Cliquez sur le premier bouton  pour confirmer la modification des liens ou bien sur le deuxième bouton  pour annuler la modification.');

     
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
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
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
                              "Réseaux Sociaux",
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
                              "Veuillez saisir les liens de vos réseaux sociaux",
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

                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Lien de votre compte Instagram',
                            label: "Instagram",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.visiblePassword,
                            controller: instgramController,
                            validator: validateLink,
                            focus: FocusNode()),
                          ),
                          const SizedBox(height: 10),
                           DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Lien de votre compte LinkedIn',
                            label: "LinkedIn",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.visiblePassword,
                            controller: linkedinController,
                            validator: validateLink,
                            focus: FocusNode()),
                          ),

                          const SizedBox(height: 10),

                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Lien de votre chaîne Youtube',
                            label: "Youtube",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.visiblePassword,
                            controller: youtubeController,
                            validator: validateLink,
                            focus: FocusNode()),
                          ),

                           const SizedBox(height: 10),
                           DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Lien de votre compte Facebook',
                            label: "Facebook",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.visiblePassword,
                            controller: facebookController,
                            validator: validateLink,
                            focus: FocusNode()),
                          ),
                          
                         
                         
                    const SizedBox(height: 40),
                    DelayedAnimation(
                      delay: 200,
                          child: ElevatedButton(
                             style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.all(13),
                          ),
                            onPressed: () async {
                               if (_formKey.currentState!.validate()) {
                          //Création d'une map avec les données saisies
                          Map<String, dynamic> dataToUpdate = {
                            'insta': instgramController.text,
                            'facebook': facebookController.text,
                            'linkedin': linkedinController.text,
                            'youtube': youtubeController.text,
                            
                          };
                          //Modifier les données dans la collection Firestore
                          context.read<UserProvider>().updateInfo(dataToUpdate);
                          setState(() {});
                          Navigator.pop(context);
                        }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.link),
                                const SizedBox(width: 10),
                                Text('CONFIRMER',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          
                    ),
                    
                     const SizedBox(height: 20),
                    DelayedAnimation(
                      delay: 3000,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.all(13),
                          ),
                          onPressed: () async {
                           Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.stop),
                              const SizedBox(width: 10),
                              Text('ANNULER',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          )),
                    ),
                 ],
                        )),
                  ],
                ),
              ),
            ),
          );
  }

String? validateLink(String? value) {
  if (value == null || value.isEmpty) {
    return 'Veuillez entrer un lien';
  }
  if (!value.startsWith('https')) {
    return 'Le lien doit commencer par https';
  }
  return null;
}


}
