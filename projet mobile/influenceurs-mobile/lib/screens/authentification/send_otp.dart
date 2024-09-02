import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/constants/style.dart';
import 'package:projet/models/user.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:provider/provider.dart';

import 'otp_screen.dart';

class SendOTP extends StatefulWidget {
  const SendOTP({Key? key}) : super(key: key);

  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  TextEditingController emailController = TextEditingController();
  EmailOTP myauth = EmailOTP();

   List<UserModel>comptesExistants=[];
    //Méthodes pour récupérer une liste d'utilisateurs
 fetchUsers(String? value) async {
  final emailQuery = FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: value);

  QuerySnapshot<Map<String, dynamic>> emailQn = await emailQuery.get();

  for (var data in emailQn.docs) {
    comptesExistants.add(UserModel.fromMap(data.data()));
  }

  setState(() {});
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: red,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        title:Text('Mot de passe oublié? ',style: style.title.copyWith(color: red,fontSize: 22),),
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
          'Vous avez oublié votre mot de passe? Pas de soucis veuillez saisir l\'adresse mail associée au compte que vous voulez récupérer puis valider l\'envoi pour recevoir un code de réinitialisation.');
     
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                "https://img.freepik.com/vecteurs-libre/inscription-newsletter-passe-temps-moderne-lecture-nouvelles-ligne-courrier-internet-publicite-spam-lettre-phishing-element-conception-idee-escroquerie_335657-3546.jpg?w=740&t=st=1683733347~exp=1683733947~hmac=28e5f6cc4f5740a77e84e750dac273229f2f99b8c48efd883291377999c77835",
                height: 350,
              ),
            ),
            const SizedBox(
              height: 60,
              child: Text(
                "Veuillez entrer votre adresse mail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.mail,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () async {
                           await fetchUsers(emailController.text);
                           log(comptesExistants.length.toString());
                           try {
                             if (comptesExistants.length!=0) {
                                   myauth.setConfig(
                                appEmail: "contact@TheCollaboration.com",
                                appName: "The Collaboration",
                                userEmail: emailController.text,
                                otpLength: 4,
                                otpType: OTPType.digitsOnly);
                            if (await myauth.sendOTP() == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("L'OTP vous a été envoyé"),
                              ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>   OtpScreen(myauth: myauth,)));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Oups, echec d'envoi de l'OTP"),
                              ));
                            }
            }
            else{
            
                           showDialog(
                                   context: context,
                                   builder: (context) => AlertDialog(
                                  title: const Text("Compte inexistant"),
                                  content: const Text(
                                 "Cette adresse mail n'est assignée à aucun compte.",
                                 ),
                               actions: [
                             TextButton(
                            onPressed: () {
                           Navigator.pop(context);
                           
                            } ,
                          child: const Text('OK'),
                    ),
                ],
              ),
              
            );
            
            }
                           } catch (e) {
                             log('erreur lors de l\'envoie de l\'OTP $e');
                           }
                          },
                          icon: const Icon(
                            Icons.send_rounded,
                            color: red,
                          )),
                      hintText: "Adresse email",
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}