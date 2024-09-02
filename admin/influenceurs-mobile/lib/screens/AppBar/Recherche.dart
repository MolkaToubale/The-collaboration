import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/constants/style.dart';
import 'package:responsive_admin_dashboard/providers/theme_notifier.dart';
import 'package:responsive_admin_dashboard/screens/AppBar/search_screen.dart';

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()),);
      },
      child:TextFormField(
                  readOnly: true,
                  style: style.text18,
                  decoration: InputDecoration(
                      
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: red,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      hintText: "Effectuez votre recherche par ici",
                      hintStyle: style.text18
                          .copyWith(color: style.invertedColor.withOpacity(.8)),
                      suffixIcon: const Icon(
                        Icons.search,
                        color: red,
                      )),
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (_) =>  SearchScreen())),
                ),
    );
  }
}
