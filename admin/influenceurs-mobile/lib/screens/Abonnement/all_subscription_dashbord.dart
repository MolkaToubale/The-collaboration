import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/controllers/controller.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/drawer_menu.dart';
import 'all_subscription_content.dart';



class AllSubscriptionScreen extends StatefulWidget {
  const AllSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<AllSubscriptionScreen> createState() => _AllSubscriptionScreenState();
}

class _AllSubscriptionScreenState extends State<AllSubscriptionScreen> {
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
              child: AllSubscription(),
            )
      
          ],
        ),
      ),
    );
  }
}
