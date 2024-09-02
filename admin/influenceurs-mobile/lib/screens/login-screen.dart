import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/extra/service/logic_service.dart';
import 'package:responsive_admin_dashboard/providers/admin_provider.dart';
import 'package:responsive_admin_dashboard/widgets/custom_text_field.dart';
import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';
import '../../services/validation.dart';



// ignore: camel_case_types
class Login_screen extends StatefulWidget {
  

  @override
  State<Login_screen> createState() => _Login_screenState();
}

// ignore: camel_case_types
class _Login_screenState extends State<Login_screen> {
  final nameOrEmailController = TextEditingController();
  final passwordController = TextEditingController();
 
  final CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection('Administrateurs');
  final _formKey = GlobalKey<FormState>();

  

  @override
  void dispose() {
    nameOrEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
      var style = context.watch<ThemeNotifier>();
       setState(() {});
    return  Scaffold(
          backgroundColor: style.bgColor,
            
            body: Row(
              children: [
                   Expanded(
                    flex:3,
                     child: Container(
                         width: 500,
                         height: 800,
                         child: Image.asset("assets/images/logo.png"),
                       ),
                   ),
    SizedBox(width: 20,),
                Expanded(
                  flex:2,
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                
                          Container(
                            margin: const EdgeInsets.symmetric(
                              
                              horizontal: 30,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                           Container(
      width: 500,
      height: 200,
      child: Image.asset("assets/images/logoGris.png"),
    ),

                                
                                const SizedBox(height: 22),
                                 Text(
                                    "Veuillez saisir vos données d'authentification.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  
                                ),
                                SizedBox(height: 25,)
                              ],
                            ),
                          ),
                
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                CustomTextField(
                                  hint: 'Adresse mail ou nom d\'utilisateur',
                                  label: "Adresse mail ou nom d'utilisateur",
                                  leading: Icons.person,
                                  isPassword: false,
                                  keybordType: TextInputType.name,
                                  controller: nameOrEmailController,
                                  validator: validateNotEmpty,
                                  focus: FocusNode()),
                                
                                
                                const SizedBox(height: 10),
                                CustomTextField(
                                  hint: 'Mot de passe',
                                  label: "Mot de passe",
                                  leading: Icons.lock,
                                  isPassword: true,
                                  keybordType: TextInputType.visiblePassword,
                                  controller: passwordController,
                                  validator: validateNotEmpty,
                                  focus: FocusNode()),
                                
                                
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 160),
                            child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: purple,
                                    shape: const StadiumBorder(),
                                    backgroundColor: red,
                                    padding: const EdgeInsets.all(8),
                                  ),
                                  onPressed: () async {
                                    try {
                                       if (_formKey.currentState!.validate()) {
                                    
                                      String nameOrEmail = nameOrEmailController.text;
                                      String password = Scrypt.crypt(passwordController.text);
                                          
                                      context
                                          .read<AdminProvider>()
                                          .signIn(context,nameOrEmail, password);
                                      } 
                                   
                                      
                                    } catch (e) {
                                      log('erreur de connexion: $e');
                                    }
                                    
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.mail_lock),
                                        const SizedBox(width: 10),
                                        Text('SE CONNECTER',
                                            style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  )
                                  ),
                          ),            
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
          );
  }
}
