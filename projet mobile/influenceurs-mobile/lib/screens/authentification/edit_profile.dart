// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projet/widgets/custom_text_field.dart';
import 'package:projet/services/validation.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';
import '../../constants/style.dart';
import 'package:intl/intl.dart' as p1;
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  //bool showPassword = false;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nomPrenomController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController numtelController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  late DateTime birthday;
  File? _pickedImage;
  String newPhotoUrl = '';



  @override
  void initState() {
    var user = context.read<UserProvider>().currentUser;
    nomPrenomController.text = user!.nomPrenom;
    bioController.text = user.bio;
    numtelController.text = user.tel;
    emailController.text = user.email;
    birthday = user.dateDeNaissance;
    dateController.text = p1.DateFormat('dd-MM-yyyy').format(birthday);
    super.initState();
  }

  @override
  void dispose() {
    nomPrenomController.dispose();
    emailController.dispose();
    bioController.dispose();
    numtelController.dispose();
    dateController.dispose();
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
    var user = context.watch<UserProvider>().currentUser!;
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
        title:
            Text("Modifier Profil", style: style.title.copyWith(fontSize: 20)),
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
          'Formulaire de modification de votre profil nom d\'utilisateur  ${nomPrenomController.text}  biographie ${bioController.text} Adresse email ${emailController.text} Numéro de téléphone ${numtelController.text} date de naissance ${dateController.text} Cliquez sur le bouton à droite pour enregistrer les modifications ou bien sur le bouton à gauche pour annuler les modifications.');

     
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
        child: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : null,
                                      //imageUrl.isEmpty ? Image.asset('images/profil.jfif'):Image.network(imageUrl),
                                      // backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
                                      backgroundColor: style.bgColor,
                                      child: _pickedImage == null
                                          ? Image.network(user.photo)
                                          : null,
                                    ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: red,
                              ),
                              color: red,
                            ),
                            child: GestureDetector(
                              onTap: ()async {
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
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                CustomTextField(
                    hint: 'Name',
                    label: "Nom d'utilisateur",
                    leading: Icons.person,
                    isPassword: false,
                    keybordType: TextInputType.name,
                    controller: nomPrenomController,
                    validator: validateNotEmpty,
                    focus: FocusNode()),
                CustomTextField(
                    controller: bioController,
                    validator: validateNotEmpty,
                    hint: 'Biographie',
                    label: "Biographie",
                    leading: Icons.book,
                    isPassword: false,
                    keybordType: TextInputType.text,
                    focus: FocusNode()),
                CustomTextField(
                    hint: 'Adresse mail',
                    label: "Adresse mail",
                    leading: Icons.mail,
                    isPassword: false,
                    keybordType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: validateEmail,
                    focus: FocusNode()),

                CustomTextField(
                    hint: 'Numéro de télephone',
                    label: "Numéro de télephone",
                    leading: Icons.person,
                    isPassword: false,
                    keybordType: TextInputType.number,
                    controller: numtelController,
                    validator: validateNotEmpty,
                    focus: FocusNode()),

              
                Padding(
                  padding: const EdgeInsets.only(left: 0, bottom: 10),
                  child: Text(
                    "Date de naissance",
                    style: style.text18.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    DatePicker.showDatePicker(
                      context,
                      theme: DatePickerTheme(
                          cancelStyle:
                              style.text18.copyWith(color: style.invertedColor),
                          itemStyle: style.text18.copyWith(fontSize: 16),
                          backgroundColor: style.bgColor),
                      showTitleActions: true,
                      currentTime: birthday,
                      minTime: DateTime(1930, 1, 1),
                      maxTime:
                          DateTime.now().subtract(const Duration(days: 5845)),
                      onConfirm: (date) {
                        setState(() {
                          birthday = date;
                          dateController.text =
                              p1.DateFormat('dd-MM-yyyy').format(date);
                        });
                      },
                      locale: LocaleType.fr,
                    );
                  },
                  child: Center(
                    child: Container(
                      // width: size.width - 30,
                      height: 55,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: const Color.fromRGBO(206, 207, 210, 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: red,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            dateController.text,
                            style: style.text18,
                          ),
                          const Spacer(),
                          const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const BottomNavController()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(style.bgColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 30)),
                        elevation: MaterialStateProperty.all<double>(2.0),
                      ),
                      child: Text(
                        "Annuler",
                        style: style.title.copyWith(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: style.invertedColor),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                         newPhotoUrl= await uploadImage(_pickedImage!);
                        if (_formKey.currentState!.validate()) {
                          //Création d'une map avec les données saisies
                          Map<String, dynamic> dataToUpdate = {
                            'nomPrenom': nomPrenomController.text,
                            'bio': bioController.text,
                            'email': emailController.text,
                            'tel': numtelController.text,
                            'dateDeNaissance': birthday.millisecondsSinceEpoch,
                            'photo':newPhotoUrl
                          };
                          //Modifier les données dans la collection Firestore
                          context.read<UserProvider>().updateInfo(dataToUpdate);
                          setState(() {});
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 50.0)),
                        elevation: MaterialStateProperty.all<double>(2.0),
                      ),
                      child: const Text(
                        "Sauvegarder",
                        style: TextStyle(
                            fontSize: 14.0,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 //fonction pour importer l'image
  _loadPicker(ImageSource source) async {
    XFile? picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      File cropped = await _cropImage(imageFile: File(picked.path));
      setState(() {
        _pickedImage = cropped;
      });
      // Upload the selected image to Firebase storage
      setState(() async {
        newPhotoUrl = await uploadImage(cropped);
      });
      // Save the image URL to Firebase Firestore
      // await saveImageUrlToFirestore(imageUrl);
    }

    //Navigator.pop(context);
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

  //Méthode pour rogner l'image
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
    String fileName = nomPrenomController.text.trim() +
        DateTime.now().millisecondsSinceEpoch.toString();
    // Get a reference to the Firebase storage location where the image will be stored
    Reference storageReference = _firebaseStorage
        .ref()
        .child('UsersImages')
        .child('${nomPrenomController.text.trim()}.jpg');
    // Upload the image to Firebase storage
    UploadTask uploadTask = storageReference.putFile(image);
    // Wait for the upload to complete and get the download URL for the image
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

//Sauvegarde de l'URL de l'image
  Future<Future<DocumentReference<Object?>>> saveImageUrlToFirestore(
      String imageUrl) async {
    // Get a reference to the Firestore collection where the image URL will be stored
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('UsersImages');
    // Add the image URL to the Firestore collection
    return collectionReference.add({'imageUrl': imageUrl});
  }
}
