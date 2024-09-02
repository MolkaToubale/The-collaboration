import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/all_candidature_content.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/all_offres_content.dart';
import 'package:responsive_admin_dashboard/screens/all_settings/settings.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_content.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/drawer_menu.dart';

import '../../constants/constants.dart';



class AllSettingsScreen extends StatefulWidget {
  const AllSettingsScreen({Key? key}) : super(key: key);

  @override
  State<AllSettingsScreen> createState() => _AllSettingsScreenState();
}

class _AllSettingsScreenState extends State<AllSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: DrawerMenu(),
      // key: context.read<Controller>().scaffoldKey,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: DrawerMenu(),
              ),
               Expanded(
              flex: 5,
              child: SettingsScreen(),
            )
      
          ],
        ),
      ),
    );
  }
}
