import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';




class Loading extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(
      color:style.bgColor,
      child: const Center(
        child: SpinKitFadingCircle(
          color: Colors.pink,
          size: 40.0,
        ),
      ),
    );
  }
}
