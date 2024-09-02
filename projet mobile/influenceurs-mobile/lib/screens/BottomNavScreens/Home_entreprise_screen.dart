import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:projet/models/offre.dart';
import 'package:projet/screens/offres/categorie_It.dart';
import 'package:projet/screens/offres/categorie_autres.dart';
import 'package:projet/screens/offres/categorie_beaute.dart';
import 'package:projet/screens/offres/categorie_formation.dart';
import 'package:projet/screens/offres/categorie_gastronomie.dart';
import 'package:projet/screens/offres/categorie_param%C3%A9dical.dart';
import 'package:projet/screens/offres/categorie_photographie.dart';
import 'package:projet/screens/offres/categorie_sport.dart';
import 'package:projet/screens/search_screen.dart';
import 'package:projet/widgets/offre_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/style.dart';
import '../../extra/Messenger/Messenger_ui.dart';
import '../../providers/offre_provider.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<OffreModel> offres = [];

 
    bool isSpeaking = false;
  
  final FlutterTts flutterTts=FlutterTts();
  speak(String text) async{
    try {
      await flutterTts.setLanguage('fr');
      await flutterTts.setPitch(0.5);
      await flutterTts.setVolume(1);
      
      await flutterTts.speak(text);

    log('5edmet');

    } catch (e) {
      log('erreur speak $e');
    }
   

  }

   stopSpeaking() async{
    await flutterTts.stop();
  }

  @override
  void initState() {
    setState(() {});
    
    context.read<OffreProvider>().getOffres();
    
    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = context.watch<UserProvider>().currentUser;
    var style = context.watch<ThemeNotifier>();
    final offres = Provider.of<OffreProvider>(context).offresCourantes;
    setState(() {});
    Widget socialMediaIcon({required String title, required String url}) {
      return Column(
        children: [
          Container(
           

            decoration: BoxDecoration(
              color: style.invertedColor.withOpacity(style.darkMode ? .4 : .05),
              border: Border.all(
                color: red.withOpacity(.1),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              url,
              height: 50,
              width: 50,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: style.text18,
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: AppBar(
        backgroundColor: style.panelColor,
        elevation: 1,
        actions: [
          
          const SizedBox(
            width: 25,
          ),
          GestureDetector(
            child: Icon(
              CupertinoIcons.bubble_left_bubble_right_fill,
              color: style.invertedColor.withOpacity(.8),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MessengerUI()),
              );
            },
          ),
          const SizedBox(
            width: 15,
          ),

             GestureDetector(
  child: Icon(
    CupertinoIcons.speaker_2_fill,
    color: style.invertedColor.withOpacity(.8),
  ),
  onTap: () async {
  
   
      if (isSpeaking) {
      // Si la lecture est en cours, mettre en pause
      stopSpeaking();
    } else {
      // Sinon, reprendre la lecture
         await speak('L\'interface Accueil vous permet de visualiser toutes les offres pour lesquelles vous pouvez postuler à savoir  ${offres.length.toString()} offres. Vous pouvez également effectuer une recherche à partir de la barre de recherche ou bien trier les offres selon leur catégories et ceci à partir des icones sitoués sous la barre de recherche');

     
    }
    isSpeaking = !isSpeaking; 
    print('pressed');
    
  },
),
          const SizedBox(
            width: 15,
          ),
        ],

        title: Row(
          children: [
            Image.asset(
              'images/logoGris.png',
              height: 50,
            ),
            const SizedBox(width: 10),
          ],
        ),

        // centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  readOnly: true,
                  style: style.text18,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        borderSide: BorderSide(
                          color: red,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
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
                      CupertinoPageRoute(builder: (_) => const SearchScreen())),
                ),
              ),
            ),
            // higlights
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                // width: MediaQuery.of(context).size.width,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: socialMediaIcon(title: 'IT', url: 'images/IT.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategorieIT()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Photographie',
                          url: 'images/photographie.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoriePhotographie()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Beauté',
                          url: 'images/beaute et bien etre.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategorieBeaute()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Gastronomie', url: 'images/gastronomie.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorieGastronomie()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Sport', url: 'images/sport.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CategorieSport()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Formation', url: 'images/education.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorieFormation()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Paramédical', url: 'images/paramedical.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategorieParamedical()));
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      child: socialMediaIcon(
                          title: 'Autres', url: 'images/autres.png'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CategoriesAutres()));
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Expanded(
                child: offres.isEmpty
                    ? Center(
                        child: Text(
                        "Aucune publication pour le moment!",
                        style: style.title.copyWith(fontSize: 13),
                      ))
                    : GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: offres.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 10),
                        itemBuilder: (_, index) {
                          return OffreWidget(offre: offres[index]);

                         
                        },
                      )),
          ],
        ),
      ),
    );
  }
}
