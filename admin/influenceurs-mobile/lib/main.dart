import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/extra/providers/MessagesProvider.dart';
import 'package:responsive_admin_dashboard/extra/providers/chat_room_provider.dart';
import 'package:responsive_admin_dashboard/providers/abonnement_provider.dart';
import 'package:responsive_admin_dashboard/providers/admin_provider.dart';
import 'package:responsive_admin_dashboard/providers/candidature_provider.dart';
import 'package:responsive_admin_dashboard/providers/offre_provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/providers/user_provider.dart';
import 'package:responsive_admin_dashboard/screens/login-screen.dart';

import 'package:responsive_admin_dashboard/services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyD8GnN4m9CejwJCaoHtAj9cC1JKHqgEdbY', 
      appId:"1:617160311456:web:af83674e60af8c741effc5" , 
      messagingSenderId: "617160311456", 
      projectId: "projet-5decf")
  );

    runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>Controller(),),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => AbonnementProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
      ChangeNotifierProvider(create: (_) => MessagesProvider()),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => OffreProvider()),
      ChangeNotifierProvider(create:(_)=>CandidatureProvider() ,)
    ],
    child:  MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
     home: Login_screen(),
      navigatorKey: NavigationService.navigatorKey,
     
    );
  }
}





