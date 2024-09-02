// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/style.dart';
import '../../models/offre.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/offre_widget.dart';

class ProfilEntrepriseDetails extends StatefulWidget {
  var entreprise;
  ProfilEntrepriseDetails({
    Key? key,
    required this.entreprise,
  }) : super(key: key);

  @override
  _ProfilEntrepriseDetailsState createState() => _ProfilEntrepriseDetailsState();
}

class _ProfilEntrepriseDetailsState extends State<ProfilEntrepriseDetails> {
 

  List<OffreModel> offres = [];
  List<OffreModel> anciennesOffres = [];
  List<OffreModel> offresEnCours = [];

//Méthodes pour récupérer la liste des offres
  fetchOffres() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('offres')
        .where('idEntreprise',
            isEqualTo: widget.entreprise.id)
        .get();

    for (var data in qn.docs) {
      offres.add(OffreModel.fromMap(data.data()));
    }

    setState(() {});
  }
   fetchAnciennesOffres() async {
   QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
  .collection('offres')
  .where('idEntreprise', isEqualTo: widget.entreprise.id)
  .where('dateFin', isLessThan: DateTime.now().millisecondsSinceEpoch)
  .get();
    for (var data in qn.docs) {
      anciennesOffres.add(OffreModel.fromMap(data.data()));
     
    }

    setState(() {});
  }
  

 fetchOffresEnCours() async {
   QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
    .collection('offres')
    .where('idEntreprise',
        isEqualTo: widget.entreprise.id)
    .where('dateFin', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
    .get();
    for (var data in qn.docs) {
      offresEnCours.add(OffreModel.fromMap(data.data()));
    }

    setState(() {});
  }
  @override
  void initState() {
    fetchOffres();
    fetchOffresEnCours();
    fetchAnciennesOffres();

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
        elevation: 0,
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
        title: Image.asset(
        'images/logoGris.png', 
        height: 50,
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
          'Vous êtes à présent dans le profil de ${widget.entreprise.nomPrenom}, vous pouvez retourner en arrière grâce à la flêche se trouvant en haut de la page.${widget.entreprise.nomPrenom} a au total ${offres.length.toString()} offres, ${anciennesOffres.length.toString()} anciennes offres et ${offresEnCours.length.toString()} offre en cours. son nom d\'utilisateur est ${widget.entreprise.nomPrenom}, ce compte est sous le statut d\'entreprise, sa biographie est ${widget.entreprise.bio},son numéro de téléphone est ${widget.entreprise.tel}. Les icones des réseaux sociaux vous permettront d\'accéder à ses réseaux sociaux. Son profil contient également toutes ses offres publiées');

     
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
                                widget.entreprise.photo,
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
                                    offres.length.toString(),
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
                                    anciennesOffres.length.toString(),
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
                                    offresEnCours.length.toString(),
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
                       widget.entreprise.nomPrenom,
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
                        widget.entreprise.statut,
                        style: style.text18.copyWith(
                           color: red,
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    //bio
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.entreprise.bio,
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
      
      final Uri url = Uri.parse('tel:${widget.entreprise.tel}') ;
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
          widget.entreprise.tel,
          style: const TextStyle(
            color: blue,
            fontSize: 15,
          ),
        ),
      ],
    ),
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
   
                         final Uri url = Uri.parse(widget.entreprise.insta) ;
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
   
                         final Uri url = Uri.parse(widget.entreprise.linkedin) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
               child:socialMediaIcon(
                              title: 'LinkedIn', url: 'images/linkedIn.png'),
),

GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.entreprise.facebook) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
               child:socialMediaIcon(
                              title: 'Facebook', url: 'images/facebook.png'),
),

GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.entreprise.youtube) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
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
                   
                    // grid post
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child:offres.length==0 ?  Center(child: Text("Aucune offre pour le moment!",style: style.title.copyWith(fontSize: 13),)) 
                       : GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 5,
                        ),
                        children: offres
                           
                            .map((offre) => OffreWidget(offre: offre))
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
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}
