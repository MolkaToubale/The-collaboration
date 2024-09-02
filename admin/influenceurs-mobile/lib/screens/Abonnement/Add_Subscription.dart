// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:responsive_admin_dashboard/models/abonnement.dart';
// import 'package:responsive_admin_dashboard/screens/dash_board_screen.dart';
// import 'package:responsive_admin_dashboard/services/abonnement_service.dart';
// import '../../constants/style.dart';
// import '../../providers/theme_notifier.dart';
// import '../../services/validation.dart';
// import '../../widgets/custom_text_field.dart';


// class AddSubscription extends StatefulWidget {
//   const AddSubscription({Key? key}) : super(key: key);

//   @override
//   State<AddSubscription> createState() => _AddSubscriptionState();
// }

// class _AddSubscriptionState extends State<AddSubscription> {
//   final titresubscriptionController = TextEditingController();
  
//   final _formKey = GlobalKey<FormState>();
//   final descriptionsubscriptionController = TextEditingController();
//   final prixsubscriptionController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//      var style = context.watch<ThemeNotifier>();
//     return Scaffold(
//       backgroundColor: style.bgColor,
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.symmetric(
//                   vertical: 40,
//                   horizontal: 30,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Ajouter un abonnement",
//                       style: GoogleFonts.poppins(
//                         color: red,
//                         fontSize: 25,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 22),
//                     Text(
//                       "Veuillez saisir les caractéristiques du nouvel abonnement.",
//                       style: GoogleFonts.poppins(
//                         color: Colors.grey[400],
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                 ),
//                 child: Column(
//                   children: [
//                     CustomTextField(
//                         hint: 'Titre de l\'abonnement',
//                         label: "Titre de l\'abonnement",
//                         leading: Icons.person,
//                         isPassword: false,
//                         keybordType: TextInputType.name,
//                         controller: titresubscriptionController,
//                         validator: validateNotEmpty,
//                         focus: FocusNode()),
//                     const SizedBox(height: 10),
//                     CustomTextField(
//                         hint: 'Description',
//                         label: "Description",
//                         leading: Icons.lock,
//                         isPassword: false,
//                         keybordType: TextInputType.multiline,
//                         controller: descriptionsubscriptionController,
//                         validator: validateNotEmpty,
//                         focus: FocusNode()),
//                     const SizedBox(height: 10),
//                     CustomTextField(
//                         hint: 'Prix',
//                         label: "Prix",
//                         leading: Icons.lock,
//                         isPassword: false,
//                         keybordType: TextInputType.number,
//                         controller: prixsubscriptionController,
//                         validator: validateNotEmpty,
//                         focus: FocusNode()),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: const StadiumBorder(),
//                   backgroundColor: red,
//                   padding: const EdgeInsets.all(13),
//                 ),
//                 onPressed: () async {
//                               AbonnementModel abonnement = AbonnementModel(
//                         titre: titresubscriptionController.text,
//                         prix: prixsubscriptionController.text,
//                         description: descriptionsubscriptionController.text,
//                       );

//                               try {
                               
//                                 if (_formKey.currentState!.validate()) {
                                  

//                                  AbonnementModel abonnement = AbonnementModel(
//                         titre: titresubscriptionController.text,
//                         prix: prixsubscriptionController.text,
//                         description: descriptionsubscriptionController.text,
//                       );

//                                   AbonnementService.addAbonnement(abonnement).then((value) {
//                                     if (value) {
//                                       Fluttertoast.showToast(
//                                           msg:
//                                               "Création de l'abonnement avec succés");
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                 DashBoardScreen()));

//                                       print(
//                                           'Les informations de cette offre ont été sauvegardés avec succés');
//                                     } else {
//                                       return;
//                                     }
//                                   });
//                                 }
//                               } catch (e) {
//                                 print(
//                                     'Une erreur est survenue lors de la sauvegarde: $e');
//                               }
//                             },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.mail_lock),
//                     const SizedBox(width: 10),
//                     Text('Ajouter',
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20,),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   shape: const StadiumBorder(),
//                   backgroundColor: Colors.grey,
//                   padding: const EdgeInsets.all(13),
//                 ),
//                 onPressed: () async {
                  
//                 Navigator.pop(context);
//                 },
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.cancel),
//                     const SizedBox(width: 10),
//                     Text('Annuler',
//                         style: GoogleFonts.poppins(
//                             fontSize: 16, fontWeight: FontWeight.w500)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
