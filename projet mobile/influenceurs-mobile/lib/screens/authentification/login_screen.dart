import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:projet/extra/service/logic_service.dart';
import 'package:projet/screens/authentification/send_otp.dart';
import 'package:projet/widgets/custom_text_field.dart';
import 'package:projet/widgets/delayed_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../constants/loading.dart';
import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/validation.dart';



class Login_screen extends StatefulWidget {
  const Login_screen({super.key});

  @override
  State<Login_screen> createState() => _Login_screenState();
}

class _Login_screenState extends State<Login_screen> {
  final nameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
    nameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
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
          'Vous êtes sur l\'interface de connexion. Pour vous connecter il suffit de saisir votre adresse mail ou nom d\'utilisateur au niveau du premier champs et votre mot de passe au niveau du deuxième champs ensuite cliquer sur le bouton SE CONNECTER. Si vous avez oublié votre mot de passe vous pouvez le réinitialiser en cliquant sur le lien hypertext Mot de passe oublié situé au-dessous du bouton se connecter ');
     
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
                              "Authentification",
                              style: GoogleFonts.poppins(
                                color: red,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          DelayedAnimation(
                            delay: 2000,
                            child: Text(
                              "Veuillez saisir vos données d'authentification.",
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
                            delay:200,
                            child: CustomTextField(
                            hint: 'Adresse mail ou nom d\'utilisateur',
                            label: "Adresse mail ou nom d'utilisateur",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.name,
                            controller: nameOrEmailController,
                            validator: validateNotEmpty,
                            focus: FocusNode()),
                          ),
                          
                          const SizedBox(height: 10),
                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Mot de passe',
                            label: "Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validator: validateNotEmpty,
                            focus: FocusNode()),
                          ),
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    DelayedAnimation(
                      delay: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: red,
                              padding: const EdgeInsets.all(13),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                 setState(() {
                                   loading = true;
                                });
                                String nameOrEmail = nameOrEmailController.text;
                                String password = Scrypt.crypt(passwordController.text);
                      
                                context
                                    .read<UserProvider>()
                                    .signIn(context,nameOrEmail, password);
                              } else {
                                // setState(() {
                                  loading = false;
                                // });
                              }
                      
                             
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.mail_lock),
                                const SizedBox(width: 10),
                                Text('SE CONNECTER',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ],
                            )),
                      ),
                    ),

                    //houni
                    DelayedAnimation(
                      delay: 200,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>SendOTP() ),
                          );
                        },
                        child: const Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color:red,
                          ),
                        ),
                      ),
                    ),             
                  ],
                ),
              ),
            ),
            
          );
  }
}
