// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as paf;
import 'package:provider/provider.dart';

import 'package:responsive_admin_dashboard/extra/Messenger/timeAgo/get_time_ago.dart';
import 'package:responsive_admin_dashboard/extra/Messenger/user_image_network_bounce.dart';
import 'package:responsive_admin_dashboard/extra/models/messenger/user/user.dart';

import '../../constants/style.dart';
import '../../providers/theme_notifier.dart';
import '../../providers/user_provider.dart';
import '../models/messenger/message_model.dart';
import '../providers/MessagesProvider.dart';
import '../providers/chat_room_provider.dart';
import 'Image_network_msg.dart';
import 'const.dart';
import 'constants.dart';
import 'gradientText.dart';
import 'my_loading.dart';

//String username = 'User';
//String email = 'user@example.com';
//String? messageText;
//FirebaseUser loggedInUser;

class ChatterScreen extends StatefulWidget {
  

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen>
    with WidgetsBindingObserver {
  final chatMsgTextController = TextEditingController();
  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    chatMsgTextController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatMsgTextController.text.length));
  }

  _onBackspacePressed() {
    chatMsgTextController
      ..text = chatMsgTextController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: chatMsgTextController.text.length));
  }

  @override
  Widget build(BuildContext context) {
     var style = context.watch<ThemeNotifier>();
    final uniqueRoomChatId =
        Provider.of<ChatRoomProvider>(context).currentRoomId;
    var userFrom = context.read<UserProvider>().currentUser;
    var userTo = context.read<ChatRoomProvider>().userto;
    UploadTask? uploadImageToFireBase(String destination, File file) {
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        return ref.putFile(file);
      } on FirebaseException {
        return null;
      }
    }

    PickedFile? imageFile_;
    File? imageFile;
    UploadTask? task;
    final ImagePicker imagePicker = ImagePicker();

    Future<bool> uploadImage() async {
      if (imageFile != null) {
        final fileName = paf.basename(imageFile!.path);

        final destination = 'messenger/$uniqueRoomChatId/$fileName';
        task = uploadImageToFireBase(destination, imageFile!);
        if (task == null) return false;
        final snapShot = await task!.whenComplete(() => {});
        final imageUrl = await snapShot.ref.getDownloadURL();

        await Provider.of<UserProvider>(context, listen: false).addChat(
            Provider.of<ChatRoomProvider>(context, listen: false).userfrom!,
            Provider.of<ChatRoomProvider>(context, listen: false).userto!,
            imageUrl,
            "image");
      }
      return false;
    }

    Future<void> pickImageFrom(ImageSource source) async {
      PickedFile? pickedFile;
      try {
        pickedFile = await imagePicker.getImage(
          source: source,
          maxWidth: 720,
          imageQuality: 30,
        );
      } finally {
        if (pickedFile != null) {
          setState(() {
            imageFile_ = pickedFile;
            imageFile = File(imageFile_!.path);
            //_imageProvider = File(pickedFile.path);
          });
          // Provider.of<UserProvider>(context, listen: false)
          //     .updateIsProcessing();
          await uploadImage();

          //stqrt loading here

          /*progress!.showWithText(getTranslated("loading...")!);
        await uploadImage();

  */
        }
      }
    }

/*    if (defaultTargetPlatform != TargetPlatform.iOS)
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark));*/
    return Scaffold(
      backgroundColor: style.bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // here the desired height
        child: Material(
          elevation: 0,
          child: AppBar(
            
            iconTheme: const IconThemeData(color: Colors.black54),
            // bottom: PreferredSize(
            //     child: Container(
            //       color: Colors.white54,
            //       height: 0.5,
            //     ),
            //     preferredSize: const Size.fromHeight(0.5)),
            centerTitle: true,
            
            title: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(Provider.of<ChatRoomProvider>(context, listen: false)
                        .userto!
                        .id)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.data != null) {
                    log((snapshot.data!.data()
                            as Map<String, dynamic>)['isLoggedIn']
                        .toString());
                    bool isConnected = (snapshot.data!.data()
                                as Map<String, dynamic>)['isLoggedIn'] ==
                            "true"
                        ? true
                        : false;
                    return Row(
                      children: [
                        Stack(
                          //fit: StackFit.loose,
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10.0, top: 10),
                              child: UserImageNetwork(
                                width: 35,
                                height: 35,
                                image: Provider.of<ChatRoomProvider>(context,
                                        listen: false)
                                    .userto!
                                    .image,
                                marginAsDouble: 0,
                                function: () {},
                              ),
                            ),
                            !isConnected
                                ? Positioned(
                                    bottom: 0,
                                    right: 9,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 13,
                                      width: 13,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    bottom: 0,
                                    right: 9,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      height: 13,
                                      width: 13,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                                "${Provider.of<ChatRoomProvider>(context, listen: false).userto!.name}",
                                style:  TextStyle(
                                    // color: Provider.of<ThemeProvider>(context)
                                    //         .isDarkMode
                                    //     ? Colors.white
                                    //     : Colors.black,
                                    color: style.invertedColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 2,
                            ),
                            
                          ],
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                }),
            backgroundColor: style.bgColor,
            shadowColor: Colors.blueAccent.withOpacity(0.25),
            //bottomOpacity: 0,
            leading: Container(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                splashRadius: 25,
                icon:  Icon(Icons.arrow_back_ios, color: style.invertedColor,),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
            child: Container(
          // height: MediaQuery.of(context).size.height * .5,
          color: style.bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: ChatStream(
                      uniqueChatRoomId: uniqueRoomChatId,
                      userForm: userFrom,
                      userTo: userTo,
                      scrollController: scrollController)),
              

              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: const Config(
                          columns: 7,
                          emojiSizeMax: 32.0,
                          verticalSpacing: 0,
                          horizontalSpacing: 0,
                          initCategory: Category.RECENT,
                        //  bgColor: Color(0xFFF2F2F2),
                          indicatorColor: Colors.blue,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.blue,
                          backspaceColor: Colors.blue,
                          showRecentsTab: true,
                          recentsLimit: 28,
                          categoryIcons: CategoryIcons(),
                          buttonMode: ButtonMode.MATERIAL)),
                ),
              ),
              Container(
                height: 70,
                //width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: style.bgColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 0),
                  child: Row(
                    children: [
                      Material(
                        clipBehavior: Clip.hardEdge,
                        type: MaterialType.transparency,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        child: IconButton(
                          onPressed: () {
                            emojiShowing = !emojiShowing;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.emoji_emotions,
                            color: Colors.cyanAccent,
                            size: 30,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: style.bgColor,
                              borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: TextField(
                              style: style.text18.copyWith(fontSize: 15),
                              maxLength: 700,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onChanged: (value) async {
                                // if (value.isNotEmpty) {
                                //   await context
                                //       .read<UserProvider>()
                                //       .userTypingUpdateToFireBase();
                                // } else {
                                //   await context
                                //       .read<UserProvider>()
                                //       .userStopTypingUpdateToFireBase();
                                // }
                              },
                              cursorColor: Colors.blueAccent,
                              controller: chatMsgTextController,
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                        ),
                      ),

                      //Expanded(child: TextField()),
                      Material(
                        clipBehavior: Clip.hardEdge,
                        type: MaterialType.transparency,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Consumer<UserProvider>(
                            builder: (_, provider, __) => provider.isProcessing
                                ? const IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.photo,
                                      color: Color(0xFFBFC4D3),
                                      size: 30,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await pickImageFrom(ImageSource.gallery);
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Color(0xFFBFC4D3),
                                      size: 30,
                                    ),
                                  )),
                      ),
                      Material(
                        clipBehavior: Clip.hardEdge,
                        type: MaterialType.transparency,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0)),
                        child: Consumer<UserProvider>(
                          builder: (_, provider, __) => provider.isProcessing
                              ? const MyLoading()
                              : IconButton(
                                  onPressed: () async {
                                    if (true &&
                                        chatMsgTextController.text != "" &&
                                        chatMsgTextController.text.trim() !=
                                            '') {
                                      final resultString =
                                          chatMsgTextController.text.replaceAll(
                                              RegExp(
                                                  r'(?:[\t ]*(?:\r?\n|\r))+'),
                                              '\n');

                                      await Provider.of<UserProvider>(context,
                                              listen: false)
                                          .addChat(
                                              Provider.of<ChatRoomProvider>(
                                                      context,
                                                      listen: false)
                                                  .userfrom!,
                                              Provider.of<ChatRoomProvider>(
                                                      context,
                                                      listen: false)
                                                  .userto!,
                                              resultString,
                                              'text');
                                      //add to both users the new roomChat id
                                      //add to roomChat new msg

                                      //listen for new msg in currentUser.roomChat
                                    } else {
                                      //get msglist from roomChatid and load here
                                    }

                                    chatMsgTextController.clear();

                                 
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  var chatProvider;
  var conversationProvider;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    chatProvider = Provider.of<ChatRoomProvider>(context, listen: false);
    conversationProvider =
        Provider.of<MessagesProvider>(context, listen: false);
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        chatProvider.loadMore();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final chatRoomProvider =
        Provider.of<ChatRoomProvider>(context, listen: false);
    switch (state) {
      case AppLifecycleState.resumed:
        await chatRoomProvider.listenStreamSubscription();
        // NotificationService.cancelNotifSub();
        break;
      case AppLifecycleState.inactive:
        await chatRoomProvider.disposeStreamSubscription();
        // NotificationService.sub();
        break;
      case AppLifecycleState.paused:
        //await chatRoomProvider.disposeStreamSubscription();
        //NotificationService.sub();
        break;
      case AppLifecycleState.detached:
        //await chatRoomProvider.disposeStreamSubscription();
        break;
    }
  }

  @override
  void dispose() async {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    await chatProvider.disposeStreamSubscription();
    //await conversationProvider.disposeStreamSubscription();
    /*await Provider.of<MessagesProvider>(context, listen: false)
        .disposeStreamSubscription();*/
    // NotificationService.sub();
  }
}

class ChatStream extends StatelessWidget {
  final String? uniqueChatRoomId;
  final dynamic userForm;
  final dynamic userTo;
  final ScrollController? scrollController;

  const ChatStream(
      {Key? key,
      this.uniqueChatRoomId,
      this.userForm,
      this.userTo,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatRoomProvider>(context, listen: false);
    bool previousIcu = false;
    return StreamBuilder<List<Message>>(
        stream: chatProvider.messagesDataBloc!.dataStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MyLoading();
          }

          if (!snapshot.hasData) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GradientText(
                    "Say Hi to ${context.read<ChatRoomProvider>().userto!.name}",
                    textStyle: const TextStyle(
                        fontFamily: 'ArialRounded',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    size: 20,
                    gradient: const LinearGradient(colors: [
                      Color.fromARGB(255, 6, 205, 255),
                      Color.fromARGB(255, 42, 137, 245),
                      Color.fromARGB(255, 34, 30, 248)
                    ])),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "👋",
                  style: TextStyle(fontSize: 70),
                ),
              ],
            ));
          }

          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.active) {
            final List<Message>? messages = snapshot.data;
            //final messages = (snapshot.data as List<dynamic>);

            //_seenByConfiguration(messages);
            return ListView.builder(
                //addAutomaticKeepAlives: true,
                //cacheExtent: double.infinity,
                controller: scrollController,
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                itemCount: messages!.length,
                itemBuilder: (context, index) {
                  String? lastMsgWithSeenId = messages
                          .where((element) =>
                              element.seenBy!.isNotEmpty &&
                              element.from == userForm!.id)
                          .isNotEmpty
                      ? messages
                          .where((element) =>
                              element.seenBy!.isNotEmpty &&
                              element.from == userForm!.id)
                          .first
                          .id
                      : null;

                  int i = index + 1;
                  if (i > messages.length - 1) i = index;
                  final userId = messages[index].from;

                  final icu = Provider.of<UserProvider>(context, listen: false)
                          .currentUser!
                          .id ==
                      userId;

                  if (index == 0) {
                    previousIcu = true;
                  } else {
                    //   GetTimeAgo.parse(dateTime)
                    //     GetTimeAgo.setDefaultLocale(messages[i].date);
                    previousIcu = messages[i].from == messages[index].from;
                  }

                  // final User? user =
                  //     Provider.of<SkillsProvider>(context, listen: false)
                  //         .allSkills!
                  //         .where((element) => element.user!.id == userId)
                  //         .first
                  //         .user;

                  return Column(
                    children: [
                      if ((messages[index].date!.millisecondsSinceEpoch -
                                  messages[i].date!.millisecondsSinceEpoch) >=
                              900000 * 2 ||
                          i == index)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                // GetTimeAgo.getTimeAgo(messages[index].date),
                                GetTimeAgo.getTimeAgo(messages[index].date!),
                                style: nunito15grey,
                              ),
                            ],
                          ),
                        ),
                      Consumer<ChatRoomProvider>(
                        builder: (context, provider, _) => ChatBubble(
                            mTest: lastMsgWithSeenId != null
                                ? lastMsgWithSeenId == messages[index].id
                                    ? true
                                    : false
                                : false,
                            mSeenBy: messages[index].seenBy!,
                            myMsgType: messages[index].msgType!,
                            isMe: icu,
                            message: messages[index].msg!,
                            messageType: 5,
                            user: userTo,
                            date: messages[index].date!),
                      ),
                    ],
                  );
                });
          }

          return Container();
        });
  }
}

class ChatBubble extends StatefulWidget {
  final List<dynamic> mSeenBy;
  final bool mTest;
  final bool isMe;
  final User? user;
  final String message;
  final int messageType;
  final String myMsgType;
  final DateTime date;

  const ChatBubble({
    Key? key,
    required this.mSeenBy,
    required this.mTest,
    required this.isMe,
    required this.user,
    required this.message,
    required this.messageType,
    required this.myMsgType,
    required this.date,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  bool showDate = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isMe) {
      if (widget.myMsgType == 'image') {
        return Padding(
          padding:
              const EdgeInsets.only(top: 0.0, left: 100, right: 0, bottom: 10),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Center(
                                    child: Image.network(
                                      widget.message,
                                    ),
                                  ),
                                ));
                      },
                      child: ImageNetworkMsg(
                        height: 200,
                        width: 200,
                        image: widget.message,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  widget.mSeenBy.isEmpty
                      ? Container(
                          height: 18,
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: const Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              widget.mTest
                  ? Container(
                      alignment: Alignment.centerRight,
                      height: 20,
                      child: ListView.builder(
                          //itemExtent: 1,
                          scrollDirection: Axis.horizontal,
                          //primary: true,
                          //shrinkWrap: true,
                          reverse: true,
                          itemCount: widget.mSeenBy.length,
                          itemBuilder: (context, index) {
                            // final User? u = Provider.of<SkillsProvider>(context,
                            //         listen: false)
                            //     .allSkills!
                            //     .where((element) =>
                            //         element.user!.id ==
                            //         widget.mSeenBy.elementAt(index))
                            //     .first
                            //     .user;

                            bool seen = false;
                            for (var e in widget.mSeenBy) {
                              if (widget.user!.id == e) {
                                seen = true;
                              }
                            }
                            return Visibility(
                              visible: seen,
                              child: UserImageNetwork(
                                width: 20,
                                height: 20,
                                image: widget.user!.image,
                                marginAsDouble: 0,
                                function: () {},
                              ),
                            );
                          }),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      } else if (widget.myMsgType == 'text') {
        return InkWell(
          onTap: () {
            showDate = !showDate;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 100, right: 0, bottom: 10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 9, 154, 211),
                                Color.fromARGB(255, 158, 58, 240)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: getMessageType(widget.messageType)),
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    widget.mSeenBy.isEmpty
                        ? Container(
                            height: 18,
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.blueGrey),
                            child: const Icon(
                              Icons.check,
                              size: 13,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                // widget.mTest
                //     ? Container(
                //         alignment: Alignment.centerRight,
                //         height: 20,
                //         child: ListView.builder(
                //             //itemExtent: 1,
                //             scrollDirection: Axis.horizontal,
                //             //primary: true,
                //             //shrinkWrap: true,
                //             reverse: true,
                //             itemCount: widget.mSeenBy.length,
                //             itemBuilder: (context, index) {
                //               final UserModel u =
                //                   Provider.of<UserProvider>(context,
                //                           listen: false)
                //                       .allUsers
                //                       .where((element) =>
                //                           element.id ==
                //                           widget.mSeenBy.elementAt(index))
                //                       .first;
                //               return UserImageNetwork(
                //                 width: 20,
                //                 height: 20,
                //                 image: u.photo,
                //                 marginAsDouble: 0,
                //                 function: () {},
                //               );
                //             }),
                //       )
                //     : const SizedBox.shrink(),
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        // Text((DateTime.now().millisecondsSinceEpoch -
                        //             widget.date.millisecondsSinceEpoch) >=
                        //         86400000
                        //     ? formatDate(
                        //         widget.date,
                        //         [
                        //           hh,
                        //           ' : ',
                        //           nn,
                        //           ' - ',
                        //           yyyy,
                        //           '/',
                        //           mm,
                        //           '/',
                        //           dd,
                        //           '  ',
                        //         ],
                        //         locale: getDateLocal())
                        //     : formatDate(widget.date, [hh, ' : ', nn],
                        //         locale: getDateLocal())),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      }
      return Container(
        color: Colors.transparent,
      );
    } else {
      if (widget.myMsgType == 'image') {
        return Padding(
          padding:
              const EdgeInsets.only(top: 0.0, left: 0, right: 100, bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              UserImageNetwork(
                width: 45,
                height: 45,
                image: widget.user!.image,
                marginAsDouble: 0,
                function: () {},
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Container(
                              padding: const EdgeInsets.all(10),
                              child: Center(
                                child: Image.network(
                                  widget.message,
                                ),
                              ),
                            ));
                  },
                  child: ImageNetworkMsg(
                    height: 200,
                    width: 200,
                    image: widget.message,
                  ),
                ),
              )
            ],
          ),
        );
      } else if (widget.myMsgType == 'text') {
        return InkWell(
          onTap: () {
            showDate = !showDate;
            setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.only(
                top: 0.0, left: 0, right: 100, bottom: 10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    UserImageNetwork(
                      width: 45,
                      height: 45,
                      image: widget.user!.image,
                      marginAsDouble: 0,
                      function: () {
                        showDate = !showDate;
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          showDate = !showDate;
                          setState(() {});
                        },
                        child: Transform.translate(
                          offset: Provider.of<ChatRoomProvider>(context)
                                  .showMsgDatee!
                              ? const Offset(100, 0)
                              : const Offset(0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFFEAECF2),
                                borderRadius:
                                    getMessageType(widget.messageType)),
                            child: Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Text(
                                widget.message,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                if (showDate)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        // Text((DateTime.now().millisecondsSinceEpoch -
                        //             widget.date.millisecondsSinceEpoch) >=
                        //         86400000
                        //     ? formatDate(
                        //         widget.date,
                        //         [
                        //           hh,
                        //           ' : ',
                        //           nn,
                        //           ' - ',
                        //           yyyy,
                        //           '/',
                        //           mm,
                        //           '/',
                        //           dd,
                        //           '  ',
                        //         ],
                        //         locale: getDateLocal())
                        //     : formatDate(widget.date, [hh, ' : ', nn],
                        //         locale: getDateLocal())),
                      ],
                    ),
                  )
              ],
            ),
          ),
        );
      }

      return Container();
    }
  }

  getMessageType(messageType) {
    if (widget.isMe) {
      // start message
      if (messageType == 1) {
        return const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(5),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30));
      }
      // middle message
      else if (messageType == 2) {
        return const BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30));
      }
      // end message
      else if (messageType == 3) {
        return const BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30));
      }
      // standalone message
      else {
        return const BorderRadius.all(Radius.circular(15));
      }
    }
    // for sender bubble
    else {
      // start message
      if (messageType == 1) {
        return const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(5),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30));
      }
      // middle message
      else if (messageType == 2) {
        return const BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30));
      }
      // end message
      else if (messageType == 3) {
        return const BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30));
      }
      // standalone message
      else {
        return const BorderRadius.all(Radius.circular(10));
      }
    }
  }
}
