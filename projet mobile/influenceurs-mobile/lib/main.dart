import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:projet/providers/candidature_provider.dart';
import 'package:projet/providers/favorite_provider.dart';
import 'package:projet/providers/offre_provider.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/providers/user_provider.dart';
import'package:projet/services/navigation_service.dart';
import 'package:projet/services/shared_data.dart';
import 'package:provider/provider.dart';
import './screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'extra/providers/MessagesProvider.dart';
import 'extra/providers/chat_room_provider.dart';








Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey="pk_test_51N3NogBhnpJLAhnbCRy1Eu4rbbRAZRFCZemSVl3MaVd1Wo4Jf4w8aZxrhOwqSxktkXO36GGtW82JyXRG73FdqVED00sHRo0jrJ";
  


  await Firebase.initializeApp();
  DataPrefrences.init();
 
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => ChatRoomProvider()),
      ChangeNotifierProvider(create: (_) => MessagesProvider()),
      ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ChangeNotifierProvider(create: (_) => OffreProvider()),
      ChangeNotifierProvider(create:(_)=>FavoriteProvider() ,),
      ChangeNotifierProvider(create:(_)=>CandidatureProvider() ,)
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Test de crash
    //FirebaseCrashlytics.instance.crash();
    return MaterialApp(
      home: const WelcomeScreen(),
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
    );
  }
}
