
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/providers/candidature_provider.dart';
import 'package:responsive_admin_dashboard/screens/all_candidatures/all_candidatures_dashboard.dart';
import 'package:responsive_admin_dashboard/widgets/view.dart';
import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';


class CandidatureDetails extends StatefulWidget {
  
  var candidature;
  CandidatureDetails(this.candidature,);

  @override
  State<CandidatureDetails> createState() => _CandidatureDetailsState();
}

class _CandidatureDetailsState extends State<CandidatureDetails> {

 
  @override
  Widget build(BuildContext context) {
    var style = context.watch<ThemeNotifier>();
   final provider=Provider.of<CandidatureProvider>(context);

   

    
    return Scaffold(
      backgroundColor: style.bgColor,
     
      appBar: AppBar(
        backgroundColor: style.panelColor,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundColor: red,
              child: IconButton(
                  onPressed: (){
                      Navigator.pop(context) ; 
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ))),
        ),

         actions: [
           
          GestureDetector(
            child: Icon(
              Icons.delete_forever_outlined,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
               showDialog(
                                context: context,
                               builder: (context) => AlertDialog(
                               title: const Text("Suppression de la collaboration"),
                              content: const Text(
                          "La suppression de la collaboration conduit à sa suppression définitive du profil de l'influenceur ainsi que du profil du représentant de l'entreprise ",
                        ),
                                          actions: [
                                           TextButton(
                                          onPressed: () {
                         
                          provider.deleteCandidature(widget.candidature);
                          Fluttertoast.showToast( msg: "Suppression de la collaboration avec succés");
                         Navigator.push(context,MaterialPageRoute(builder: (context) =>AllCandidaturesScreen() ),);
                      
                                          },
                                           child: const Text('OK'),
                                    ),
                                     TextButton(
                                          onPressed: () {
                         Fluttertoast.showToast( msg: "Suppression de la collaboration annulée");
                         Navigator.pop(context);
                      
                                          },
                                           child: const Text('Annuler'),
                                    ),
                                  ],
                                ),
                              );
                           
            },
          ),
          const SizedBox(
            width: 15,
          ),
        ],
         title:Text(widget.candidature.libelleOffre,style: style.title.copyWith(color: red, fontSize: 19),),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: style.bgColor,
                      
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Image.network(
                     widget.candidature!.affiche,
                      fit: BoxFit.fitWidth,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Libellé:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.candidature.libelleOffre,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
             Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nom de l\'entreprise:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.candidature.nomEntreprise,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),
              
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nom du Candidat:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.candidature.nomInfluenceur,
                           style: style.text18.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                   
                  ],
                ),
              ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Motivation:",
                          style: TextStyle(
                            color: red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(child: Icon(Icons.file_copy_outlined,color: red,),onTap: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => View(url: widget.candidature.fileUrl))); 
                            },)
                      ],
                    ),
                    Text(
                      widget.candidature.motivation,
                      style: style.text18.copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        ),
      ),
    );
  }
}
