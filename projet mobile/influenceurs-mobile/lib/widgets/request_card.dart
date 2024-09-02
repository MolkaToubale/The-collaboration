

import 'package:flutter/material.dart';
import 'package:projet/constants/style.dart';

import 'package:projet/providers/theme_notifier.dart';
import 'package:projet/screens/candidatures/candidatures_d%C3%A9tails.dart';
import 'package:provider/provider.dart';


import '../../providers/candidature_provider.dart';
import '../../widgets/buttom_bar.dart';

class RequestWidget extends StatefulWidget {
  var candidature;
  RequestWidget({
    Key? key,
    required this.candidature,
  }) : super(key: key);

  @override
  _RequestWidgetState createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
    
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<CandidatureProvider>(context);
    var style = context.watch<ThemeNotifier>();
    final candidatures=provider.candidatures;
    return Container(
      color: style.bgColor,
      child: Container(
        color: style.bgColor,
        child: Card(
          color: style.bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: SizedBox(
                  height: 100,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.candidature.affiche),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal:8.0, vertical:4),
                      child: Text(
                        widget.candidature.libelleOffre,
                        style: style.title.copyWith(fontWeight: FontWeight.bold,fontSize: 17),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.candidature.nomInfluenceur,
                        style: style.title.copyWith(fontSize:16 ),
                      ),
                    ),
                    
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: Text("vient de vous envoyer sa candidature",
                                   style: style.text18.copyWith(fontSize: 13),
                                   ),
                                ),
                              ],
                            ),
                            
                          ],
                        )),
                    SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {

                             provider.acceptAndUpdateCandidature(widget.candidature);

                             Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const BottomNavController()),
                             (route) =>false ,
                               );
                          },
                          child: Text('Accepter'),
                          style: ElevatedButton.styleFrom(
                            primary:red,
                            onPrimary: style.bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        OutlinedButton(
                          onPressed: () {
                           provider.refuseAndUpdateCandidature(widget.candidature);

                            Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const BottomNavController()),
                             (route) => false,
                               );
                          },
                          child: Text('Decliner'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.pink[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                                color: Color(0xFFE91E63), width: 2.0),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        OutlinedButton(
                          onPressed: () {
                                  Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => CandidatureDetails(widget.candidature)),
                             
                               );
                          },
                          child: Text('View Details'),
                          style: OutlinedButton.styleFrom(
                            primary: Colors.pink[400],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                                color: Color(0xFFE91E63), width: 2.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
