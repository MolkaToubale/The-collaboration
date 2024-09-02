import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:projet/extra/service/logic_service.dart';
import 'package:projet/providers/candidature_provider.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:projet/widgets/delayed_animation.dart';
import 'package:provider/provider.dart';
import '../../constants/loading.dart';
import '../../constants/style.dart';
import '../../models/candidature.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/candidature_service.dart';
import '../../services/validation.dart';
import 'dart:io';
import '../../widgets/view.dart';

class AddCandidature extends StatefulWidget {
  var offre;
  AddCandidature(this.offre, {super.key});

  @override
  State<AddCandidature> createState() => _AddCandidatureState();
}

class _AddCandidatureState extends State<AddCandidature> {
  String url = "";
  Future<String> uploadDataToFirebase() async {
  // Sélectionner le fichier PDF
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  
  // Vérifier si un fichier a été sélectionné
  if (result == null || result.files.isEmpty) {
    Fluttertoast.showToast(msg:"Aucun fichier sélectionné.");
  }

  // Obtenir le chemin du fichier sélectionné
  String filePath = result!.files.single.path!;
  
  // Vérifier si le fichier est un PDF
  if (!filePath.toLowerCase().endsWith('.pdf')) {
   Fluttertoast.showToast(msg:"Le fichier sélectionné n'est pas un PDF.");
  }else{
    Fluttertoast.showToast(msg:"PDF sélectionné avec succés.");
  }
  
  File pickedFile = File(filePath);
  var file = pickedFile.readAsBytesSync();
  String name = DateTime.now().millisecondsSinceEpoch.toString();
  
  // Upload du fichier vers Firebase Storage
  var pdfFile = FirebaseStorage.instance.ref().child(name).child("/.pdf");
  UploadTask task = pdfFile.putData(file);
  TaskSnapshot snapshot = await task;
  String url = await snapshot.ref.getDownloadURL();

  return url;
}




  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final afficheController = TextEditingController();
  final motivationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  void dispose() {
    motivationController.dispose();
    afficheController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CandidatureProvider>(context);
    var style = context.watch<ThemeNotifier>();
    final candidature = provider.candidatures;

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

    var user = NavigationService.navigatorKey.currentContext!
        .watch<UserProvider>()
        .currentUser;

    return loading
        ? const Loading()
        : Scaffold(
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
              title: Text("Postuler pour une offre",
                  style: style.title.copyWith(fontSize: 20)),
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
      if (motivationController.text=="") {
         await speak(
          'Formulaire de candidature  Veuillez taper votre motivation . cliquez sur le premier bouton pour séléctionner votre CV , sur le deuxième pour consulter le CV sélectionné et le troisième bouton pour envoyer votre candidature pour l\'offre ${widget.offre.libelle}.Bonne chance.');
      }else{
         await speak(
          'Formulaire de candidature  Votre motivation  ${motivationController.text} cliquez sur le premier bouton pour séléctionner votre CV , sur le deuxième pour consulter le CV sélectionné et le troisième bouton pour envoyer votre candidature pour l\'offre ${widget.offre.libelle}.Bonne chance.');
      }
     
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
            body: Form(
              key: _formKey,
              child: DelayedAnimation(
                delay: 200,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: [
                       
                      const SizedBox(height: 20),
                      DelayedAnimation(
                        delay: 200,
                        child: Padding(
                          padding: EdgeInsets.only(right:275),
                          child: Text("Motivation",style: TextStyle(color: red, fontSize: 17),)
                          ),
                      ),
                      SizedBox(height: 10,),
                      DelayedAnimation(
                        delay: 200,
                        child: TextFormField(
                          controller: motivationController,
                          validator: validateNotEmpty,
                          style: style.text18.copyWith(

                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLength: 300,
                         
                          decoration: InputDecoration(

              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText:"Motivation",
              prefixIcon: Icon(Icons.edit, color: red),
              hintStyle: style.text18
                  .copyWith(color: style.invertedColor.withOpacity(0.4)),
              contentPadding:
                  const EdgeInsets.only(left: 10, bottom: 15, top: 15),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: blue, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:style.invertedColor.withOpacity(0.3),
                    width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: blue, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              errorStyle:
                  text18white.copyWith(fontSize: 14, color: Colors.redAccent),
            ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          DelayedAnimation(
                            delay: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                backgroundColor: red,
                                padding: const EdgeInsets.all(15),
                              ),
                              child: Text("Selectionner un fichier"),
                              onPressed: () async {
                                url = await uploadDataToFirebase();
                                
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      DelayedAnimation(
                        delay: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.symmetric(vertical:15,horizontal:50 ),
                          ),
                          child: Text("Voir fichier"),
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewPDF(url: url)));
                           
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      DelayedAnimation(
                        delay: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: red,
                              padding: const EdgeInsets.symmetric(vertical:15,horizontal:35 ),
                            ),
                            onPressed: () async {
                              try {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = true;
                                  });

                                  CandidatureModel candidature =
                                      CandidatureModel(
                                    photo: user!.photo,
                                    affiche: widget.offre.affiche,
                                    id: generateId2(),
                                    motivation: motivationController.text,
                                    libelleOffre: widget.offre.libelle,
                                    idOffre: widget.offre.id,
                                    idInfluenceur: user.id,
                                    nomInfluenceur: user.nomPrenom,
                                    idEntreprise: widget.offre.idEntreprise,
                                    nomEntreprise: widget.offre.nomEntreprise,
                                    fileUrl: url,
                                  );

                                  CandidatureService.addcandidature(candidature)
                                      .then((value) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: "Candidature avec succés");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomNavController()));

                                      print(
                                          'Les informations de cette candidature ont été sauvegardés avec succés');
                                    } else {
                                      return;
                                    }
                                  });
                                }
                              } catch (e) {
                                print(
                                    'Une erreur est survenue lors de la sauvegarde: $e');
                              }
                            },
                            child: const Text('       Postuler       ')),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DelayedAnimation(
                        delay: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical:15,horizontal:40 ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '       Annuler       ',
                              style: TextStyle(color: Colors.black),
                            )),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
  }
}




