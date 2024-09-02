
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/responsive.dart';
import 'package:responsive_admin_dashboard/providers/admin_provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';


class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(
      color: style.panelColor,
      child: Row(
        children: [
          Container(
    
            margin: EdgeInsets.only(left: appPadding),
            padding: EdgeInsets.symmetric(
              horizontal: appPadding,
              vertical: appPadding / 2,
            ),
            child: Row(
              children: [
              
                if(!Responsive.isMobile(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: appPadding / 2),
                  child: Text(context.read<AdminProvider>().currentAdmin!.nomPrenom,style: style.title.copyWith(fontWeight: FontWeight.w800,fontSize: 22),),
                ),
                GestureDetector(
                  onTap: () {
                  
                   context.read<AdminProvider>().signOut(context);
                  },
                  child: Icon(Icons.output_rounded,color: style.invertedColor,)
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
