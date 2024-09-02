import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projet/extra/Messenger/const.dart';
import 'package:projet/main.dart';
import 'package:projet/models/user.dart';

import 'package:projet/screens/authentification/login_screen.dart';
import 'package:projet/screens/authentification/otp_screen.dart';
import 'package:projet/widgets/custom_text_field.dart';

import 'package:projet/services/user_service.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';
import '../../constants/loading.dart';
import '../../constants/style.dart';
import '../../extra/service/logic_service.dart';
import '../../providers/theme_notifier.dart';
import '../welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet/widgets/delayed_animation.dart';
import 'package:intl/intl.dart' as p1;
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:projet/services/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp_screen extends StatefulWidget {
  const SignUp_screen({super.key});

  @override
  State<SignUp_screen> createState() => _SignUp_screenState();
}

class _SignUp_screenState extends State<SignUp_screen> {
  List<UserModel>comptesExistants=[];
   //Méthodes pour récupérer une liste d'utilisateurs
 fetchUsers(String? value,String value2) async {
  final emailQuery = FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: value);

  final nomPrenomQuery = FirebaseFirestore.instance
      .collection('users')
      .where('nomPrenom', isEqualTo: value2);

  QuerySnapshot<Map<String, dynamic>> emailQn = await emailQuery.get();
  QuerySnapshot<Map<String, dynamic>> nomPrenomQn = await nomPrenomQuery.get();

  for (var data in emailQn.docs) {
    comptesExistants.add(UserModel.fromMap(data.data()));
  }

  for (var data in nomPrenomQn.docs) {
    comptesExistants.add(UserModel.fromMap(data.data()));
  }

  setState(() {});
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

  
  final TextEditingController _date = TextEditingController();
  late String nomPrenom,email,password;
  late DateTime birthday;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String genre = 'Femme';
  String statut = 'Entreprise';

  String imageUrl = '';
 
  File? _pickedImage;
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bioController = TextEditingController();
  final telController = TextEditingController();
  final otpController= TextEditingController();
  TextEditingController otp1Controller = TextEditingController();
  TextEditingController otp2Controller = TextEditingController();
  TextEditingController otp3Controller = TextEditingController();
  TextEditingController otp4Controller = TextEditingController();
 EmailOTP myauth = EmailOTP();
  bool passwordConfirmed = false;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nomController.dispose();
    confirmPasswordController.dispose();
    bioController.dispose();
    telController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
     var style = context.watch<ThemeNotifier>();
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: style.bgColor,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0),
              leading: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.black,
                iconSize: 30,
                onPressed: () {
                  Navigator.pop(context);
                },
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
         await speak(' Bienvenu à the Collaboration. Pour vous inscrire commencer par sélectionner une photo de profil, ensuite veuillez remplir tous les champs, le premier champs indique votre adresse mail, le deuxième votre nom d\'utilisateur, le troisième votre numéro de téléphone. Vous devez ensuite indiquer votre genre au niveau des boutons radio à savoir homme ou femme. Indiquez ensuite votre biographie, votre date de naissance ainsi que votre mot de passe et une confirmation de ce dernier. Pour conclure l\'inscription vous devez indiquer votre statut à savoir influenceur ou entreprise . Vérifiez que vous avez remplis tous les champs puis validez en cliquant sur le bouton  Créer un compte en bas de la page. Pour annuler l\'inscription cliquez sur la crois en haut de la page.');
     
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          DelayedAnimation(
                            delay: 200,
                            child: Text(
                              "Création de compte",
                              style: GoogleFonts.poppins(
                                color: red,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
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
                                    ),
                                    child: CircleAvatar(
                                      radius: 80,
                                      backgroundImage: _pickedImage != null
                                          ? FileImage(_pickedImage!)
                                          : null,
                                      //imageUrl.isEmpty ? Image.asset('images/profil.jfif'):Image.network(imageUrl),
                                      // backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
                                      backgroundColor: bgColor,
                                      child: _pickedImage == null
                                          ? Image.asset('images/profil.jfif')
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

                        
                           
DelayedAnimation(
  delay: 200,
  child:   Row(
  
    children: [
  
      Expanded(
  
       
  
          child: CustomTextField(
  
            hint: 'Adresse mail',
  
            label: "Adresse mail",
  
            leading: Icons.mail,
  
            isPassword: false,
  
            keybordType: TextInputType.emailAddress,
  
            controller: emailController,
  
            validator: validateEmail,
  
            focus: FocusNode(),
  
          ),
  
        
  
      ),
  
      TextButton(
  
        onPressed: () async {
  
          if (comptesExistants.isEmpty) {
  
          await   myauth.setConfig(
  
              appEmail: "contact@TheCollaboration.com",
  
              appName: "The Collaboration",
  
              userEmail: emailController.text,
  
              otpLength: 4,
  
              otpType: OTPType.digitsOnly,
  
            );
  
            if (await myauth.sendOTP()) {
  
              // ignore: use_build_context_synchronously
  
              ScaffoldMessenger.of(context).showSnackBar(
  
                const SnackBar(
  
                  content: Text("L'OTP vous a été envoyé"),
  
                ),
  
              );
  
            } else {
  
              // ignore: use_build_context_synchronously
  
              ScaffoldMessenger.of(context).showSnackBar(
  
                const SnackBar(
  
                  content: Text("Oups, échec d'envoi de l'OTP"),
  
                ),
  
              );
  
            }
  
          }
  
        },
  
        child: const Text('Vérifier',style: TextStyle(color: red),),
  
      ),
  
    ],
  
  ),
),
DelayedAnimation(
                              delay: 200,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Entrez votre code',
                                  style: TextStyle(
                                    color: style.invertedColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
          DelayedAnimation(
            delay: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Otp(
                  otpController: otp1Controller,
                ),
                Otp(
                  otpController: otp2Controller,
                ),
                Otp(
                  otpController: otp3Controller,
                ),
                Otp(
                  otpController: otp4Controller,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 23,
          ),



                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Nom d\'utilisateur',
                            label: "Nom d\'utilisateur",
                            leading: Icons.person,
                            isPassword: false,
                            keybordType: TextInputType.name,
                            controller: nomController,
                            validator: validateNotEmpty,
                            focus: FocusNode()),
                          ),

                          DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Numéro de téléphone',
                            label: "Numéro de téléphone",
                            leading: Icons.phone,
                            isPassword: false,
                            keybordType: TextInputType.number,
                            controller: telController,
                            validator: validateTel,
                            focus: FocusNode()),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                           DelayedAnimation(
                              delay: 200,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Vous êtes :',
                                  style: TextStyle(
                                    color: style.invertedColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),

                          DelayedAnimation(
                              delay: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Radio(
                                    value: 'Homme',
                                    groupValue: genre,
                                    onChanged: (value) {
                                      setState(() {
                                        genre = value!;
                                      });
                                    },
                                  ),
                                   Text('Homme',style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                  Radio(
                                    hoverColor: red,
                                    value: 'Femme',
                                    groupValue: genre,
                                    onChanged: (value) {
                                      setState(() {
                                        genre = value!;
                                      });
                                    },
                                  ),
                                  Text('Femme',style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                ],
                              )),
                             DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Biographie',
                            label: "Biographie",
                            leading: Icons.book,
                            isPassword: false,
                            keybordType: TextInputType.multiline,
                            //maxLength:50,
                            controller: bioController,
                            validator: validateNotEmpty,
                            focus: FocusNode()),
                          ),

                          Padding(
                  padding: const EdgeInsets.only(right: 230),
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
                      // currentTime: birthday,
                      minTime: DateTime(1930, 1, 1),
                      maxTime:
                          DateTime.now().subtract(const Duration(days: 5845)),
                      onConfirm: (date) {
                        setState(() {
                          birthday = date;
                           _date.text =
                              p1.DateFormat('dd-MM-yyyy').format(date);
                        });
                      },
                      locale: LocaleType.fr,
                    );
                    validateNotEmpty;
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
                            _date.text,
                            style: style.text18,
                          ),
                          const Spacer(),
                          const SizedBox()
                        ],
                      ),
                    ),
                  ),
                ),
          


                          SizedBox(height: 15,),
                           DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Mot de passe',
                            label: "Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: passwordController,
                            validator: validatePassword,
                            focus: FocusNode()),
                          ),



                            DelayedAnimation(
                            delay: 200,
                            child: CustomTextField(
                            hint: 'Mot de passe',
                            label: "Confirmer votre Mot de passe",
                            leading: Icons.lock,
                            isPassword: true,
                            keybordType: TextInputType.visiblePassword,
                            controller: confirmPasswordController,
                            validator: _validateConfirmPassword,
                            focus: FocusNode()),
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                           DelayedAnimation(
                              delay: 200,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Statut :',
                                  style: TextStyle(
                                    color:style.invertedColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              )),

                          DelayedAnimation(
                              delay: 200,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Radio(
                                    
                                    hoverColor: red,
                                    value: 'Entreprise',
                                    groupValue: statut,
                                    onChanged: (value) {
                                      setState(() {
                                        statut = value!;
                                      });
                                    },
                                  ),
                                  Text('Entreprise', style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                  Radio(
                                    hoverColor: red,
                                    value: 'Influenceur',
                                    groupValue: statut,
                                    onChanged: (value) {
                                      setState(() {
                                        statut = value!;
                                      });
                                    },
                                  ),
                                  Text('Influenceur/se',style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                ],
                              )),

                          const SizedBox(
                            height: 10,
                          ),
                        
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    DelayedAnimation(
                      delay: 200,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: red,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 125,
                            vertical: 13,
                          ),
                        ),
                        onPressed: () async {
                          fetchUsers(emailController.text,nomController.text);
                          try {
                            imageUrl = await uploadImage(_pickedImage!);
                            UserModel user = UserModel(
                                id: generateId2(),
                                nomPrenom: nomController.text,
                                email: emailController.text,
                                password: Scrypt.crypt(passwordController.text),
                                dateDeNaissance: birthday,
                                genre: genre,
                                statut: statut,
                                creeLe: DateTime.now(),
                                photo: imageUrl,
                                tel: telController.text,
                                bio: bioController.text);
                       
                            if (_formKey.currentState!.validate()) {
                              
                              if (comptesExistants.isNotEmpty) {
                                 showDialog(
                                 context: context,
                                 builder: (context) => AlertDialog(
                                title: const Text("Données invalides"),
                                content: const Text(
                               "Adresse mail et/ou Nom d'utilisateur déjà assignés à un autre compte.",
                               ),
                             actions: [
                           TextButton(
                          onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                  ),
              ],
            ),
          );

          comptesExistants.clear();
          
                              }else
                               if (await myauth.verifyOTP(otp: otp1Controller.text +
                    otp2Controller.text +
                    otp3Controller.text +
                    otp4Controller.text) == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("OTP vérifiée"),
                ));
                 UserService.addUser(user).then((value) {
                                if (value) {
                                  Fluttertoast.showToast(
                                      msg: "Création de compte avec succés");
                                 
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Login_screen()));
                                  print(
                                      'Les informations de cet utilisateurs ont été sauvegardés avec succés');
                                } 
                              });
                
              } 
              else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("OTP Invalide"), 
                ),);
                   Fluttertoast.showToast(
                                      msg: "Echec de création du compte");
                                  return;
              }
     }
                          } catch (e) {
                            setState(() {
                              loading = false;
                            });
                            print(
                                'Une erreur est survenue lors de la sauvegarde: $e');
                          }
                        
                        },
             
          
           
             

                        child: Text(
                          'CREER COMPTE',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
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
        imageUrl = await uploadImage(cropped);
      });
      // Save the image URL to Firebase Firestore
      // await saveImageUrlToFirestore(imageUrl);
    }

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
    String fileName = nomController.text.trim() +
        DateTime.now().millisecondsSinceEpoch.toString();
    // Get a reference to the Firebase storage location where the image will be stored
    Reference storageReference = _firebaseStorage
        .ref()
        .child('UsersImages')
        .child('${nomController.text.trim()}.jpg');
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

  //Fonction pour vérifier si les deux mots de passe sont identiques ou pas
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != passwordController.text) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
  
  
}
