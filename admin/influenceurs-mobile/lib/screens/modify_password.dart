import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';

import '../../../extra/service/logic_service.dart';
import '../../../providers/theme_notifier.dart';
import '../../../providers/user_provider.dart';
import '../../../services/validation.dart';
import '../../../widgets/custom_text_field.dart';


class ModifyPassword extends StatefulWidget {
  
  @override
  State<ModifyPassword> createState() => _ModifyPasswordState();
}

class _ModifyPasswordState extends State<ModifyPassword> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController=TextEditingController();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Administrateurs');
  final _formKey = GlobalKey<FormState>();

  

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
   confirmNewPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
      var user = context.watch<UserProvider>().currentUser!;
      var style = context.watch<ThemeNotifier>();
    return Scaffold(
     backgroundColor: style.bgColor,
        body:Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 40,
                              horizontal: 30,
                            ),
                            child:Text(
                                    "Modification du mot de passe",
                                    style: GoogleFonts.poppins(
                                      color: red,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
             
                          ),
            
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: Column(
                              children: [
                                 CustomTextField(
                                  hint: 'Ancien Mot de Passe',
                                  label: "Ancien Mot de Passe",
                                  leading: Icons.person,
                                  isPassword: true,
                                  keybordType: TextInputType.visiblePassword,
                                  controller: oldPasswordController,
                                  validator: _validateOldPassword,
                                  focus: FocusNode()),
                                
                                
                                const SizedBox(height: 10),
                                 CustomTextField(
                                  hint: 'Nouveau Mot de passe',
                                  label: "NouveauMot de passe",
                                  leading: Icons.lock,
                                  isPassword: true,
                                  keybordType: TextInputType.visiblePassword,
                                 controller: newPasswordController,
                                 validator: validatePassword,
                                  focus: FocusNode()),
                                
                                 
                                const SizedBox(height: 10),
                                 CustomTextField(
                                  hint: 'Confirmer Nouveau Mot de passe',
                                  label: "Confirmer Nouveau Mot de passe",
                                  leading: Icons.lock,
                                  isPassword: true,
                                  keybordType: TextInputType.visiblePassword,
                                 controller: confirmNewPasswordController,
                                 validator: _validateConfirmPassword,
                                  focus: FocusNode()),
                                
                                
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder(),
                                  backgroundColor: red,
                                  padding: const EdgeInsets.all(13),
                                ),
                                onPressed: () async {
                                   if (_formKey.currentState!.validate()) {
                                    
                                
                                     //Création d'une map avec les données saisies
                                Map<String, dynamic> dataToUpdate = {
                                  'password': Scrypt.crypt(newPasswordController.text),
                                 
                                };
                                //Modifier les données dans la collection Firestore
                                context.read<UserProvider>().updateInfo(dataToUpdate);
                                setState(() {});
                                 Fluttertoast.showToast( msg: "Modification du Mot De Passe avec succés");
                                Navigator.pop(context);
                              }
                          
                                   },
                          
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    
                                    const SizedBox(width: 10),
                                    Text('CONFIRMER',
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                )),
                          
                         
                           const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: ElevatedButton(
                                  
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    backgroundColor: red,
                                    padding: const EdgeInsets.all(13),
                                  ),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                     
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      
                                      const SizedBox(width: 10),
                                      Text('ANNULER',
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                          ),
                          
            
                         
            
                        ],
                      ),
                    ),
                  ),
           
      
    );
  }

  String? _validateOldPassword(String? value) {
    var user = context.read<UserProvider>().currentUser;
    var crypted=Scrypt.crypt(value!);
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez taper votre ancien Mot De Passe !';
    }
    if (crypted != user!.password) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Ancien Mot De Passe Incorrect!';
    }
    return null;
  }

   String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      //  Fluttertoast.showToast(msg: "Veuillez confirmer le mot de passe");
      return 'Veuillez confirmer le mot de passe';
    }
    if (value != newPasswordController.text) {
      // Fluttertoast.showToast(msg: 'Les mots de passe ne correspondent ');
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }
}