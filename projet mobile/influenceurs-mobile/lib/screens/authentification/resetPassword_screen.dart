
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/constants/style.dart';
import 'package:projet/extra/service/logic_service.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/screens/welcome_screen.dart';
import 'package:projet/services/validation.dart';
import 'package:projet/widgets/custom_text_field.dart';
import 'package:projet/widgets/delayed_animation.dart';
import 'package:provider/provider.dart';

class ResetPassScreen extends StatefulWidget {
  const ResetPassScreen({super.key});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
  final nvpasswordController = TextEditingController();
  final cnpasswordController = TextEditingController();
  final nomController = TextEditingController();
  
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
   nvpasswordController.dispose();
    cnpasswordController.dispose();
    nomController.dispose();
    super.dispose();
  }

  var _obscureText = true;
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
       setState(() {});
    return  Scaffold(
          backgroundColor: style.bgColor,
            appBar: AppBar(
              elevation: 0,
             backgroundColor: style.panelColor.withOpacity(0),
              leading: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                iconSize: 30,
                onPressed: () {
                 Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => WelcomeScreen()),
  
);

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
          'Vous êtes sur l\'interface de réinitialisation du mot de passe. Pour innitialiser votre mot de passe il suffit de saisir votre adresse mail associé à votre compte et saisir votre nouveau mot de passe au niveau du deuxième champs puis saisir une deuxième fois votre mot de passe dans le champs suivant pour le confirmer ensuite cliquer sur le bouton Confirmer en bas de la page. Pour annuler la procédure de réinitialisation du mot de passe il suffit de cliquer sur la croix en haut de la page. ');
     
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
                            delay: 500,
                            child: Text(
                              "Réinitialisation du Mot De Passe",
                              style: GoogleFonts.poppins(
                                color: red,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          DelayedAnimation(
                            delay: 1000,
                            child: Text(
                              "Veuillez saisir votre nouveau Mot de passe",
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
                            delay: 1500,
                            child: CustomTextField(
                            hint: 'Adresse mail',
                            label: "Adresse mail",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.emailAddress,
                            controller: nomController,
                            validator: validateNotEmpty,
                            focus: FocusNode()),
                          ),
                          DelayedAnimation(
                            delay: 1500,
                            child: CustomTextField(
                            hint: 'Nouveau Mot de passe',
                            label: "Nouveau Mot de passe",
                            leading: Icons.person,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: nvpasswordController,
                            validator: validatePassword,
                            focus: FocusNode()),
                          ),
                          
                          const SizedBox(height: 10),
                          DelayedAnimation(
                            delay: 1500,
                            child: CustomTextField(
                            hint: 'Confirmer nouveau Mot de passe',
                            label: "Confirmer nouveau Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: cnpasswordController,
                            validator:_validateConfirmPassword,
                            focus: FocusNode()),
                          ),
                         
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    DelayedAnimation(
                      delay: 3000,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.all(13),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              
                           var querySnapshot = await FirebaseFirestore.instance
                           .collection('users')
                           .where('email', isEqualTo: nomController.text)
                          .get();

                          if (querySnapshot.docs.isNotEmpty) {
                          var documentSnapshot = querySnapshot.docs.first;
                          await documentSnapshot.reference.update({
                          'password': Scrypt.crypt(nvpasswordController.text)
                           });
                            }

                           Fluttertoast.showToast( msg: "Réinitialisation du Mot De Passe avec succés");
                                   Navigator.push(
  context,
  MaterialPageRoute(builder: (context) =>WelcomeScreen())
);
                            } else {
                               Fluttertoast.showToast( msg: "Echec de la réinitialisation du Mot De Passe ");
                                Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => WelcomeScreen()),);
                            }


                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.mail_lock),
                              const SizedBox(width: 10),
                              Text('Confirmer',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          )),
                    ),         
                  ],
                ),
              ),
            ),
            
          );
  }


   String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != nvpasswordController.text) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}
