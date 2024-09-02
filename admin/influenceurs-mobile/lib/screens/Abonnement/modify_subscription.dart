// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:intl/intl.dart' as p1;
import 'package:responsive_admin_dashboard/models/user.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/Abonnement/all_subscription_dashbord.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/dash_board_screen.dart';
import 'package:responsive_admin_dashboard/services/validation.dart';
import 'package:responsive_admin_dashboard/widgets/custom_text_field.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ModifySubscription extends StatefulWidget {
  final UserModel user;

  const ModifySubscription({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ModifySubscription> createState() => _ModifySubscriptionState();
}

class _ModifySubscriptionState extends State<ModifySubscription> {
    final _formKey = GlobalKey<FormState>();
     final TextEditingController _date = TextEditingController();
     late DateTime dateFin;
     var newAbonnement ;
     
     


  @override
  Widget build(BuildContext context) {
   
     var style = context.watch<ThemeNotifier>();
     

    return Scaffold(
      backgroundColor: style.bgColor,
      body: Row(
        children: [
              
           Container(
      width: 500,
      height: 800,
      child: Image.asset('assets/images/sub.png'),
    ),
           SizedBox(width: 20,),
          Expanded(
            child: Form(
            key: _formKey,
            child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 30,
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                                "Modification de l'abonnement",
                                style: GoogleFonts.poppins(
                                  color: red,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      widget.user.abonnement==null?Text("Cet utilisateur ${widget.user.nomPrenom} n'est inscrit à aucun abonnement",style:style.text18.copyWith(fontSize: 18),)
                      :Text("Cet utilisateur ${widget.user.nomPrenom} est inscrit à l'abonnement ${widget.user.abonnement}.Cet abonnement a débuté le ${widget.user.dateInscription} et prendra fin le ${widget.user.dateFinAbonnement}.",style:style.text18.copyWith(fontSize: 18)),
                    ],
                  ),
           
                ),
          
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("Type d'abonnement:",style:style.title.copyWith(fontSize: 16)),
                      Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Radio(
                                      
                                      hoverColor: red,
                                      value: 'MENSUEL',
                                      groupValue: newAbonnement,
                                      onChanged: (value) {
                                        setState(() {
                                          newAbonnement = value!;
                                        });
                                      },
                                    ),
                                    Text('Mensuel', style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                    Radio(
                                      hoverColor: red,
                                      value: 'TRIMESTRIEL',
                                      groupValue: newAbonnement,
                                      onChanged: (value) {
                                        setState(() {
                                          newAbonnement = value!;
                                        });
                                      },
                                    ),
                                    Text('Trimestriel',style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                    Radio(
                                      hoverColor: red,
                                      value: 'ANNUEL',
                                      groupValue: newAbonnement,
                                      onChanged: (value) {
                                        setState(() {
                                          newAbonnement = value!;
                                        });
                                      },
                                    ),
                                    Text('Annuel',style: style.title.copyWith(fontSize: 15,color: Colors.grey[400]),),
                                  ],
                                ),
                      
                      const SizedBox(height: 10),
                      Text("Date de fin d'abonnement",style:style.title.copyWith(fontSize: 16)),
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
                  // currentTime: dateFin,
                  minTime: DateTime.now(),
                  maxTime:
                      DateTime.now().add(const Duration(days:365)),
                  onConfirm: (date) {
                    setState(() {
                      dateFin = date;
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
                      
                      
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 300),
                  child: Row(
                    
                    children: [
                      ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: red,
                              padding: const EdgeInsets.all(13),
                            ),
                            onPressed: () async {
                                    
                           if (_formKey.currentState!.validate()) {
                             FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                                'abonnement': newAbonnement,
                                'dateInscription': DateTime.now(),
                                'dateFinAbonnement': dateFin,
                              
                              })
                              .then((value) => print("Modification de l'abonnement avec succés"))
                              .catchError((error) => print("Erreur lors de la modification de l'abonnement : $error"));
                              
                              Fluttertoast.showToast(
                                  msg: "Modification de l'abonnement avec succés");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoardScreen()),
                              );
                           }
                             else{
                                Fluttertoast.showToast(
                                  msg: "Echec de la modification de l'abonnement");
                             }  
                           
                        
                              
                               },
                              
                            child:Text('CONFIRMER',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              
                            ),
                             const SizedBox(width: 40),
                  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: red,
                          padding: const EdgeInsets.all(13),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                           
                        },
                        child:Text('ANNULER',
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500)),
                          
                        ),
                
                    ],
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