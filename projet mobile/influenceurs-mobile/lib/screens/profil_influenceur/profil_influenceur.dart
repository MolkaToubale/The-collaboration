import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/models/candidature.dart';
import 'package:projet/screens/profil_entreprise/settings_entreprise.dart';
import 'package:projet/screens/profil_influenceur/settings_influenceurs.dart';
import 'package:projet/widgets/candidature_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/style.dart';
import '../../extra/Messenger/Messenger_ui.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../authentification/edit_profile.dart';

// import '../authentification/edit_profile.dart';

class ProfilInfluenceur extends StatefulWidget {
  const ProfilInfluenceur({Key? key}) : super(key: key);

  @override
  _ProfilInfluenceurState createState() => _ProfilInfluenceurState();
}

class _ProfilInfluenceurState extends State<ProfilInfluenceur> {

  List<CandidatureModel> candidatures = [];
  List<CandidatureModel> candidaturesAcceptees = [];
  List<CandidatureModel> candidaturesEnAttentes = [];
 //Méthodes pour récupérer la liste des candidatures
  fetchCandidatures() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('idInfluenceur',
            isEqualTo: context.read<UserProvider>().currentUser!.id)
        .get();

    for (var data in qn.docs) {
      candidatures.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }

fetchCandidaturesAcceptees() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('idInfluenceur',
            isEqualTo: context.read<UserProvider>().currentUser!.id).where('reponse',isEqualTo:'Acceptee')
        .get();

    for (var data in qn.docs) {
      candidaturesAcceptees.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }

  fetchCandidaturesEnAttente() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('idInfluenceur',
            isEqualTo: context.read<UserProvider>().currentUser!.id).where('reponse',isEqualTo:'En attente')
        .get();

    for (var data in qn.docs) {
      candidaturesEnAttentes.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }


  // List<Map<String, String>> listPosts = [
  //   {
  //     'image': 'assets/images/post-1.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-2.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-3.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-4.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-5.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-6.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-7.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-8.jpg',
  //   },
  //   {
  //     'image': 'assets/images/post-9.jpg',
  //   },
  // ];


@override
  void initState() {
    fetchCandidatures();
    fetchCandidaturesAcceptees();
    fetchCandidaturesEnAttente();
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
    var user = context.watch<UserProvider>().currentUser;
    var style = context.watch<ThemeNotifier>();
    setState(() {});

    Widget socialMediaIcon({required String title, required String url}) {
      return Column(
        children: [
          Container(
            // height: 74,
            // width: 74,
            // padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                // border: Border.all(
                //   color: secondaryColor,
                // ),
                // borderRadius: BorderRadius.circular(74),
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
      appBar:  AppBar(
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
                MaterialPageRoute(builder: (context) => const SettingsInfluenceurScreen()),
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
          'Vous êtes à présent dans votre profil, vous pouvez accéder aux paramétres grâce au bouton se trouvant en haut de la page.Vous avez au total ${candidatures.length.toString()} candidatures, ${candidaturesAcceptees.length.toString()} candidatures acceptée et ${candidaturesEnAttentes.length.toString()} candidatures en attente. Votre nom d\'utilisateur est ${user!.nomPrenom}, vous êtes sous le statut d\'influenceur, votre biographie est ${user.bio},votre numéro de téléphone est ${user.tel} . Grâce au premier bouton rectangulaire vous pouvez modifier vos données personnelles quant au deuxième il vous permettra d\'accéder à votre messagerie. Les icones des réseaux sociaux vous permettront d\'accéder à vos réseaux sociaux. Votre profil contient également toutes vos candidatures accéptées qui constitueront votre portfolio');

     
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
            // topbar
            // SizedBox(
            //   height: 60,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: Row(
            //       children: [
            //          GestureDetector(
            //            child: Icon(Icons.arrow_back,),
            //            onTap: () {
            //              Navigator.pop(context);
            //            },
            //          ),
            //           const SizedBox(width: 10,),
            //          Text(
            //           user!.nomPrenom,
            //           style: TextStyle(
            //             color: black,
            //             fontWeight: FontWeight.w700,
            //             fontSize: 24,
            //           ),
            //         ),

            //         // Container(
            //         //   height: 8,
            //         //   width: 8,
            //         //   decoration: BoxDecoration(
            //         //     color: Colors.red,
            //         //     borderRadius: BorderRadius.circular(8),
            //         //   ),
            //         //),
            //         const Spacer(),
            //         SvgPicture.asset(
            //           'assets/icons/add.svg',
            //           height: 24,
            //           width: 24,
            //         ),
            //         const SizedBox(width: 24),
            //         SvgPicture.asset(
            //           'assets/icons/menu.svg',
            //           height: 40,
            //           width: 40,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
                                    candidatures.length.toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Candidatures',
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
                                    candidaturesEnAttentes.length.toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'En cours',
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
                                    candidaturesAcceptees.length.toString(),
                                    style: style.text18.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    ' acceptées',
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
                    const SizedBox(height: 4,),
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
                    //tel
                    const SizedBox(height: 4),
                    Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: GestureDetector(
    onTap: () async {
      
      final Uri url = Uri.parse('tel:${user.tel}') ;
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
                    SizedBox(height: 20,),
                    //Bouttons
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          ProfileButton(
                            text: 'Modifier Profil',
                            onPressed: () {
                               Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                         EditProfile()),
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
                                    builder: (context) =>
                                         const MessengerUI()),
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
   
                         final Uri url = Uri.parse(user.insta) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
                child: socialMediaIcon(title: 'Instagram', url: 'images/instagram.png'),
),

GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(user.linkedin) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
                child :socialMediaIcon( title: 'LinkedIn', url: 'images/linkedIn.png'),
),
GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(user.facebook) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
                child :socialMediaIcon(title: 'Facebook', url: 'images/facebook.png'),
),
GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(user.youtube) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
                child :socialMediaIcon(
                              title: 'Youtube', url: 'images/youtube.png'),

),
                          
                          
                          
                          //       const SizedBox(width: 14),
                          //       Column(
                          //         children: [
                          //           Container(
                          //             height: 74,
                          //             width: 74,
                          //             padding: const EdgeInsets.all(4),
                          //             decoration: BoxDecoration(
                          //               border: Border.all(
                          //                 color: secondaryColor,
                          //               ),
                          //               borderRadius: BorderRadius.circular(74),
                          //             ),
                          //             child: const Center(
                          //               child: Icon(Icons.add, size: 40),
                          //             ),
                          //           ),
                          //           const SizedBox(height: 4),
                          //           const Text('New'),
                          //         ],
                          //       ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // tab menu
                    // SizedBox(
                    //   height: 50,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Column(
                    //           children: [
                    //             const Spacer(),
                    //             SvgPicture.asset(
                    //               'assets/icons/post.svg',
                    //               height: 24,
                    //               width: 24,
                    //               color: black,
                    //             ),
                    //             const Spacer(),
                    //             const Divider(
                    //               height: 1,
                    //               thickness: 1,
                    //               color: black,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Column(
                    //           children: [
                    //             const Spacer(),
                    //             SvgPicture.asset(
                    //               'assets/icons/video.svg',
                    //               height: 24,
                    //               width: 24,
                    //             ),
                    //             const Spacer(),
                    //             const Divider(
                    //               height: 1,
                    //               thickness: 1,
                    //               color: white,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Column(
                    //           children: [
                    //             const Spacer(),
                    //             SvgPicture.asset(
                    //               'assets/icons/panduan.svg',
                    //               height: 24,
                    //               width: 24,
                    //             ),
                    //             const Spacer(),
                    //             const Divider(
                    //               height: 1,
                    //               thickness: 1,
                    //               color: white,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Column(
                    //           children: [
                    //             const Spacer(),
                    //             SvgPicture.asset(
                    //               'assets/icons/tag.svg',
                    //               height: 24,
                    //               width: 24,
                    //             ),
                    //             const Spacer(),
                    //             const Divider(
                    //               height: 1,
                    //               thickness: 1,
                    //               color: white,
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // grid post
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: candidaturesAcceptees.length==0? Center(child: Text("Aucune publication pour le moment!",style: style.title.copyWith(fontSize: 13),))
                       : GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 5,
                        ),
                        children: candidaturesAcceptees
                            // .where((offre) => offre.idEntreprise == user.id)
                            .map((candidature) => CandidatureWidget(candidature: candidature))
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
      // bottomNavigationBar: BottomNavigationBar(
      //   onTap: (index) {},
      //   backgroundColor: white,
      //   type: BottomNavigationBarType.fixed,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   items: [
      //     BottomNavigationBarItem(
      //       label: 'home',
      //       icon: SvgPicture.asset(
      //         'assets/icons/home.svg',
      //         width: 24,
      //         height: 24,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'search',
      //       icon: SvgPicture.asset(
      //         'assets/icons/search.svg',
      //         width: 24,
      //         height: 24,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'reels',
      //       icon: SvgPicture.asset(
      //         'assets/icons/instagram-reels.svg',
      //         width: 24,
      //         height: 24,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'reels',
      //       icon: Image.asset(
      //         'assets/icons/shopping-bag.png',
      //         width: 28,
      //         height: 28,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'reels',
      //       icon: Container(
      //         height: 30,
      //         width: 30,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(30),
      //           border: Border.all(
      //             color: black,
      //             width: 2,
      //           ),
      //         ),
      //         child: ClipOval(
      //           child: Image.asset(
      //             'assets/images/avatar.jpg',
      //             height: 30,
      //             width: 30,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
