import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/screens/Donn%C3%A9es.dart/analytic_cards.dart';
import 'package:responsive_admin_dashboard/screens/Donn%C3%A9es.dart/analytic_cards_offres.dart';
import 'package:responsive_admin_dashboard/screens/chart/custom_appbar.dart';
import 'package:responsive_admin_dashboard/screens/chart/users.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs_detail.dart';

//import 'all_users_tabele_info.dart';



class AllSettingsContent extends StatelessWidget {
  const AllSettingsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(appPadding),
        child: Column(
          children: [
            CustomAppbar(),
            SizedBox(
              height: appPadding,
            ),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                         
                          SizedBox(
                            height: appPadding,
                          ),
                        // Allusertableinfo(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                         if (Responsive.isMobile(context)) Utilisateur(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                    // if (!Responsive.isMobile(context))
                    //    Expanded(
                    //     flex: 2,
                    //     //child:utilisateur(),
                    //    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            height: appPadding,
                          ),
                          
                          SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                         
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                   
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}