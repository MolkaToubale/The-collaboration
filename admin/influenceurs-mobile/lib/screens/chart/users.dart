import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/chart/pie_Chart.dart';



class Users extends StatelessWidget {
  const Users({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(
      height: 400,
      width: double.infinity,
      padding: EdgeInsets.all(appPadding),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Entreprises/Abonnements",
            style: style.text18.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              
            ),
          ),
           Expanded(
             child: PieChartWidget(),
           )
        ],
      ),
    );
  }
}
