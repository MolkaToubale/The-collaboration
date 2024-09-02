import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/screens/Donn%C3%A9es.dart/analytic_cards.dart';
import 'package:responsive_admin_dashboard/screens/Donn%C3%A9es.dart/analytic_cards_offres.dart';
import 'package:responsive_admin_dashboard/screens/all_offres/all_offres_tables.dart';
import 'package:responsive_admin_dashboard/screens/chart/custom_appbar.dart';
import 'package:responsive_admin_dashboard/screens/chart/users.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs_detail.dart';


import 'chart_offres.dart';

//import 'all_users_tabele_info.dart';



class AllOffresContent extends StatelessWidget {
  const AllOffresContent({Key? key}) : super(key: key);

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
                          AnalyticCardsOffres(),
                          SizedBox(
                            height: appPadding,
                          ),
                        OffresFiles(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                        //  if (Responsive.isMobile(context)) utilisateur(),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      SizedBox(
                        width: appPadding,
                      ),
                     if (!Responsive.isMobile(context))
                        Expanded(
                         flex: 2,
                         child:StarageDetails(),
                        ),
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