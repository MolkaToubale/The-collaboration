import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/constants/style.dart';
import 'package:provider/provider.dart';

import '../../extra/service/logic_service.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/validation.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/delayed_animation.dart';

class ModifyPassword extends StatefulWidget {
  const ModifyPassword({super.key});

  @override
  State<ModifyPassword> createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController=TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
   confirmNewPasswordController.dispose();
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
      var user = context.watch<UserProvider>().currentUser!;
      var style = context.watch<ThemeNotifier>();
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
    if (oldPasswordController.text==""||newPasswordController.text==""||confirmNewPasswordController.text=='null') {
      if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
         await speak(
          'Formulaire de modification de votre mot de passe .Veuillez indiquer votre ancien mot de passe une fois et votre nouveau mot de passe deux fois ensuite Cliquez sur le premier bouton pour confirmer la modification du mot de passe ou bien sur le deuxième bouton  pour annuler la modification.');

     
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
          'Formulaire de modification de votre mot de passe Vérifier les mots de passe que vous avez saisis ensuite Cliquez sur le premier bouton  pour confirmer la modification de votre mot de passe ou bien sur le deuxième bouton  pour annuler la modification.');

     
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
                      child:DelayedAnimation(
                            delay: 500,
                            child: Text(
                              "Modification du mot de passe",
                              style: GoogleFonts.poppins(
                                color: red,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                            hint: 'Ancien Mot de Passe',
                            label: "Ancien Mot de Passe",
                            leading: Icons.person,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: oldPasswordController,
                            validator: _validateOldPassword,
                            focus: FocusNode()),
                          ),
                          
                          const SizedBox(height: 10),
                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Nouveau Mot de passe',
                            label: "Nouveau Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                           controller: newPasswordController,
                           validator: validatePassword,
                            focus: FocusNode()),
                          ),
                           
                          const SizedBox(height: 10),
                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Confirmer Nouveau Mot de passe',
                            label: "Confirmer Nouveau Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                           controller: confirmNewPasswordController,
                           validator: _validateConfirmPassword,
                            focus: FocusNode()),
                          ),
                          
                        ],
                      ),
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
                              setState(() {
                                 loading = true;
                              });
                          
                               //Création d'une map avec les données saisies
                          Map<String, dynamic> dataToUpdate = {
                            'password': Scrypt.crypt(newPasswordController.text),
                           
                          };
                          //Modifier les données dans la collection Firestore
                          context.read<UserProvider>().updateInfo(dataToUpdate);
                          setState(() {});
                           Fluttertoast.showToast( msg: "Modification du Mot De Passe avec succés");
                          Navigator.pop(context);
                        }

                             },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              const SizedBox(width: 10),
                              Text('CONFIRMER',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ],
                          )),
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
                            Navigator.pop(context);
                             
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                              const SizedBox(width: 10),
                              Text('ANNULER',
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

  String? _validateOldPassword(String? value) {
    var user = context.read<UserProvider>().currentUser;
    var crypted=Scrypt.crypt(value!);
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez taper votre ancien Mot De Passe !';
    }
    if (crypted != user!.password) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Ancien Mot De Passe Incorrect!';
    }
    return null;
  }

   String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != newPasswordController.text) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}