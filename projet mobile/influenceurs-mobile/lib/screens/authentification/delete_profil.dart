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

class DeleteProfil extends StatefulWidget {
  const DeleteProfil({super.key});

  @override
  State<DeleteProfil> createState() => _DeleteProfilState();
}

class _DeleteProfilState extends State<DeleteProfil> {

  final passwordController = TextEditingController();

  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
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
    if (passwordController.text=="") {
      if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
         await speak(
          'Formulaire de désactivation de votre profil .Veuillez indiquer votre mot de passe ensuite Cliquez sur le premier bouton pour confirmer la désactivation ou bien sur le deuxième bouton  pour annuler la désactivation.');

     
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
    }
    else{
      if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
         await speak(
          'Formulaire de désactivation de votre profil Vérifier le mot de passe que vous avez saisi ensuite Cliquez sur le premier bouton  pour confirmer la désactivation de votre compte ou bien sur le deuxième bouton  pour annuler la désactivation.');

     
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
                              "Désactivation du Profil",
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
                              "Pour supprimer votre profil, veuillez saisir votre Mot De Passe.",
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
                            hint: 'Mot De Passe',
                            label: "Mot De Passe",
                            leading: Icons.person,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validator: _validatePassword,
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
                                setState(() {loading = true;});

                              showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: const Text("Désactivation du compte"),
                            content: const Text(
                        "La désactivation du compte ne le supprimera pas définitivement. Vous perderez l'accés à votre profil mais ce dernier restera visible pour l'administrateur de l\'application uniquement ",
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                       context.read<UserProvider>().deleteUser(user.id, user.statut);
                        Fluttertoast.showToast( msg: "Désactivation du Profil avec succés");
                       Navigator.push(context,MaterialPageRoute(builder: (context) => WelcomeScreen()),);

                    },
                     child: const Text('OK'),
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
                              
                              
                                // context.read<UserProvider>().deleteUser(user.id, user.statut);

    
                             
                             }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.mail_lock),
                              const SizedBox(width: 10),
                              Text('CONFIRMER',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          )),
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
                              const Icon(Icons.mail_lock),
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

String? _validatePassword(String? value) {
    var user = context.read<UserProvider>().currentUser;
    var crypted=Scrypt.crypt(value!);
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez taper votre Mot De Passe actuel !';
    }
    if (crypted != user!.password) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Mot De Passe actuel Incorrect!';
    }
    return null;
  }


}
