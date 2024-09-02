import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/screens/authentification/delete_profil.dart';
import 'package:projet/screens/authentification/edit_profile.dart';
import 'package:projet/screens/authentification/modify_password.dart';
import 'package:provider/provider.dart';

import '../../../../constants/style.dart';
import '../../../../providers/theme_notifier.dart';
import '../../../../providers/user_provider.dart';
import '../Abonnement/subscription_screen.dart';
import '../authentification/socialMedia_link.dart';

class SettingsEntrepriseScreen extends StatefulWidget {
  const SettingsEntrepriseScreen({Key? key}) : super(key: key);

  @override
  State<SettingsEntrepriseScreen> createState() => _SettingsEntrepriseScreenState();
}

class _SettingsEntrepriseScreenState extends State<SettingsEntrepriseScreen> {


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
    final driver = context.watch<UserProvider>().currentUser!;
    var style = context.watch<ThemeNotifier>();
    var size = MediaQuery.of(context).size;
    Widget detailCard(
        {required BuildContext context,
        required IconData icon,
        required String title,
        Widget? screen,
        bool? switchValue,
        void Function(bool)? onSwitchTap}) {
      var style = context.watch<ThemeNotifier>();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(top: 0),
        child: Card(
          color: style.bgColor,
          elevation: 1,
          child: InkWell(
            onTap: screen == null
                ? null
                : () async {
                    await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => screen);
                  },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: blue.withOpacity(.1)),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white.withOpacity(style.darkMode ? 0.1 : 1),
              ),
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(title, style: style.text18),
                  const Spacer(),
                  if (switchValue != null)
                    CupertinoSwitch(
                        activeColor: blue,
                        value: switchValue,
                        onChanged: onSwitchTap ??
                            (value) {
                              log(title);
                            }),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: style.bgColor,
      appBar:AppBar(
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
        title:Text('Paramètres',style: style.title.copyWith(color: red,fontSize: 22),),
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
          'Vous êtes dans la section Paramètres, vous pouvez basculer le premier bouton bascule pour passer au mode sombre et inversemment, le deuxième bouton vous permettra de passer au formulaire de modification de votre mot de passe, le troisième champs vous permettra de changer les liens de vos réseaux sociaux, le quatrième champs vous permettra de désactiver votre compte, le cinquième champs vous permettra de modifier vos données personnelles , le sixième quant à lui vous permettra de gérer votre abonnement et pour finir le dernier champs vous permettra de vous déconnecter.');

     
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailCard(
                context: context,
                icon: Icons.dark_mode_outlined,
                switchValue: style.darkMode,
                onSwitchTap: (value) =>
                    context.read<ThemeNotifier>().changeDarkMode(value),
                title: "Mode sombre"),
            
            detailCard(
                context: context,
                icon: Icons.password_outlined,
               
               screen:const  ModifyPassword(),
               
                title: "Modifier Mot de Passe"),
                 detailCard(
                               context: context,
                               icon: Icons.link,
                               screen: SocialMediaLinks(),
                  
                               title: "Liens des réseaux sociaux"),

                 
                  detailCard(
                                context: context,
                                icon: CupertinoIcons.minus_circle ,
                                screen: DeleteProfil(),
                   
                                title: "Désactiver mon profil"),
                 detailCard(
                               context: context,
                               icon:Icons.edit,
                               screen: EditProfile(),
                  
                               title: "Modifier mon profil"),
                  detailCard(
                                context: context,
                                icon: CupertinoIcons.creditcard,
                                screen: SubscriptionScreen(),
                   
                                title: "Abonnements"),

                 GestureDetector(
                  onTap: () {
                    context.read<UserProvider>().signOut(context);
                 },
                   child: detailCard(
                                 context: context,
                                 icon: CupertinoIcons.square_arrow_right,

                    
                                 title: "Déconnexion"),
                 ),
                 
                 
                
          ],
        ),
      ),
    );
  }
}
