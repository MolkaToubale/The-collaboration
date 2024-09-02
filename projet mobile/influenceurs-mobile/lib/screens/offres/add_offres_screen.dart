import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projet/extra/service/logic_service.dart';
import 'package:projet/screens/Abonnement/subscription_screen.dart';

import 'package:projet/screens/profil_entreprise/profil.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:projet/widgets/custom_text_field.dart';
import 'package:projet/widgets/delayed_animation.dart';
import 'package:projet/models/user.dart';
import 'package:intl/intl.dart' as p1;
import 'package:provider/provider.dart';
import '../../constants/loading.dart';
import '../../constants/style.dart';
import '../../main.dart';
import '../../models/offre.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/offre_service.dart';
import '../../services/validation.dart';

class AddOffreScreen extends StatefulWidget {
  const AddOffreScreen({super.key});

  @override
  State<AddOffreScreen> createState() => _AddOffreScreenState();
}

class _AddOffreScreenState extends State<AddOffreScreen> {
  List<OffreModel> offres = [];
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final nomController = TextEditingController();
  final descController = TextEditingController();
  final afficheController = TextEditingController();
  final TextEditingController _dateDebut = TextEditingController();
  final TextEditingController _dateFin = TextEditingController();
  late DateTime dateDebut;
  late DateTime dateFin;
  File? _pickedImage;
  final List<String> items = [
    'Beauté et Bien-être',
    'Gastronomie',
    'Photographie',
    'Sport',
    'IT',
    'Education et Formation',
    'Paramédical',
    'Autres',
  ];

  List<String> selectedItems = [];

  final _formKey = GlobalKey<FormState>();

  bool loading = false;


   //Méthodes pour récupérer la liste des offres
  fetchOffres() async {
    QuerySnapshot<Map<String, dynamic>> qn = await FirebaseFirestore.instance
        .collection('offres')
        .where('idEntreprise',
            isEqualTo: context.read<UserProvider>().currentUser!.id)
        .get();

    for (var data in qn.docs) {
      offres.add(OffreModel.fromMap(data.data()));
    }

    setState(() {});
  }
  void initState(){
    super.initState();
    fetchOffres();
  }

  @override
  void dispose() {
    descController.dispose();
    afficheController.dispose();
    nomController.dispose();
    _dateDebut.dispose();
    _dateFin.dispose();
    super.dispose();
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
        title: Text("Ajouter une offre",style:style.title.copyWith(fontSize: 20)),
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
          'Formulaire d\'ajout d\'une offre Pour ajouter une offre commencer par séléctionner l\'affiche de l\'offre ensuite vous devez remplir tous les champs requis le premier champs indique le libellé de l\'offre, le deuxième indique la description de l\'offre le troisième indique la date de début de dépôt des candidatures quant au quatrième champs, il indique le dernier délai d\'envoi des candidatures. Pour finir, vous devez indiquer la catégorie à laquelle l\'offre appartient.Cliquez sur le bouton à gauche pour confirmer l\'ajout de l\'offre et en cas d\'annulation vous pouvez cliquer sur le bouton annuler à droite en bas de la page ou bien sur la flêche à droite en haut de la page. ');
     
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: DelayedAnimation(
                          delay: 200,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: red,
                                ),
                                child: CircleAvatar(
                                  radius: 80,
                                  backgroundImage: _pickedImage != null
                                      ? FileImage(_pickedImage!)
                                      : null,
                                  child: _pickedImage == null
                                      ? Image.asset('images/upload.png')
                                      : null,
                                ),
                              ),
                              Positioned(
                                top: 65,
                                right: 2,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amberAccent[400],
                                  ),
                                  child: GestureDetector(
                                    //demande de permission avant d'accéder à la gallerie ou à la caméra

                                    onTap: () async {
                                      Map<Permission, PermissionStatus>
                                          statuses = await [
                                        Permission.storage,
                                        Permission.camera,
                                      ].request();
                                      if (statuses[Permission.storage]!
                                              .isGranted &&
                                          statuses[Permission.camera]!
                                              .isGranted) {
                                        _showPickOptionsDialog(context);
                                      } else {
                                        print(
                                            'Aucune permission n\'a été accordée');
                                      }
                                    },

                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                     

                    DelayedAnimation(
                    child:  CustomTextField(
                    hint: 'Libellé',
                    label: "Libellé de l'offre",
                    leading: Icons.person,
                    isPassword: false,
                    keybordType: TextInputType.name,
                    controller: nomController,
                    validator: validateNotEmpty,
                    focus: FocusNode())
                    , delay: 200),
                      const SizedBox(height: 15),
                      
                      DelayedAnimation(
                      child:CustomTextField(
                    controller: descController,
                    validator: validateNotEmpty,
                    hint: 'Description',
                    label: "Description",
                    leading: Icons.edit,
                    isPassword: false,
                    keybordType: TextInputType.text,
                    focus: FocusNode()),
                 delay: 200),

                      const SizedBox(height: 18),
                     
                       DelayedAnimation(
                        delay: 200,
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("À partir du:",style: style.text18.copyWith(fontWeight: FontWeight.bold,fontSize: 14),),
                              SizedBox(height: 6,),
                             TextFormField(
                                style: style.text18.copyWith(
                                // color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                                controller: _dateDebut,
                                validator: validateNotEmpty,
                                
                                decoration:  InputDecoration(
                                  hintText: "À partir du",
                                  
                                  prefix:
                                      Icon(Icons.calendar_today_rounded, color: red),
                                  // labelStyle: TextStyle(
                                  //   color: Colors.black,
                                  // ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                   hintStyle: style.text18
                                   .copyWith(color: style.invertedColor.withOpacity(0.4)),
                                   contentPadding:
                                   const EdgeInsets.only(left: 10, bottom: 8, top: 15),
                                   enabledBorder: OutlineInputBorder(
                                    borderSide:   BorderSide(color: Color.fromARGB(255, 198, 198, 198), width: 1),
                                      
                                  borderRadius: BorderRadius.circular(10),
                                    ),
                                   border: OutlineInputBorder(
                                   borderSide: const BorderSide(color: blue, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                   ),
                                   errorStyle:
                                   text18white.copyWith(fontSize: 14, color: Colors.redAccent),
                                    focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: blue, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  ),
                                  ),
                                 
                                
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2023),
                                      firstDate: DateTime(2023),
                                      lastDate: DateTime(2026));
                                  if (pickeddate != null) {
                                    setState(() {
                                      dateDebut = pickeddate;
                                      _dateDebut.text = p1.DateFormat('dd-MM-yyyy')
                                          .format(pickeddate);
                                    });
                                  }
                                },
                              ),
                           ],
                         ),
                       ),
                      
                      const SizedBox(height: 28),
                       DelayedAnimation(
                        delay: 200,
                         child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Jusqu'au:",style: style.text18.copyWith(fontWeight: FontWeight.bold,fontSize: 14),),
                             SizedBox(height: 6,),
                             TextFormField(
                            controller: _dateFin,
                            validator: _validateDateFin,
                             style: style.text18.copyWith(
                            
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                            decoration:  InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              
                              prefix:
                                  Icon(Icons.calendar_today_rounded, color: red),
                             
                              hintText: "Jusqu'au",
                               hintStyle: style.text18
                               .copyWith(color: style.invertedColor.withOpacity(0.4)),
                               contentPadding:
                               const EdgeInsets.only(left: 10, bottom: 8, top: 15),
                               enabledBorder: OutlineInputBorder(
                                borderSide:   BorderSide(color: Color.fromARGB(255, 198, 198, 198), width: 1),
                                      
                              borderRadius: BorderRadius.circular(10),
                                ),
                               border: OutlineInputBorder(
                               borderSide: const BorderSide(color: blue, width: 1),
                                borderRadius: BorderRadius.circular(10),
                               ),
                               errorStyle:
                               text18white.copyWith(fontSize: 14, color: Colors.redAccent),
                                focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: blue, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () async {
                              DateTime? pickeddate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2023),
                                  firstDate: DateTime(2023),
                                  lastDate: DateTime(2026));
                              if (pickeddate != null) {
                                setState(() {
                                  dateFin = pickeddate;
                                  _dateFin.text = p1.DateFormat('dd-MM-yyyy')
                                      .format(pickeddate);
                                });
                              }
                            },
                          ),
                           ],
                         ),
                       ),
                      
                    
                      const SizedBox(height: 20),
                      DelayedAnimation(
                          delay: 200,
                          child: Column(
                            children: [
                              Text("Catégorie(s) :", 
                              style: style.text18.copyWith(
                          
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),),
                              SingleChildScrollView(
                                
                                child: DropdownButtonHideUnderline(
                                  
                                  child: DropdownButton2(
                                    
                                    
                                    isExpanded: true,
                                    hint: Align(
                                      alignment: AlignmentDirectional.center,
                                      child: Text(
                                        'Selectionnez une catégorie ou plus',
                                      
                                        style: style.text18.copyWith(
                          // color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                                      ),
                                    ),
                                    items: items.map((item) {
                                      return DropdownMenuItem<String>(
                                        
                                        value: item,

                                        //disable default onTap to avoid closing menu when selecting an item
                                        enabled: false,
                                        child: StatefulBuilder(
                                          builder: (context, menuSetState) {
                                            final _isSelected =
                                                selectedItems.contains(item);
                                            return InkWell(
                                              onTap: () {
                                                _isSelected
                                                    ? selectedItems.remove(item)
                                                    : selectedItems.add(item);
                                                //This rebuilds the StatefulWidget to update the button's text
                                                setState(() {});
                                                //This rebuilds the dropdownMenu Widget to update the check mark
                                                menuSetState(() {});
                                              },
                                              child: Container(
                                                color: style.bgColor,
                                                height: double.infinity,
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    _isSelected
                                                        ? const Icon(Icons
                                                            .check_box_outlined)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank),
                                                    const SizedBox(width: 16),
                                                    Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: style.invertedColor
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }).toList(),
                                    //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
                                    value: selectedItems.isEmpty
                                        ? null
                                        : selectedItems.last,

                                    onChanged: (value) {},
                                    selectedItemBuilder: (context) {
                                      return items.map(
                                        (item) {
                                          return Container(
                                            color: style.bgColor,
                                            alignment:
                                                AlignmentDirectional.center,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Text(
                                              selectedItems.join(', '),
                                              style: style.text18.copyWith(
                                                fontSize: 14,
                                               // overflow: TextOverflow.ellipsis,
                                              ),
                                              maxLines: 1,
                                            ),
                                          );
                                        },
                                      ).toList();
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      height: 80,
                                      width: 250,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          DelayedAnimation(
                            delay: 200,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: red,
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () async {
                                 

                                  try {
                                    String imageUrl =
                                        await uploadImage(_pickedImage!);
                                    if (_formKey.currentState!.validate()) {
                                      
                                      OffreModel offre = OffreModel(
                                          id: generateId2(),
                                          libelle: nomController.text,
                                          idEntreprise: user!.id,
                                          nomEntreprise: user.nomPrenom,
                                          description: descController.text,
                                          dateDebut: dateDebut,
                                          dateFin: dateFin,
                                          affiche: imageUrl,
                                          categories: selectedItems);

                                     if (((user.abonnement=='TRIMESTRIEL')||(user.abonnement=='ANNUEL')||(user.abonnement=='MENSUEL')&&user.dateFinAbonnement!.isAfter(DateTime.now())) || offres.length< 3) {
                                     
                                     
                                      setState(() {
                                        loading = true;
                                      });
                                        OffreService.addOffre(offre).then((value) {
                                        if (value) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Création de l'offre avec succés");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                     BottomNavController()));

                                          print(
                                              'Les informations de cette offre ont été sauvegardés avec succés');
                                        } else {
                                           Fluttertoast.showToast(
                                              msg:
                                                  "Echec de la création de l'offre");
                                          return;
                                        }
                                      });
                                     } else {
                                        showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title: Text("Alerte: Vous avez dépassé les 3 offres gratuites"),
                            content:  Text(
                       "Pour continuer à publier des offres deux propositions s'offrent à vous: Supprimer vos anciennes offres ou acheter un abonnement"
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                      
                      Navigator.push(context,MaterialPageRoute(builder: (context) =>SubscriptionScreen()),);

                    },
                     child: const Text('Consulter les abonnements'),
              ),
                TextButton(
                    onPressed: () {
                       Navigator.push(context,MaterialPageRoute(builder: (context) =>BottomNavController()),);
                    },
                     child: const Text('Consulter mes offres'),
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
                                     }
                                    }
                                  } catch (e) {
                                    print(
                                        'Une erreur est survenue lors de la sauvegarde: $e');
                                  }
                                },
                                child: const Text('       Ajouter       ')),
                          ),
                           const SizedBox(
                        width: 20,
                      ),
                      DelayedAnimation(
                        delay: 400,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              '       Annuler       ',
                              style: TextStyle(color: Colors.black),
                            )),
                      )
                        ],
                      ),
                     
                    ]),
                  ),
                ),
              ),
            ),
          );
  }

  //Methode pour vérifier si la date de fin est valide ou pas
  String? _validateDateFin(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez remplir ce champs';
    }
    if (dateDebut.compareTo(dateFin) > 0 ||
        DateTime.now().compareTo(dateFin) > 0) {
      return 'La date de Fin est invalide ';
    }

    return null;
  }

  //Méthode pour choisir une option pour importer des images
  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: const Text("Gallerie"),
                    onTap: () {
                      _loadPicker(ImageSource.gallery);
                    },
                  ),
                  ListTile(
                    title: const Text("Caméra"),
                    onTap: () {
                      _loadPicker(ImageSource.camera);
                    },
                  )
                ],
              ),
            ));
  }

  _loadPicker(ImageSource source) async {
    XFile? picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      File cropped = await _cropImage(imageFile: File(picked.path));
      setState(() {
        _pickedImage = cropped;
      });
      // Upload the selected image to Firebase storage
      String imageUrl = await uploadImage(_pickedImage!);
      //  // Save the image URL to Firebase Firestore
      //   await saveImageUrlToFirestore(imageUrl);
    }

    //Navigator.pop(context);
  }

  Future<File> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) {
      throw Exception("Failed to crop image");
    }
    return File(croppedImage.path);
  }

//Fonction pour l'upload de l'image

  Future<String> uploadImage(File image) async {
    // Create a unique filename for the image using a timestamp
    String fileName = nomController.text.trim() +
        DateTime.now().millisecondsSinceEpoch.toString();
    // Get a reference to the Firebase storage location where the image will be stored
    Reference storageReference = _firebaseStorage
        .ref()
        .child('OffresImages')
        .child('${nomController.text.trim()}.jpg');
    // Upload the image to Firebase storage
    UploadTask uploadTask = storageReference.putFile(image);
    // Wait for the upload to complete and get the download URL for the image
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

// //Sauvegarde de l'URL de l'image
// Future<Future<DocumentReference<Object?>>> saveImageUrlToFirestore(String imageUrl) async {
//   // Get a reference to the Firestore collection where the image URL will be stored
//   CollectionReference collectionReference =
//       FirebaseFirestore.instance.collection('offresImages');
//   // Add the image URL to the Firestore collection
//   return collectionReference.add({'imageUrl': imageUrl});
// }
}
