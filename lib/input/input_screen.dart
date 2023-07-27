import 'dart:typed_data';
import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/input/time_select.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:app_3/constants/common_size.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/repo/image_storage.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/states/category_notifier.dart';
import 'package:app_3/states/select_image_notifier.dart';
import 'package:app_3/states/user_notifier.dart';
import 'package:app_3/utils/logger.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'multi_image_select.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {

  TextEditingController timeinput = TextEditingController();

  @override
  void initState() {
    timeinput.text = "";
    super.initState();
  }

  TextEditingController _priceController = TextEditingController();
  var _border =
  UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));

  var _divider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.grey[350],
    indent: common_bg_padding,
    endIndent: common_bg_padding,
  );

  bool isCreatingItem = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _bankController = TextEditingController();
  TextEditingController _AddressController1 = TextEditingController();
  TextEditingController _AddressController2 = TextEditingController();
  TextEditingController _accountController = TextEditingController();

  void attemptCreateItem() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    isCreatingItem = true;
    setState(() {});

    final String? userKey = FirebaseAuth.instance.currentUser!.uid;
    final String? phoneNum = FirebaseAuth.instance.currentUser!.phoneNumber;
    final String itemKey = ItemModel.generateItemKey(userKey!);
    String currentroomKey = CurrentroomModel.generateCurrentroomKey(userKey, itemKey);

    UserNotifier userNotifier = context.read<UserNotifier>();

    if (userNotifier.userModel == null) return;


    final num? price =
    num.tryParse(_priceController.text.replaceAll(new RegExp(r"\D"), ''));

    final num? account =
    num.tryParse(_accountController.text.replaceAll(new RegExp(r"\D"), ''));

    ItemModel itemModel = ItemModel(
      itemKey: itemKey,
      userKey: userKey,
      currentroomKey : currentroomKey,
      phoneNum: phoneNum,
      title: _titleController.text,
      category: context.read<CategoryNotifier>().currentCategoryInEng,
      price: price ?? 0,
      time: timeinput.text,
      bank: _bankController.text,
      account: account ?? 0,
      itemAddress1: _AddressController1.text,
      itemAddress2: _AddressController2.text,
      address: userNotifier.userModel!.address,
      geoFirePoint: userNotifier.userModel!.geoFirePoint,
      createdDate: DateTime.now().toUtc(),
      closed: false,
      participants: 0
    );

    await ItemService()
        .createNewItem(itemModel, itemKey, userNotifier.user!.uid);

    //업로드 완료 후 자동으로 뒤로가기
    context.beamBack();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        UserModel userModel = context.read<UserNotifier>().userModel!;
        Size _size = MediaQuery.of(context).size;
        return IgnorePointer(
          ignoring: isCreatingItem,
          child: Scaffold(
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size(_size.width, 2),
                child: isCreatingItem
                    ? LinearProgressIndicator(minHeight: 2)
                    : Container(),
              ),
              leading: TextButton(
                onPressed: () {
                  context.beamBack(); //뒤로가기 속성 가져오기
                },
                style: TextButton.styleFrom(
                    primary: Colors.black87,
                    backgroundColor:
                    Theme.of(context).appBarTheme.backgroundColor),
                child: Text('뒤로', style: TextStyle(fontFamily: "BMJUA", fontSize: 12, color: Colors.white, fontWeight: FontWeight.w100)),
              ),
              actions: [
                TextButton(
                  onPressed: attemptCreateItem,
                  style: TextButton.styleFrom(
                      primary: Colors.black87,
                      backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor),
                  child:
                  Text('완료', style: TextStyle(fontFamily: "BMJUA", fontSize: 12, color: Colors.white, fontWeight: FontWeight.w100)),
                ),
              ],
              title: Text(
                '주문방 만들기',
                style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: ListView(
              padding: EdgeInsets.all(common_bg_padding),
              children: [
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 72.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: ListTile(
                    onTap: () {
                      context.beamToNamed('/input/category_input');
                    },
                    dense: true,
                    title: Text(
                        context.watch<CategoryNotifier>().currentCategoryInKor),
                    trailing: Icon(Icons.navigate_next),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 72.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.food_bank),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_bg_padding),
                      hintText: '음식점명',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 72.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            MoneyInputFormatter(
                                trailingSymbol: '원', mantissaLength: 0),
                          ],
                          controller: _priceController,
                          onChanged: (value) {
                            setState(() {
                              if (value == '0원') {
                                _priceController.clear();
                              }
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: common_sm_padding),
                            icon: Icon(Icons.attach_money),
                            hintText: '배달료를 입력하세요',
                            border: _border,
                            enabledBorder: _border,
                            focusedBorder: _border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(common_sm_padding),
                    padding: EdgeInsets.all(common_sm_padding),
                    height: 72.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                    ),
                    child: Center(
                      child: TextField(
                        controller: timeinput,
                        decoration: InputDecoration(
                          icon: Icon(Icons.timer),
                          hintText: "주문 예정 시간을 선택하세요"
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                          );

                          if(pickedTime != null ) {
                            print(pickedTime.format(context)); //output 10:51 PM
                            DateTime parsedTime = DateFormat.jm().parse(
                                pickedTime.format(context).toString());
                            //converting to DateTime so that we can further format on different pattern.
                            print(parsedTime); //output 1970-01-01 22:53:00.000
                            String formattedTime = DateFormat('HH:mm')
                                .format(parsedTime);
                            print(formattedTime); //output 14:59:00
                            //DateFormat() is from intl package, you can format the time on any pattern you need.

                            setState(() {
                              timeinput.text =
                                  formattedTime; //set the value of text field.
                            });
                          }else{
                            print("시간이 입력되지 않았습니다");
                          }
                        },
                      ),
                    )
                ),
                Container(
                    margin: EdgeInsets.all(common_sm_padding),
                    padding: EdgeInsets.all(common_sm_padding),
                    height: 72.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        controller: _accountController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.account_balance),
                            hintText: "계좌번호를 입력하세요"
                        ),
                        readOnly: true,
                        onTap: () async {
                          _showdialog(context);
                        },
                      ),
                    )
                ),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 72.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: AddressText(),
                ),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 72.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: TextFormField(
                    controller: _AddressController2,
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_on_outlined),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_bg_padding),
                      hintText: '만날 장소를 알려주세요',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }



  Future<dynamic> _showdialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('계좌번호 입력',
          style: TextStyle(fontFamily: "BMJUA", fontSize: 25, color: Colors.lightBlue,),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 300,
          height: 230,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: common_sm_padding,),
                Text("은행명", style: Theme.of(context).textTheme.subtitle1),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: TextFormField(
                    controller: _bankController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_balance),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_bg_padding),
                      hintText: '은행명을 입력해주세요',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                ),
                SizedBox(height: common_sm_padding,),
                Text("계좌번호", style: Theme.of(context).textTheme.subtitle1),
                Container(
                  margin: EdgeInsets.all(common_sm_padding),
                  padding: EdgeInsets.all(common_sm_padding),
                  height: 60.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          spreadRadius: 0,
                          blurRadius: 5.0,
                          offset: Offset(0, 10),
                        ),
                      ]
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _accountController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_balance),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: common_bg_padding),
                      hintText: '계좌번호을 입력해주세요',
                      border: _border,
                      enabledBorder: _border,
                      focusedBorder: _border,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인')),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
      ),
    );
  }

  Widget AddressText() {
    UserModel userModel = context.read<UserNotifier>().userModel!;
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _addressAPI(); // 카카오 주소 API
      },
      child: Column(
        children: [
          TextFormField(
            enabled: false,
            decoration: InputDecoration(
              icon: Icon(Icons.place),
              hintText: "주소를 입력해주세요",
            ),
            controller: _AddressController1,
          ),
        ],
      ),
    );
  }
  _addressAPI() async {
    KopoModel model = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => RemediKopo(),
      ),
    );
    _AddressController1.text =
    '${model.address!} ${model.buildingName!}';
  }

  @override
  void dispose() {
    timeinput.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _AddressController1.dispose();
    _AddressController2.dispose();
    _accountController.dispose();
    _bankController.dispose();
    super.dispose();
  }
}