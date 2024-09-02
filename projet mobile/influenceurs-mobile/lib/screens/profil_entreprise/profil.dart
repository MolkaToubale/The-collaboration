import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/providers/offre_provider.dart';
import 'package:projet/screens/profil_entreprise/candidatures_acceptees.dart';
import 'package:projet/screens/profil_entreprise/settings_entreprise.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/style.dart';
import '../../extra/Messenger/Messenger_ui.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/offre_widget.dart';
import '../authentification/edit_profile.dart';
import '../offres/add_offres_screen.dart';

class ProfilEntreprise extends StatefulWidget {
  const ProfilEntreprise({Key? key}) : super(key: key);

  @override
  _ProfilEntrepriseState createState() => _ProfilEntrepriseState();
}

class _ProfilEntrepriseState extends State<ProfilEntreprise> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100)).then((value) => context
        .read<OffreProvider>()
        .fetchOffres(context.read<UserProvider>().currentUser!.id));
        setState(() {
          
        });
        
  }



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
    var user = context.watch<UserProvider>().currentUser;
    var style = context.watch<ThemeNotifier>();
    setState(() {});

    Widget socialMediaIcon({required String title, required String url}) {
      return Column(
        children: [
          Container(
            
            decoration: const BoxDecoration(
               
                ),
            child: Image.asset(
              url,
              height: 70,
              width: 70,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: style.text18,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        elevation: 1,
        actions: [
          GestureDetector(
            child: Icon(
              Icons.settings,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsEntrepriseScreen()),
              );
            },
          ),
          const SizedBox(
            width: 15,
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
          'Vous êtes à présent dans votre profil, vous pouvez accéder aux paramétres grâce au bouton se trouvant en haut de la page.Vous avez au total ${context.read<OffreProvider>().userOffres.length.toString()} offres , ${context.read<OffreProvider>().userAnciennesOffres.length.toString()} anciennes offres ${context.read<OffreProvider>().userOffresEnCours.length.toString()} offres en cours. Votre nom d\'utilisateur est ${user!.nomPrenom}, vous êtes sous le statut d\'entreprise, votre biographie est ${user.bio},votre numéro de téléphone est ${user.tel} . Grâce au premier bouton rectangulaire vous pouvez modifier vos données personnelles .le deuxième  vous permettra d\'ajouter une nouvelle offre, le troisième vous permettra de consulter les candidatures que vous avez acceptées et le quatrième bouton vous permettra d\'accéder à votre messagerie. Les icones des réseaux sociaux vous permettront d\'accéder à vos réseaux sociaux. Votre profil contient également toutes les offres que vous avez publié');

     
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
    
  },
),
          const SizedBox(
            width: 15,
          ),
        ],

        title: Image.asset(
          'images/logoGris.png',
          height: 50,
        ),

        // centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                    color: red.withOpacity(.2), width: 3)),
                            child: ClipOval(
                              child: Image.network(
                                user!.photo,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    context
                                        .read<OffreProvider>()
                                        .userOffres
                                        .length
                                        .toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Offres',
                                    style: style.text18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    context
                                        .read<OffreProvider>()
                                        .userAnciennesOffres
                                        .length
                                        .toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Anciennes',
                                    style: style.text18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Column(
                                children: [
                                  Text(
                                    context
                                        .read<OffreProvider>()
                                        .userOffresEnCours
                                        .length
                                        .toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'En cours',
                                    style: style.text18,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer()
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // nom
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        user.nomPrenom,
                        style: style.text18.copyWith(
                          // color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    //statut
                    const SizedBox(
                      height: 4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        user.statut,
                        style: style.text18.copyWith(
                          color: red,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // bio
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        user.bio,
                        style: style.text18.copyWith(
                          // color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse('tel:${user.tel}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.phone,
                              color: style.invertedColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              user.tel,
                              style: const TextStyle(
                                color: blue,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //Bouttons
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ProfileButton(
                            text: 'Modfier Profil',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          ProfileButton(
                            text: 'Ajouter Offre',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddOffreScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ProfileButton(
                            text: 'Candidtures acceptées',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CandidaturesAcceptees()),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          //ProfileButton(text: 'Add Shop'),
                          const SizedBox(width: 8),
                          ProfileButton(
                            text: 'Messagerie',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MessengerUI()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // higlights
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(user.insta);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: socialMediaIcon(
                                title: 'Instagram',
                                url: 'images/instagram.png'),
                          ),

                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(user.linkedin);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: socialMediaIcon(
                                title: 'LinkedIn', url: 'images/linkedIn.png'),
                          ),

                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(user.facebook);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: socialMediaIcon(
                                title: 'Facebook', url: 'images/facebook.png'),
                          ),

                          GestureDetector(
                            onTap: () async {
                              final Uri url = Uri.parse(user.youtube);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: socialMediaIcon(
                                title: 'Youtube', url: 'images/youtube.png'),
                          ),

                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    //grid view
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 5,
                        ),
                        children: context
                            .read<OffreProvider>()
                            .userOffres
                            // .where((offre) => offre.idEntreprise == user.id)
                            .map((offre) => OffreWidget(
                                  offre: offre,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: style.bgColor,
            border: Border.all(
              color: style.invertedColor.withOpacity(.2),
              width: 0.5,
            ),
            boxShadow: defaultShadow,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              text,
              style: style.text18.copyWith(
                fontWeight: FontWeight.w600,
                // color: black,
                // fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
