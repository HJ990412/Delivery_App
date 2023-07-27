import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/screens/current/current_list_page.dart';
import 'package:app_3/screens/home_screen.dart';
import 'package:app_3/screens/start/current_list_page_2.dart';
import 'package:beamer/beamer.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app_3/constants/common_size.dart';
import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/repo/chat_service.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/screens/item/similar_item.dart';
import 'package:app_3/states/category_notifier.dart';
import 'package:app_3/states/user_notifier.dart';
import 'package:app_3/utils/logger.dart';
import 'package:app_3/utils/time_calculation.dart';
import 'package:flutter_multi_formatter/formatters/money_input_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class ItemDetailScreen extends StatefulWidget {
  final String itemKey;
  const ItemDetailScreen(this.itemKey, {Key? key}) : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {

  var _border =
  UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  int total = 0;

  PageController _pageController = PageController();
  TextEditingController _menuController1 = TextEditingController();
  TextEditingController _menuController2 = TextEditingController();
  TextEditingController _menuController3 = TextEditingController();

  TextEditingController _priceController1 = TextEditingController();
  TextEditingController _priceController2 = TextEditingController();
  TextEditingController _priceController3 = TextEditingController();

  Size? _size;
  num? _statusBarHeight;
  bool isAppbarCollapsed = false;
  Widget _textGap = SizedBox(
    height: common_sm_padding,
  );
  Widget _divider = Divider(
    height: common_sm_padding * 2 + 2,
    thickness: 2,
    color: Colors.grey[200],
  );
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToChatroom(ItemModel itemModel, UserModel userModel) async {
    String chatroomKey =
    ChatroomModel.generateChatRoomKey(userModel.userKey, widget.itemKey);

    final String? buyerPhoneNum = FirebaseAuth.instance.currentUser!.phoneNumber;

    final num? price1 =
    num.tryParse(_priceController1.text.replaceAll(new RegExp(r"\D"), ''));

    final num? price2 =
    num.tryParse(_priceController2.text.replaceAll(new RegExp(r"\D"), ''));

    final num? price3 =
    num.tryParse(_priceController3.text.replaceAll(new RegExp(r"\D"), ''));

    ChatroomModel _chatroomModel = ChatroomModel(
        lastMsgTime: DateTime.now(),
        itemTitle: itemModel.title,
        itemKey: widget.itemKey,
        currentroomKey: itemModel.currentroomKey,
        itemAddress1: itemModel.address,
        itemAddress2: itemModel.itemAddress2,
        itemPrice: itemModel.price,
        itemTime: itemModel.time,
        itemBank: itemModel.bank,
        itemAccount: itemModel.account,
        itemPhoneNum: itemModel.phoneNum,
        buyerPhoneNum: buyerPhoneNum,
        menu1: _menuController1.text,
        menu2: _menuController2.text,
        menu3: _menuController3.text,
        menuPrice1: price1 ?? 0,
        menuPrice2: price2 ?? 0,
        menuPrice3: price3 ?? 0,
        sellerKey: itemModel.userKey,
        buyerKey: userModel.userKey,
        sellerImage:
        "https://minimaltoolkit.com/images/randomdata/male/101.jpg",
        buyerImage:
        'https://minimaltoolkit.com/images/randomdata/female/41.jpg',
        geoFirePoint: itemModel.geoFirePoint,
        chatroomClosed: false,
        stat: 0,
        chatroomKey: chatroomKey);

    await ChatService().createNewChatroom(_chatroomModel);

    BeamState beamState = Beamer.of(context).currentConfiguration!;
    String currentPath = beamState.uri.toString();
    String newPath =
    (currentPath == '/') ? '/$chatroomKey' : '$currentPath/$chatroomKey';

    logger.d('newPath - $newPath');
    context.beamToNamed(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ItemModel>(
        future: ItemService().getItem(widget.itemKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ItemModel itemModel = snapshot.data!;
            UserModel userModel = context
                .read<UserNotifier>()
                .userModel!;
            bool isSelling = userModel.userKey == itemModel.userKey;
            if (isSelling == false) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  _size = MediaQuery
                      .of(context)
                      .size;
                  return Scaffold(
                    bottomNavigationBar: SafeArea(
                      top: false,
                      bottom: true,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey[300]!))),
                        child: Padding(
                          padding: const EdgeInsets.all(common_sm_padding),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              TextButton(
                                  onPressed: () {
                                    _goToChatroom(itemModel, userModel);
                                  },
                                  child: Text('      결제하기      '))
                            ],
                          ),
                        ),
                      ),
                    ),
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
                        '메뉴 선택',
                        style: TextStyle(fontFamily: "BMJUA",
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      centerTitle: true,
                    ),
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, bottom: 12),
                          child: Text(
                            itemModel.title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, bottom: 12),
                          child: Text('배달료 : ${itemModel.price.toString()}원',
                              style:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 16, bottom: 12),
                          child: Text(
                            '픽업위치: ${itemModel.itemAddress1} ${itemModel
                                .itemAddress2}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                controller: _menuController1,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.food_bank),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴명',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                inputFormatters: [
                                  MoneyInputFormatter(
                                      trailingSymbol: '원', mantissaLength: 0),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value == '0원') {
                                      _priceController1.clear();
                                    }
                                  });
                                },
                                keyboardType: TextInputType.number,
                                controller: _priceController1,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.money),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴가격',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                controller: _menuController2,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.food_bank),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴명',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                inputFormatters: [
                                  MoneyInputFormatter(
                                      trailingSymbol: '원', mantissaLength: 0),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value == '0원') {
                                      _priceController2.clear();
                                    }
                                  });
                                },
                                keyboardType: TextInputType.number,
                                controller: _priceController2,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.money),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴가격',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                controller: _menuController3,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.food_bank),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴명',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16,),
                              child: TextFormField(
                                inputFormatters: [
                                  MoneyInputFormatter(
                                      trailingSymbol: '원', mantissaLength: 0),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    if (value == '0원') {
                                      _priceController3.clear();
                                    }
                                  });
                                },
                                keyboardType: TextInputType.number,
                                controller: _priceController3,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.money),
                                  contentPadding:
                                  EdgeInsets.symmetric(
                                      horizontal: common_bg_padding),
                                  hintText: '메뉴가격',
                                  border: _border,
                                  enabledBorder: _border,
                                  focusedBorder: _border,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            else {
              return LayoutBuilder(
                builder: (context, constraints) {
                  _size = MediaQuery
                      .of(context)
                      .size;
                  return Scaffold(
                    bottomNavigationBar: SafeArea(
                      top: false,
                      bottom: true,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.grey[300]!))),
                        child: Padding(
                          padding: const EdgeInsets.all(common_sm_padding),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              TextButton(
                                  onPressed: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) =>
                                         CurrentListPage2(userKey: itemModel.userKey)),
                                   );
                                  },
                                  child: Text('    ${itemModel.participants} 명 참여중   '))
                            ],
                          ),
                        ),
                      ),
                    ),
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
                        '주문방 관리',
                        style: TextStyle(fontFamily: "BMJUA",
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      centerTitle: true,
                      actions: [
                        TextButton(
                          onPressed: () {
                            ItemService().deleteItem(itemModel.itemKey, userModel.userKey);
                            context.beamBack();
                            },
                          style: TextButton.styleFrom(
                              primary: Colors.black87,
                              backgroundColor:
                              Theme.of(context).appBarTheme.backgroundColor),
                          child:
                          Text('삭제', style: TextStyle(fontFamily: "BMJUA", fontSize: 12, color: Colors.white, fontWeight: FontWeight.w100)),
                        ),
                      ],
                    ),
                    body: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, bottom: 12),
                          child: Text(
                            itemModel.title,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, bottom: 12),
                          child: Text('배달료 : ${itemModel.price.toString()}원',
                              style:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText2
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 16, bottom: 12),
                          child: Text(
                            '픽업위치: ${itemModel.itemAddress1} ${itemModel
                                .itemAddress2}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 16, bottom: 12),
                          child: Text(
                            '마감시간: ${itemModel.time}',
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText2,
                          ),
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                              child:
                              Switch(
                                value: itemModel == null ? false : itemModel.closed,
                                onChanged: (value) {
                                  setState(() {
                                    itemModel == null
                                        ? false
                                        : itemModel.closed = value;
                                    ItemService().closedUpdate(itemModel.userKey, itemModel.itemKey, itemModel);
                                  });
                                },
                                activeColor: Colors.red,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                                child: itemModel.closed
                                    ? Text('모집마감',
                                    style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.grey))
                                    : Text('모집중',
                                    style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.blue))
                            ),
                          ],
                        ),
                        Divider(
                          height: 2,
                          thickness: 2,
                          color: Colors.grey[200],
                        ),
                        Padding(
                            padding: const EdgeInsets.only(right: 15, bottom: 5, top: 5),
                            child:
                            Text('   ${itemModel.participants} 명 참여중    ',
                                style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.blue))
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          }
          return Container();
        });
  }
}