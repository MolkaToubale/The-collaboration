import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:projet/models/offre.dart';

import 'package:projet/screens/offres/edit_offre_screen.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';

import '../../constants/style.dart';
import '../../providers/favorite_provider.dart';

import '../../providers/offre_provider.dart';
import '../../providers/theme_notifier.dart';
import '../../widgets/delayed_animation.dart';

class OffreDetailsEntreprisePerso extends StatefulWidget {
  final OffreModel offre;
  const OffreDetailsEntreprisePerso(this.offre, {super.key});

  @override
  State<OffreDetailsEntreprisePerso> createState() =>
      _OffreDetailsEntreprisePersoState();
}

class _OffreDetailsEntreprisePersoState
    extends State<OffreDetailsEntreprisePerso> {
  final FlutterTts flutterTts = FlutterTts();
  speak(String text) async {
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
    final provider = Provider.of<FavoriteProvider>(context);
    var offre = context
        .watch<OffreProvider>()
        .userOffres
        .where((element) => element.id == widget.offre.id)
        .first;
        bool isSpeaking = false;
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundColor: red,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
        ),
        title: Text(
          offre.libelle,
          style: style.title.copyWith(color: red, fontSize: 22),
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
              await speak(
                  'Libellé de l\'offre ${ offre.libelle} description ${offre.description} dernier délai d\'envoi des candidatures  ${DateFormat('dd/MM/yyyy').format(offre.dateFin)} Catégories  ${offre.categories.toString()} publiée par  ${offre.nomEntreprise} Cliquer sur le bouton à gauche pour modifier cette offre ou bien sur le bouton à droite pour la supprimer');
              print('pressed');
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
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                      offre.affiche,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Libellé:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          offre.libelle,
                          style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                    CircleAvatar(
                        backgroundColor: red,
                        child: IconButton(
                            onPressed: () {
                              provider.toggleFavorite(offre);
                            },
                            icon: provider.isExist(offre)
                                ? const Icon(Icons.favorite)
                                : const Icon(Icons.favorite_border))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Description:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      offre.description,
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dernier délai d'envoi des candidatures:",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      DateFormat('EEE, dd/MM/yyyy').format(offre.dateFin),
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Catégorie(s):",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      offre.categories.join(", "),
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Text(
                      "Publiée par: ",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      offre.nomEntreprise,
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Row(
                  children: [
                    DelayedAnimation(
                      delay: 500,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditOffre(offre: offre)));
                          },
                          child: const Text(
                            '  Modifier  ',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DelayedAnimation(
                      delay: 500,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(15),
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Suppression de l'offre"),
                                content: const Text(
                                  "La suppression de l'offre conduit à sa suppression de votre profil cependant elle restera visible dans le profil des influenceurs dont les candidatures pour cette offre ont été acceptées! ",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('offres')
                                          .doc(offre.id)
                                          .delete();
                                      Fluttertoast.showToast(
                                          msg:
                                              "Suppression de l'offre avec succés");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BottomNavController()),
                                      );
                                    },
                                    child: const Text('OK'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Suppression de l'offre annulée");
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Annuler'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Supprimer',
                            style: TextStyle(color: Colors.black),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
