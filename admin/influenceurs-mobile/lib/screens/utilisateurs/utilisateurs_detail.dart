import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:firebase_storage_web/firebase_storage_web.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/chart/users.dart';

import '../../models/user.dart';

class UtilisateurDetails extends StatefulWidget {
   UtilisateurDetails({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<UtilisateurDetails> createState() => _UtilisateurDetailsState();
}

class _UtilisateurDetailsState extends State<UtilisateurDetails> {
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    

    return Container(
      margin: EdgeInsets.only(top: appPadding),
      padding: EdgeInsets.all(appPadding / 2),
      child: Row(
        children: [
           ClipOval(
            child:Image.network(
              widget.user.photo,
              height: 38,
              width: 38,
             fit: BoxFit.cover,
              ),
           ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: appPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   widget.user.nomPrenom,
                    style:style.title.copyWith(fontWeight: FontWeight.w600,fontSize: 15),
                  ),
                  Text(
                    widget.user.statut,
                    style: style.text18.copyWith(
                      
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
