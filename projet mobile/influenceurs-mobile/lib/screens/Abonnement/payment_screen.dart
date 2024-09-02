import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:projet/constants/style.dart';
import 'package:projet/models/abonnement.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/providers/user_provider.dart';
import 'package:projet/services/navigation_service.dart';
import 'package:projet/widgets/buttom_bar.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final AbonnementModel abonnement;
  const PaymentScreen({Key? key, required this.abonnement}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Map<String, dynamic>? paymentIntent;
  
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

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    var user = context.watch<UserProvider>().currentUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: style.panelColor,
         leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: red,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        title:Text("Compléter la phase de paiement",style: TextStyle(color: red),),
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
          '${widget.abonnement.description} Cliquer sur le bouton je m\'abonne et finaliser l\'étape de paiement en saisissant vos données bancaires. Si vous souhaitez revenir en arrière cliquez sur la flêche en haut de la page. '
         );
         

     
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
        color: style.bgColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 80,),
              Image.asset("images/sub.png"),
              SizedBox(height: 50,),
              Text(widget.abonnement.description,style:style.text18.copyWith(fontSize:18)),
              SizedBox(height: 40,),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Text('JE M\' ABONNE',),
                      
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 13,
                            ),
                          ),
                      onPressed: () async {
                        if(user!.dateFinAbonnement!=null && user.dateFinAbonnement!.isAfter(DateTime.now())){
                           showDialog(
                              context: context,
                             builder: (context) => AlertDialog(
                             title:  Text("Alerte:"),
                            content:  Text(
                       "Votre abonnement ${user.abonnement} n'a pas encore pris fin.Il prendra fin le ${user.dateFinAbonnement}"
                      ),
                    actions: [
                     TextButton(
                    onPressed: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavController()),);

                    },
                     child: const Text('Ok'),
              ),
                 
            ],
          ),
        );
                        }
                        else{
                        if (widget.abonnement.titre=='ANNUEL') {
                          makePaymentAnnuel(widget.abonnement);
                        }
              
                        else if (widget.abonnement.titre=='TRIMESTRIEL'){
                          makePaymentTrimestriel(widget.abonnement);
                        }
                        else{
                          makePaymentMonsuel(widget.abonnement);
                        }
                      }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePaymentAnnuel(AbonnementModel abonnement) async {
    try {
      paymentIntent = await createPaymentIntent('8000', 'CAD');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "CA",
          currencyCode: "CAD",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'TheCollaboration',
              googlePay: gpay
              ))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(abonnement);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(AbonnementModel abonnement) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {

         if (abonnement.titre=='ANNUEL') {
                  print('paiement ANNUEL avec succés');
                 FirebaseFirestore.instance
                .collection('users')
                .doc(NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!.id)
                .update({'abonnement': 'ANNUEL','dateInscription':DateTime.now(),'dateFinAbonnement':DateTime.now().add(const Duration(days: 365))});
                 Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavController()),);

                }

                else if (abonnement.titre=='TRIMESTRIEL'){
                  print('paiement TRIMESTRIEL avec succés');
                   FirebaseFirestore.instance
                .collection('users')
                .doc(NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!.id)
                .update({'abonnement': 'TRIMESTRIEL','dateInscription':DateTime.now(),'dateFinAbonnement':DateTime.now().add(const Duration(days: 90))});
                 Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavController()),);
                  
                }
                else{
                  print('paiement MENSUEL avec succés');
                   FirebaseFirestore.instance
                .collection('users')
                .doc(NavigationService.navigatorKey.currentContext!.read<UserProvider>().currentUser!.id)
                .update({'abonnement': 'MENSUEL',
                'dateInscription':DateTime.now(),
                'dateFinAbonnement':DateTime.now().add(const Duration(days: 30))});
                 Navigator.push(context,MaterialPageRoute(builder: (context) => BottomNavController()),);
                }
      });
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount, 
        'currency': currency,
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer sk_test_51N3NogBhnpJLAhnbSQlxCmkwyS3XgAfDS6nVtP7bLpufo8QfYZ3IMGFv13hI5YwjG4hRsgx0gOkk2IAU9M3jWdcL00TSmCEZnT',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }



  Future<void> makePaymentTrimestriel(AbonnementModel abonnement) async {
    try {
      paymentIntent = await createPaymentIntent('5000', 'CAD');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "CA",
          currencyCode: "CAD",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'TheCollaboration',
              googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(abonnement);
    } catch (err) {
      print(err);
    }
  }


   Future<void> makePaymentMonsuel(AbonnementModel abonnement) async {
    try {
      paymentIntent = await createPaymentIntent('3000', 'CAD');

      var gpay = PaymentSheetGooglePay(merchantCountryCode: "CA",
          currencyCode: "CAD",
          testEnv: true);

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'TheCollaboration',
              googlePay: gpay))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(abonnement);
    } catch (err) {
      print(err);
    }
  }

 


}