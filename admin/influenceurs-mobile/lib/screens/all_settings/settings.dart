import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/screens/all_settings/modify_password.dart';
import 'package:responsive_admin_dashboard/screens/dashbord/dash_board_screen.dart';

import '../../../../constants/style.dart';
import '../../../../providers/theme_notifier.dart';
import '../../../../providers/user_provider.dart';
import '../../providers/admin_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driver = context.watch<AdminProvider>().currentAdmin!;
    var style = context.watch<ThemeNotifier>();
    var size = MediaQuery.of(context).size;
    Widget detailCard(
        {required BuildContext context,
        required IconData icon,
        required String title,
        Widget? screen,
        bool? switchValue,
        void Function(bool)? onSwitchTap}) {
      var style = context.watch<ThemeNotifier>();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(top: 0),
        child: Card(
          color: style.bgColor,
          elevation: 1,
          child: InkWell(
            onTap: screen == null
                ? null
                : () async {
                    await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => screen);
                  },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: blue.withOpacity(.1)),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white.withOpacity(style.darkMode ? 0.1 : 1),
              ),
              width: double.infinity,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.grey,
                    size: 25,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(title, style: style.text18),
                  const Spacer(),
                  if (switchValue != null)
                    CupertinoSwitch(
                        activeColor: blue,
                        value: switchValue,
                        onChanged: onSwitchTap ??
                            (value) {
                              log(title);
                            }),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: red,
                child: IconButton(
                  onPressed: () =>    Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoardScreen()),),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        title:Text('Paramètres',style: style.title.copyWith(color: red,fontSize: 22),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailCard(
                context: context,
                icon: Icons.dark_mode_outlined,
                switchValue: style.darkMode,
                onSwitchTap: (value) =>
                    context.read<ThemeNotifier>().changeDarkMode(value),
                title: "Mode sombre"),
            //  detailCard(
            //      context: context,
            //      icon: Icons.notifications_none_rounded,
            //      switchValue: true,
            //      // onSwitchTap: (bool value) =>
            //         context.read<AdminProvider>().changeNoticationStatus(value),
            //      title: "Notifications"),
           
            detailCard(
                context: context,
                icon: Icons.password_outlined,
               // switchValue: false,
                screen: ModifyPassword(),
                 onSwitchTap: (value) =>
                     context.read<ThemeNotifier>().changeDarkMode(value),
                 title: "Modifier Mot de Passe"),
                
                 

                 GestureDetector(
                  onTap: () {
                    context.read<AdminProvider>().signOut(context);
                  },
                   child: detailCard(
                                 context: context,
                                 icon: CupertinoIcons.square_arrow_right,
                                // switchValue: false,
                    
                                 title: "Déconnexion"),
                 ),
                 
                
          ],
        ),
      ),
    );
  }
}
