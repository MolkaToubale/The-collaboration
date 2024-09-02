import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/screens/Donn%C3%A9es.dart/analytic_cards_candidatures.dart';
import 'package:responsive_admin_dashboard/screens/chart/custom_appbar.dart';
import 'package:responsive_admin_dashboard/screens/utilisateurs/utilisateurs.dart';
import 'all_candidatures_table.dart';





class AllCandidaturesContent extends StatelessWidget {
  const AllCandidaturesContent({Key? key}) : super(key: key);

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
                          AnalyticCardsCandidatures(),
                          SizedBox(
                            height: appPadding,
                          ),
                        CandidatureFiles(),
                       //   if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                      //   if (Responsive.isMobile(context)) utilisateur(),
                        ],
                      ),
                    ),
                 //   if (!Responsive.isMobile(context))
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
                       //   if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                         
                       //   if (Responsive.isMobile(context))
                            SizedBox(
                              height: appPadding,
                            ),
                          
                        ],
                      ),
                    ),
                 //   if (!Responsive.isMobile(context))
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