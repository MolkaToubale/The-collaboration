// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_dashbord.dart';


import 'package:url_launcher/url_launcher.dart';

import '../../constants/style.dart';

import '../../models/candidature.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/candidature_widget.dart';



class ProfilInfluenceurDetails extends StatefulWidget {
  var influenceur;
   ProfilInfluenceurDetails({
    Key? key,
    required this.influenceur,
  }) : super(key: key);

  @override
  _ProfilInfluenceurDetailsState createState() => _ProfilInfluenceurDetailsState();
}

class _ProfilInfluenceurDetailsState extends State<ProfilInfluenceurDetails> {

 List<CandidatureModel> candidatures = [];
  List<CandidatureModel> candidaturesAcceptees = [];
  List<CandidatureModel> candidaturesEnAttentes = [];
 //Méthodes pour récupérer la liste des candidatures
  fetchCandidatures() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('Candidatures')
        .where('idInfluenceur',
            isEqualTo: widget.influenceur.id)
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
            isEqualTo: widget.influenceur.id).where('reponse',isEqualTo:'Acceptee')
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
            isEqualTo: widget.influenceur.id).where('reponse',isEqualTo:'En attente')
        .get();

    for (var data in qn.docs) {
      candidaturesEnAttentes.add(CandidatureModel.fromMap(data.data()));
    }

    setState(() {});
  }
@override
  void initState() {
    fetchCandidatures();
    fetchCandidaturesAcceptees();
    fetchCandidaturesEnAttente();
    super.initState();
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
         actions: [
          
          GestureDetector(
            child: Icon(
              Icons.no_accounts_outlined,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
              showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: const Text("Suppression du compte"),
                            content: const Text(
                        "Vous êtes sur le point de supprimer ce profil, l'utilisateur perdera l'accés à son compte",
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                       context.read<UserProvider>().deleteUser(widget.influenceur.id, widget.influenceur.statut);
                        Fluttertoast.showToast( msg: "Suppressionn du Profil avec succés");
                       Navigator.push(context,MaterialPageRoute(builder: (context) => AllUsersScreen()),);

                    },
                     child: const Text('Confirmer'),
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
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        title: Text(widget.influenceur.nomPrenom,style: TextStyle(color: red),)

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
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                border: Border.all(
                                    color: red.withOpacity(.2), width: 3)),
                            child: ClipOval(
                              child: Image.network(
                                widget.influenceur.photo,
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
                                    'Acceptées',
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
                        widget.influenceur.nomPrenom,
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
                        widget.influenceur.statut,
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
                        widget.influenceur.bio,
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
      
      final Uri url = Uri.parse('tel:${widget.influenceur.tel}') ;
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
         widget.influenceur.tel,
          style: const TextStyle(
            color: blue,
            fontSize: 15,
          ),
        ),
      ],
    ),
  ),
),
                    const SizedBox(height: 14),
                    
                    // higlights
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.influenceur.insta) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
                child: socialMediaIcon(title: 'Instagram', url: 'assets/images/instagram.png'),
),

GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.influenceur.linkedin) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
              child: socialMediaIcon(title: 'LinkedIn', url: 'assets/images/linkedIn.png'),
),
GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.influenceur.facebook) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
              child:  socialMediaIcon(
                              title: 'Facebook', url: 'assets/images/facebook.png'),
),

GestureDetector(
                                 onTap: () async {
   
                         final Uri url = Uri.parse(widget.influenceur.youtube) ;
                      if (await canLaunchUrl(url)) {
                       await launchUrl(url);
    }                  else {
      throw 'Could not launch $url';
    }
                        },
              child:  socialMediaIcon(
                              title: 'Youtube', url: 'assets/images/youtube.png'),
),


                          
                         
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                   

                    // grid post
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: candidaturesAcceptees.length==0?  Center(child: Text("Aucune publication pour le moment!",style: style.title.copyWith(fontSize: 13),)) 
                      :GridView(
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
