import 'package:flutter/material.dart';
import 'Add_Subscription.dart';

class AppBarSunscription extends StatefulWidget {
  const AppBarSunscription({Key? key}) : super(key: key);

  @override
  State<AppBarSunscription> createState() => _AppBarSunscriptionState();
}

class _AppBarSunscriptionState extends State<AppBarSunscription> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        "Les Types d'Abonnements",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    ]);
  }
}
