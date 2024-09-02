import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/Abonnement/all_subscription_dashbord.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/all_candidatures_dashboard.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/all_offres_dashboard.dart';
import 'package:responsive_admin_dashboard/screens/all_settings/settings.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/dash_board_screen.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/drawer_list_tile.dart';
import '../all_users/all_users_dashbord.dart';
import '../all_usersDeleted/all_usersDeleted_dashbord.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Drawer(
      backgroundColor: style.bgColor,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(appPadding*2),
            child: Image.asset("assets/images/logoGris.png"),
          ),
          DrawerListTile(

              title: 'Tableau de bord',
              svgSrc: 'assets/icons/Dashboard.svg',
              tap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()),);
              }
                 ),
          DrawerListTile(
              title: 'Utilisateurs Actifs',
              svgSrc: 'assets/icons/user.svg',
              tap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AllUsersScreen()),);
              }
              ),
               DrawerListTile(
              title: 'Utilisateurs Supprimés',
              svgSrc: 'assets/icons/denied.svg',
              tap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => AllusersdeltedScreen()),);
              }
              ),
          DrawerListTile(
              title: 'Offres', svgSrc: 'assets/icons/Post.svg', tap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AllOffresScreen()),);
              }
              ),
          DrawerListTile(
              title: 'Candidatures',
              svgSrc: 'assets/icons/anciennes.svg',
              tap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllCandidaturesScreen()),);
              }
              ),
              DrawerListTile(
              title: 'Abonnements',
              svgSrc: 'assets/icons/abo.svg',
              tap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AllSubscriptionScreen()),);
              }
              ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: appPadding * 2),
            child: Divider(
              color: grey,
              thickness: 0.2,
            ),
          ),

          DrawerListTile(
              title: 'Paramètres',
              svgSrc: 'assets/icons/Setting.svg',
              tap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()),);
              }),
              
          
        ],
      ),
    );
  }
}
