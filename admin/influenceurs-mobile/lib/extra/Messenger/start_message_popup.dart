import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:responsive_admin_dashboard/extra/Messenger/const.dart';

import '../../models/user.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../../services/navigation_service.dart';
import '../providers/chat_room_provider.dart';
import 'chatter_screen.dart';

class StartConversationPopUp extends StatefulWidget {


  @override
  State<StartConversationPopUp> createState() => _StartConversationPopUpState();
}

class _StartConversationPopUpState extends State<StartConversationPopUp> {
  final TextEditingController _controller = TextEditingController();
  List<UserModel> suggestions = [];
  List<UserModel> allUsers = [];


  @override
  void initState() {
    super.initState();
    initUsers();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    suggestions = allUsers
        .where((element) => element.nomPrenom
            .toString()
            .toLowerCase()
            .contains(_controller.text.toLowerCase()))
        .toList();
    setState(() {});
  }

  void initUsers() async {
    final data = await FirebaseFirestore.instance
        .collection("users")
        .where("id", isNotEqualTo: context.read<UserProvider>().currentUser!.id)
        .get();
    for (var d in data.docs) {
      allUsers.add(UserModel.fromMap(d.data()));
    }
    log(allUsers.toString());
    suggestions = allUsers;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
     var style = context.watch<ThemeNotifier>();
    return DraggableScrollableSheet(
        initialChildSize: 0.9,
        builder: (context, controller) => Container(
            height: size.height,
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: style.bgColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  const SizedBox(
                    height: 10,
                  ),
                 
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: size.width,
                    child: TextField(
                      controller: _controller,
                      style: nunito18Black,
                      decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.search,
                            color: Colors.blueGrey,
                          ),
                          hintText: 'Recherche...',
                          hintStyle:
                              style.text18.copyWith(fontSize: 20),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey, width: 1),
                          ),
                          focusColor: Colors.blueGrey),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...suggestions.map((e) => Card(
                        elevation: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 5),
                          child: ListTile(
                            onTap: () async {
                             
                              context.read<ChatRoomProvider>().setCurrentRoomId(
                                  context
                                      .read<UserProvider>()
                                      .currentUser!
                                      .toUser(),
                                  e.toUser());
                              await context
                                  .read<ChatRoomProvider>()
                                  .inite()
                                  .then((value) {
                                context
                                    .read<UserProvider>()
                                    .reStartListeningForMessagesUnReadCount();
                              });

                              Navigator.push(
                                NavigationService.navigatorKey.currentContext!,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatterScreen()),
                              );
                            },
                            title: Text(
                              e.nomPrenom,
                              style: style.title.copyWith(fontSize: 18),
                            ),
                            leading: Container(
                                height: 60,
                                width: 60,
                                margin: const EdgeInsets.only(left: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: bgColor,
                                  border: Border.all(
                                      color: Colors.orange, width: 3),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 4,
                                        color: Colors.black38)
                                  ],
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: e.photo.isEmpty
                                        ? const DecorationImage(
                                            image: AssetImage(
                                              "assets/images/ProfilPic.png",
                                            ),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            image: NetworkImage(e.photo),
                                            fit: BoxFit.cover),
                                  ),
                                )),
                          ),
                          color: style.bgColor,
                        ),
                      ))
                  
                ],
              ),
            )));
  }
}
