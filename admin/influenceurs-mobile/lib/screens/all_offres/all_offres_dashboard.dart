import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/all_offres_content.dart';
import 'package:responsive_admin_dashboard/screens/all_users/all_users_content.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/drawer_menu.dart';

import '../../constants/constants.dart';



class AllOffresScreen extends StatefulWidget {
  const AllOffresScreen({Key? key}) : super(key: key);

  @override
  State<AllOffresScreen> createState() => _AllOffresScreenState();
}

class _AllOffresScreenState extends State<AllOffresScreen> {
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Scaffold(
      backgroundColor: style.bgColor,
      drawer: DrawerMenu(),
      key: context.read<Controller>().scaffoldKey,
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
              child: AllOffresContent(),
            )
      
          ],
        ),
      ),
    );
  }
}
