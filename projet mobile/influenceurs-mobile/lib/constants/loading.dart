import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:projet/constants/style.dart';

import 'package:provider/provider.dart';


import '../providers/theme_notifier.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(
      color:style.bgColor,
      child: const Center(
        child: SpinKitFadingCircle(
          color: red,
          size: 40.0,
        ),
      ),
    );
  }
}
