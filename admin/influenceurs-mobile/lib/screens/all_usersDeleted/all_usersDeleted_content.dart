import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/screens/chart/custom_appbar.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs.dart';
import '../Données.dart/analytic_cards_deletedUsers.dart';
import 'all_usersDeltedTable_info.dart';





class AllusercontentDeletd extends StatelessWidget {
  const AllusercontentDeletd({Key? key}) : super(key: key);

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
                          AnalyticCardsUsersDeleted(),
                          SizedBox(
                            height: appPadding,
                          ),
                       Allusersdelted(),
                          if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                         if (Responsive.isMobile(context)) Utilisateur(),
                        ],
                      ),
                    ),
                    // if (!Responsive.isMobile(context))
                    //   SizedBox(
                    //     width: appPadding,
                    //   ),
                    //  if (!Responsive.isMobile(context))
                    //     Expanded(
                    //      flex: 2,
                    //      child: UsersFiles(),
                    //     ),
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