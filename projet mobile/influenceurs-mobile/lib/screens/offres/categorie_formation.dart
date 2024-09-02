import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../constants/style.dart';

import '../../models/offre.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../widgets/offre_widget.dart';
import '../search_screen.dart';

class CategorieFormation extends StatefulWidget {
  const CategorieFormation({super.key});

  @override
 CategorieFormationState createState() =>CategorieFormationState();
}

class CategorieFormationState extends State<CategorieFormation> {
  List<OffreModel> offresFormation = [];

  Future<void> fetchOffresFormation() async {
    // await Future.delayed(Duration(milliseconds: 50));
    // setState(() {});
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('offres')
        .where('categories', arrayContains: 'Education et Formation')
        .where('dateFin',isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .get();

    for (var doc in querySnapshot.docs) {
      OffreModel offreFormation = OffreModel.fromMap(doc.data());
      offresFormation.add(offreFormation);
      // await Future.delayed(const Duration(milliseconds: 1000));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchOffresFormation();
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
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Education et Formation", style: style.title.copyWith(fontSize: 20)),
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
          await speak('Cette interface vous permet de visualiser toutes les offers appartenant à la catégorie Formation et éducation pour lesquelles vous pouvez postuler à savoir  ${offresFormation.length.toString()} offres. Vous pouvez également effectuer une recherche à partir de la barre de recherche ou bien retourner à l\'interface d\'Accueil grâce à la flêche située à gauche en hait de la page. ');

     
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
    }
  
),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  readOnly: true,
                  style: style.text18,
                  decoration: InputDecoration(
                      // fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: red,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Effectuez votre recherche par ici",
                      hintStyle: style.text18
                          .copyWith(color: style.invertedColor.withOpacity(.8)),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: red,
                      )),
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => const SearchScreen())),
                ),
              ),
            ),
            Expanded(
                child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: offresFormation.length,
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10),
              itemBuilder: (_, index) {
                return OffreWidget(offre: offresFormation[index]);
              },
            )),
          ],
        ),
      ),
    );
  }
}
