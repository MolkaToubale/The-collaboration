// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:projet/constants/style.dart';
import 'package:projet/extra/Messenger/start_message_popup.dart';
import 'package:projet/extra/Messenger/timeAgo/get_time_ago.dart';
import 'package:projet/extra/models/messenger/conversation_model.dart';
import 'package:projet/providers/theme_notifier.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../models/messenger/message_model.dart';
import '../models/messenger/user/user.dart';
import '../providers/MessagesProvider.dart';
import '../providers/chat_room_provider.dart';
import 'chatter_screen.dart';
import 'const.dart';
import 'my_loading.dart';

class MessengerUI extends StatefulWidget {
  const MessengerUI({Key? key}) : super(key: key);

  @override
  MessengerUIState createState() => MessengerUIState();
}

class MessengerUIState extends State<MessengerUI> with WidgetsBindingObserver {
  late MessagesProvider conversationProvider;
  //instance des scrollController qui permet de controller la scrollabilité des widgets à l'écoute de ce controller
  final scrollController = ScrollController();
  final scrollControllerDoura = ScrollController();
 
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    context.read<UserProvider>().userLoginUpdateToFireBase();

    conversationProvider = context.read<MessagesProvider>();
    //partie initialisation des blocs
    conversationProvider.inite();
    //ajout d'un écouteur au ScrollController pour détecter lorsque l'utilisateur atteint la fin de la liste.
    // s'il atteint la fin de la liste la méthode loadMore() est appelée

    scrollControllerDoura.addListener(() {
      if (scrollControllerDoura.offset >=
          scrollControllerDoura.position.maxScrollExtent) {
        conversationProvider.loadMoreDoura();
      }
    });

    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        conversationProvider.loadMore();
      }
    });
  }
  
  //Cette méthode sert à rafraichir le flux de données 
  Future<void> pullToRefresh() async {
    return Future.value();
  }


  //Réagir aux changements d'état du cycle de vie de l'application
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    scrollControllerDoura.dispose();
  }


  @override
  Widget build(BuildContext context) {
    conversationProvider = context.read<MessagesProvider>();
    var size = MediaQuery.of(context).size;
    var style = context.watch<ThemeNotifier>();
    return Scaffold(
        backgroundColor: style.bgColor,

        appBar: AppBar(
        backgroundColor: style.panelColor,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: red,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Messages", style: style.title.copyWith(fontSize: 20)),
      ),

        floatingActionButton: SizedBox(
          width: 90,
          height: 90,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 5, 0),
            child: FloatingActionButton(
              splashColor: Colors.blueAccent,
              backgroundColor: red,
              onPressed: () {
                showModalBottomSheet<dynamic>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: ((builder) => const StartConversationPopUp()));
               
              },
              child: const Icon(
                Icons.add,
                size: 27.0,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
       
        body: RefreshIndicator(
          onRefresh: pullToRefresh,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<Conversation>>(
                      stream: conversationProvider.messagesDataBloc!.dataStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const MyLoading();
                        }

                        if (!snapshot.hasData) {
                          return Center(
                              child: Text(
                            'Aucune discussion trouvée.',
                            style: nunito18Black,
                          ));
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          List<Conversation>? conversations = snapshot.data;
                          conversations = conversationProvider.sortConversation(
                              conversations,
                              context.read<UserProvider>().currentUser);
                          if (conversations.isEmpty) {
                            return const Center(
                              child: Text('Aucune discussion trouvée.'),
                            );
                          }
                          return ListView.builder(

                              
                              controller: scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                             
                              shrinkWrap: true,
                              itemCount: conversations.length,
                              itemBuilder: (context, index) {
                               
                                return FutureBuilder(
                                    future: conversationProvider
                                        .getListMessagesFromConversation(
                                            conversations![index]),
                                    builder: (context, snap) {
                                     
                                      if (!snap.hasData) {
                                        return const SizedBox.shrink();
                                      }

                                      final messages = (snap.data
                                          as List<dynamic>)[2] as List<Message>;
                                      User? userFrom;

                                      User? userTo;
                                      if (context
                                              .read<UserProvider>()
                                              .currentUser!
                                              .id ==
                                          (snap.data as List<dynamic>)[0].id) {
                                        userFrom =
                                            (snap.data as List<dynamic>)[0];

                                        userTo =
                                            (snap.data as List<dynamic>)[1];
                                      } else {
                                        userFrom =
                                            (snap.data as List<dynamic>)[1];

                                        userTo =
                                            (snap.data as List<dynamic>)[0];
                                      }

                                      String? lastMsg;

                                      if (messages.length == 1) {
                                        lastMsg = messages[0].msgType == 'text'
                                            ? messages[0].msg.toString()
                                            : messages[0]
                                                    .msgType
                                                    .toString()
                                                    .contains('file')
                                                ? messages[0].from ==
                                                        userFrom?.id.toString()
                                                    ? "Vous avez envoyé un message"
                                                    : "${userTo?.name} a envoyé un message"
                                                : messages[0].from ==
                                                        userFrom?.id.toString()
                                                    ? "Vous avez envoyé une photo"
                                                    : "${userTo?.name} a envoyé une photo";
                                      } else if (messages.isEmpty) {
                                        lastMsg = null;
                                      } else {
                                        lastMsg = messages[messages.length - 1]
                                                    .msgType ==
                                                'text'
                                            ? messages[messages.length - 1]
                                                .msg
                                                .toString()
                                            : messages[messages.length - 1]
                                                    .msgType
                                                    .toString()
                                                    .contains('file')
                                                ? messages[messages.length - 1]
                                                            .from ==
                                                        userFrom?.id.toString()
                                                    ? "Vous avez envoyé une photo"
                                                    : "${userTo?.name} a envoyé une photo"
                                                : messages[messages.length - 1]
                                                            .from ==
                                                        userFrom?.id.toString()
                                                    ? "Vous avez envoyé une photo"
                                                    : "${userTo?.name} a envoyé une photo";
                                      }

                                      DateTime? lastMsgDate;

                                      if (messages.length == 1) {
                                        lastMsgDate = messages[0].date;
                                      } else if (messages.isEmpty) {
                                        lastMsgDate = null;
                                      } else {
                                        lastMsgDate =
                                            messages[messages.length - 1].date;
                                      }

                                      bool seenByThisUser = false;

                                      if (messages.length == 1) {
                                        seenByThisUser = messages[0].from ==
                                                userFrom?.id.toString()
                                            ? false
                                            : messages[0].seenBy!.contains(
                                                    userFrom?.id.toString())
                                                ? false
                                                : true;
                                      } else if (messages.isEmpty) {
                                        seenByThisUser = false;
                                      } else {
                                        seenByThisUser =
                                            messages[messages.length - 1]
                                                        .from ==
                                                    userFrom?.id.toString()
                                                ? false
                                                : messages[messages.length - 1]
                                                        .seenBy!
                                                        .contains(userFrom?.id
                                                            .toString())
                                                    ? false
                                                    : true; // Cette méthode vérifie si l'utilisateur actuel a vu le dernier message en fonction de l'émetteur du message et de la présence de son ID dans la liste 
                                      }

                                      return InkWell(
                                        onLongPress: () {
                                          showModalBottomSheet<dynamic>(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: ((builder) =>
                                                  bottomSheetConversation(
                                                      context,
                                                      userFrom?.id.toString(),
                                                      userTo?.id.toString(),
                                                      conversations![index].id,
                                                      Provider.of<UserProvider>(
                                                              context,
                                                              listen: false)
                                                          .currentUser!
                                                          .id
                                                          .toString())));
                                        },
                                        onTap: () async {
                                          Provider.of<ChatRoomProvider>(context,
                                                  listen: false)
                                              .setCurrentRoomId(
                                                  userFrom!, userTo!);

                                          await Provider.of<ChatRoomProvider>(
                                                  context,
                                                  listen: false)
                                              .inite()
                                              .then((value) {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .reStartListeningForMessagesUnReadCount();
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ChatterScreen()));
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      child: Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80),
                                                            color: style.bgColor,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .orange,
                                                                width: 3),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                  offset:
                                                                      Offset(
                                                                          0, 3),
                                                                  blurRadius:
                                                                      10,
                                                                  color: Colors
                                                                      .black38)
                                                            ],
                                                          ),
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          80),
                                                              image: userTo?.image ==
                                                                          null ||
                                                                      userTo!
                                                                          .image!
                                                                          .isEmpty
                                                                  ? const DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        "assets/images/ProfilPic.png",
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover)
                                                                  : DecorationImage(
                                                                      image: NetworkImage(
                                                                          userTo
                                                                              .image!),
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ),
                                                          ))),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${userTo?.name}".replaceFirst(
                                                                "${userTo?.name}"[
                                                                    0],
                                                                "${userTo?.name}"[
                                                                        0]
                                                                    .toUpperCase()),
                                                            style: TextStyle(
                                                                fontSize: 19,
                                                                color: style.invertedColor,
                                                                fontWeight: seenByThisUser
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .w400)),
                                                        Container(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                lastMsg != null
                                                                    ? lastMsg.length >=
                                                                            20
                                                                        ? '${lastMsg.substring(0, 20)}...'
                                                                        : lastMsg
                                                                    : "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight: seenByThisUser
                                                                        ? FontWeight
                                                                            .bold
                                                                        : FontWeight
                                                                            .normal)),
                                                            const SizedBox(
                                                              width: 25,
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.circle,
                                                                size: 5,
                                                                color:
                                                                    Colors.grey,
                                                              )),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                              child: Text(
                                                                  GetTimeAgo.getTimeAgoShort(
                                                                      lastMsgDate),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight: seenByThisUser
                                                                          ? FontWeight
                                                                              .bold
                                                                          : FontWeight
                                                                              .normal)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //Spacer(),
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 1,
                                              thickness: 0.3,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              });
                        }

                        return Container();
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget bottomSheetConversation(BuildContext context, String? userFromId,
      String? userToId, String? convId, String? currentUserId) {
    return Container(
      height: 150,
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(13.0),
          topRight: Radius.circular(13.0),
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 0),
            Container(
              alignment: Alignment.center,
              height: 5,
              width: 30,
              decoration: BoxDecoration(color: Colors.grey.shade600),
              margin: const EdgeInsets.only(left: 15, right: 15),
            ),
            const SizedBox(height: 15),
            Column(
             
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0.0,
                  shadowColor: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () async {
                        conversationProvider.deleteConversation(
                            convId!, userFromId!);
                      Navigator.pop(context);
                        
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.transparent),
                        
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                      ),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: const [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Supprimer cette conversation",
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
