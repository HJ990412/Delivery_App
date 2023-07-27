import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/repo/chat_service.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/utils/logger.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:provider/provider.dart';
import 'package:app_3/data/chat_model.dart';
import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/screens/chat/chat.dart';
import 'package:app_3/states/chat_notifier.dart';
import 'package:app_3/states/user_notifier.dart';
import 'package:shimmer/shimmer.dart';

class ChatroomScreen extends StatefulWidget {
  final String chatroomKey;
  const ChatroomScreen({Key? key, required this.chatroomKey}) : super(key: key);

  @override
  _ChatroomScreenState createState() => _ChatroomScreenState();
}

class _ChatroomScreenState extends State<ChatroomScreen> {
  TextEditingController _textEditingController = TextEditingController();
  late ChatNotifier _chatNotifier;

  @override
  void initState() {
    _chatNotifier = ChatNotifier(widget.chatroomKey);
    super.initState();
  }

  void _createNewCurrentroom(ChatroomModel chatroomModel) async {
    String currentroomKey =
    CurrentroomModel.generateCurrentroomKey(chatroomModel.sellerKey, chatroomModel.itemKey);

    UserNotifier userNotifier = context.read<UserNotifier>();
    UserModel userModel = context.read<UserNotifier>().userModel!;

    String currentKey =
    CurrentModel.generateCurrentKey(userModel.userKey, chatroomModel.itemKey);

    CurrentroomModel _currentroomModel = CurrentroomModel(
        itemKey: chatroomModel.itemKey,
        currentSellerKey: chatroomModel.sellerKey,
        chatroomKey: chatroomModel.chatroomKey,
        currentDeliverStat: 0,
        currentDeliverTime: 0,
        currentTitle: chatroomModel.itemTitle,
        currentItemPrice: chatroomModel.itemPrice,
        currentTime: chatroomModel.itemTime,
        currentPhone: chatroomModel.itemPhoneNum,
        currentAccount: chatroomModel.itemAccount,
        currentBank: chatroomModel.itemBank,
        currentAddress1: chatroomModel.itemAddress1,
        currentAddress2: chatroomModel.itemAddress2,
        currentRoomKey: currentroomKey,
        currentClosed: false,
    );

    CurrentModel _currentModel = CurrentModel(
        depositCheck: false,
        currentPhoneNum: userModel.phoneNumber,
        currentMenu1: chatroomModel.menu1,
        currentPrice1: chatroomModel.menuPrice1,
        currentMenu2: chatroomModel.menu2,
        currentPrice2: chatroomModel.menuPrice2,
        currentMenu3: chatroomModel.menu3,
        currentPrice3: chatroomModel.menuPrice3,
        userCreatedDate: DateTime.now(),
        userKey: userModel.userKey,
        currentKey: currentKey);

    await CurrentService().createNewUser(currentroomKey, currentKey, _currentModel);

    await CurrentService().createNewCurrentRoom(_currentroomModel, currentroomKey, chatroomModel.itemKey, userNotifier.user!.uid);

    BeamState beamState = Beamer.of(context).currentConfiguration!;
    String currentPath = beamState.uri.toString();
    String newPath =
    (currentPath == '/') ? '/$currentroomKey' : '$currentPath/$currentroomKey';

    logger.d('newPath - $newPath');
    context.beamToNamed(newPath);
  }

  void _gotoCurrentRoom(ChatroomModel chatroomModel) {
    context.beamToNamed('/:${chatroomModel.chatroomKey}/:${chatroomModel.currentroomKey}');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatNotifier>.value(
      value: _chatNotifier,
      child: Consumer<ChatNotifier>(
        builder: (context, chatNotifier, child) {
          Size _size = MediaQuery.of(context).size;
          ChatroomModel? chatroomModel = context.read<ChatNotifier>().chatroomModel;
          UserModel userModel = context.read<UserNotifier>().userModel!;
          bool isClosed = chatroomModel == null ? false : chatroomModel.chatroomClosed;
          return Scaffold(
            appBar: AppBar(
              leading: TextButton(
                onPressed: () {
                  context.beamBack(); //뒤로가기 속성 가져오기
                },
                style: TextButton.styleFrom(
                    primary: Colors.black87,
                    backgroundColor:
                    Theme
                        .of(context)
                        .appBarTheme
                        .backgroundColor),
                child: Text('뒤로', style: TextStyle(
                    fontFamily: "BMJUA", fontSize: 12, color: Colors
                    .white, fontWeight: FontWeight.w100)),
              ),
              title: Text(
              '결제하기',
              style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.white),
            ),
              centerTitle: true,
              actions: [
                if (isClosed == true)
                  TextButton(
                  onPressed: () {
                    chatNotifier.deleteChatroom();
                    context.beamBack();
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black87,
                      backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor),
                  child:
                  Text('삭제', style: TextStyle(fontFamily: "BMJUA", fontSize: 12, color: Colors.white, fontWeight: FontWeight.w100)),
                )
              ],
            ),

            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  _buildItemInfo(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _CreateCurrent(context),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  MaterialBanner _buildItemInfo(BuildContext context) {
    ChatroomModel? chatroomModel = context.read<ChatNotifier>().chatroomModel;
    UserModel userModel = context.read<UserNotifier>().userModel!;
    bool isClosed = chatroomModel == null ? false : chatroomModel.chatroomClosed;
    return MaterialBanner(
      padding: EdgeInsets.zero,
      leadingPadding: EdgeInsets.zero,
      actions: [Container()],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 16, top: 20),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: chatroomModel == null
                                  ? ""
                                  : chatroomModel.itemTitle,
                              style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.black87),)
                          ]),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                    child:
                    Switch(
                      value: chatroomModel == null ? false : chatroomModel.chatroomClosed,
                      onChanged: (value) {
                        setState(() {
                          chatroomModel == null
                              ? false
                              : chatroomModel.chatroomClosed = value;
                          _chatNotifier.updateClosed();
                        });
                      },
                      activeColor: Colors.red,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: isClosed
                          ? Text('다모아 완료',
                          style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.red))
                          : Text('다모아 진행중',
                          style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.blue))
                  ),
                ],
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Text('메뉴', style: TextStyle(color: Colors.black87, fontSize: 15),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('가격', style: TextStyle(color: Colors.black87, fontSize: 15),),
              ),
            ],
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: Colors.grey[200],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: chatroomModel == null
                                  ? ""
                                  : chatroomModel.menu1,
                              style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),)
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: chatroomModel == null
                                  ? ""
                                  : chatroomModel.menu2,
                              style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),)
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: chatroomModel == null
                                  ? ""
                                  : chatroomModel.menu3,
                              style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),)
                          ]),
                    ),
                  ),
                ],
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only( bottom: 12, top: 12),
                      child: RichText(
                        text: TextSpan(
                          text: chatroomModel == null
                              ? ""
                              : chatroomModel.menuPrice1.toString(),
                          style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.only( bottom: 12, top: 12),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: chatroomModel == null
                                    ? ""
                                    : chatroomModel.menuPrice2.toString(),
                                style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),)
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only( bottom: 12, top: 12),
                      child: RichText(
                        text: TextSpan(
                            children: [
                              TextSpan(
                                text: chatroomModel == null
                                    ? ""
                                    : chatroomModel.menuPrice3.toString(),
                                style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),)
                            ]),
                      ),
                    ),
                  ]
              ),
            ],
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: Colors.grey[200],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
                child: Text('총 결제금액', style: TextStyle(color: Colors.black87, fontSize: 15),),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only( bottom: 12, top: 12),
                    child: RichText(
                      text: TextSpan(
                          children: [
                            TextSpan(
                              text: chatroomModel == null
                                  ? ""
                                  : (chatroomModel.menuPrice1 + chatroomModel.menuPrice2 + chatroomModel.menuPrice3).toString(),
                              style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.black87),)
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            height: 2,
            thickness: 4,
            color: Colors.grey[200],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 16, bottom: 12),
                    child: Text('결제수단', style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.black87),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5, left: 16, bottom: 12),
                    child:
                    Text('입금기한 : ${chatroomModel == null ? "" : chatroomModel.itemTime}',
                      style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5, left: 16, bottom: 12),
                    child:
                    Text('방장 계좌번호 : ${chatroomModel == null ? "" : chatroomModel.itemBank} '
                        '${chatroomModel == null ? "" : chatroomModel.itemAccount}',
                      style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5, left: 16, bottom: 12),
                    child:
                    Text('방장 전화번호 : ${chatroomModel == null ? "" : chatroomModel.itemPhoneNum}',
                      style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top:5, left: 16, bottom: 5, right: 16),
            child:
            Text('참여하기를 누르고 모집마감 시간 ${chatroomModel == null ? "" : chatroomModel.itemTime} 에 모집인원이 '
                '확정된 후 배달비를 포함해 송금해주세요!',
              style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.red),
            ),
          ),
        ],

      ),
    );
  }

  Widget _CreateCurrent(BuildContext context) {
    ChatroomModel? chatroomModel = context.read<ChatNotifier>().chatroomModel;
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(chatroomModel == null ? "" : chatroomModel.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            UserModel userModel = context
                .read<UserNotifier>()
                .userModel!;
            bool entrance = (chatroomModel == null ? "" : chatroomModel.stat) == 0;
            if (entrance == true) {
              return TextButton(onPressed: () async {
                _createNewCurrentroom(chatroomModel!);
                await ItemService().increaseParticipants(chatroomModel == null
                    ? ""
                    : chatroomModel.itemKey, itemModel);
                await ChatService().increaseEntrance(widget.chatroomKey, chatroomModel);
              },
                  child: Text("    참여하기    "));
            }
            else {
              return TextButton(onPressed: () async {
                _gotoCurrentRoom(chatroomModel!);
              },
                  child: Text("    주문현황    "));
            }
          }
          return Container();
        },
    );
  }
}