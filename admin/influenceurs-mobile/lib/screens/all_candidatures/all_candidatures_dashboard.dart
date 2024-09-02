import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/all_candidature_content.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/drawer_menu.dart';




class AllCandidaturesScreen extends StatefulWidget {
  const AllCandidaturesScreen({Key? key}) : super(key: key);

  @override
  State<AllCandidaturesScreen> createState() => _AllCandidaturesScreenState();
}

class _AllCandidaturesScreenState extends State<AllCandidaturesScreen> {
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
              child: AllCandidaturesContent(),
            )
      
          ],
        ),
      ),
    );
  }
}
