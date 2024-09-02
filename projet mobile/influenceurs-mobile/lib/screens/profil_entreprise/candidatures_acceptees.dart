import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:projet/widgets/candidature_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/style.dart';
import '../../models/candidature.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';



class CandidaturesAcceptees extends StatefulWidget {
  const CandidaturesAcceptees({super.key});

  @override
  State<CandidaturesAcceptees> createState() => _CandidaturesAccepteesState();
}

class _CandidaturesAccepteesState extends State<CandidaturesAcceptees> {
 
  List<CandidatureModel> candidatures = [];
  

  fetchCandidatures() async {
   try {
         QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('Candidatures').where('idEntreprise', isEqualTo:NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!.id )
      .where('reponse',isEqualTo:'Acceptee').get();
  for (var doc in querySnapshot.docs) {
       CandidatureModel candidature = CandidatureModel.fromMap(doc.data());
       candidatures.add(candidature);    
     }
    setState(() {});

   } catch (e) {
     log('erreur candidatures acceptees $e');
   }
     
  }


  @override
  void initState() {
  
    fetchCandidatures();
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
    var style = context.watch<ThemeNotifier>();
    var user = context.watch<UserProvider>().currentUser;
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
        title: Text("Candidatures acceptées", style: style.title.copyWith(fontSize: 20)),

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
          'Cette interface vous permet de visualiser les candidatures que vous avez acceptées à savoir  ${candidatures.length.toString()} candidatures acceptées. Veuillez cliquer sur chacune des candidatures pour visualiser ses détails. Pour revenir en arrière veuillez cliquer sur la flêche à gauche en haut de la page.');
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
        body: Container(
          
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              
              Expanded(
                child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: candidatures.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 10),
                        itemBuilder: (_, index) {
                         
                             return CandidatureWidget(candidature: candidatures[index]);
                          
                         
                        },
                      ),
              ),
            ],
          ),
        ),
        
        
    );
  }

}