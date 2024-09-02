import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/constants.dart';
import 'package:responsive_admin_dashboard/constants/helpers.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:responsive_admin_dashboard/models/analytic_info_model.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';

class AnalyticInfoCard extends StatelessWidget {
  const AnalyticInfoCard({Key? key, required this.info}) : super(key: key);

  final AnalyticInfo info;

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return Container(
      
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: appPadding / 2,
      ),
      decoration: BoxDecoration(
          color: style.navBarColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style.text18.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                    "${info.count}",
                    style:style.text18.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                   
              Container(
                padding: EdgeInsets.all(appPadding / 2),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.1),
                    shape: BoxShape.circle),
                child:SvgPicture.asset(
                  info.svgSrc!,
                  color: info.color,
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}
