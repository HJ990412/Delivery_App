import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/screens/current/current.dart';
import 'package:app_3/states/chat_notifier.dart';
import 'package:app_3/states/current_notifier.dart';
import 'package:app_3/states/user_notifier.dart';
import 'package:beamer/beamer.dart';
import 'package:beamer/src/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_3/constants/common_size.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:provider/provider.dart';
import 'package:another_stepper/another_stepper.dart';
import 'package:another_stepper/dto/stepper_data.dart';

class CurrentInputScreen extends StatefulWidget {
  final String currentroomKey;
  const CurrentInputScreen({Key? key, required this.currentroomKey}) : super(key: key);

  @override
  _CurrentInputScreenState createState() => _CurrentInputScreenState();
}

class _CurrentInputScreenState extends State<CurrentInputScreen> {
  bool init = false;
  List<CurrentModel> currents = [];

  List<StepperData> stepperData = [
    StepperData(
      title: "그룹장 주문 대기중",
      subtitle: null,
    ),
    StepperData(
      title: "배달 진행중",
      subtitle: null,
    ),
    StepperData(
      title: "배달 도착!",
      subtitle: null,
    ),
  ];

  int total = 0;

  @override
  void initState() {
    _currentNotifier = CurrentNotifier(widget.currentroomKey);
    if (!init) {
      _onRefresh();
      init = true;
    }
    super.initState();
  }

  Future _onRefresh() async {
    currents.clear();
    currents.addAll(await CurrentService().getCurrentList(widget.currentroomKey));
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
  }



  late CurrentNotifier _currentNotifier;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CurrentNotifier>.value(
        value: _currentNotifier,
        child: Consumer<CurrentNotifier>(
            builder: (context, currentNotifier, child) {
              CurrentroomModel? currentroomModel = context.read<CurrentNotifier>().currentroomModel;
              UserModel userModel = context.read<UserNotifier>().userModel!;
              bool isSelling = userModel.userKey == currentroomModel?.currentSellerKey;
              Size _size = MediaQuery.of(context).size;
              return Scaffold(
                appBar: AppBar(
                  leading: TextButton(
                    onPressed: () {
                      context.beamBack(); //뒤로가기 속성 가져오기
                    },
                    style: TextButton.styleFrom(
                        primary: Colors.black87,
                        backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor),
                    child: Text('뒤로', style:
                    TextStyle(
                        fontFamily: "BMJUA",
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w100)),
                  ),
                  title: Text(
                    '주문현황',
                    style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.white),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () {_currentNotifier.refreshNewStat();},
                      color: Colors.white,
                      icon: Icon(Icons.refresh),
                    ),
                  ],
                ),
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      isSelling
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                                      child:
                                      Switch(
                                        value: currentroomModel == null ? false : currentroomModel.currentClosed,
                                        onChanged: (value) {
                                          setState(() {
                                            currentroomModel == null
                                                ? false
                                                : currentroomModel.currentClosed = value;
                                            _currentNotifier.updateClosed();
                                          });
                                        },
                                        activeColor: Colors.red,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                                        child: currentroomModel!.currentClosed
                                            ? Text('다모아 완료',
                                            style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.red))
                                            : Text('다모아 진행중',
                                            style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.blue))
                                    ),
                                  ],
                                ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                            child: Container(
                              child: AnotherStepper(
                                stepperList: stepperData,
                                stepperDirection: Axis.horizontal,
                                horizontalStepperHeight: 70,
                                inverted: false,
                                activeIndex: currentroomModel == null
                                      ? 0
                                      : currentroomModel.currentDeliverStat,
                                barThickness: 8,
                                gap: 50,
                              ),
                            ),
                          ),
                                  ),
                                  ElevatedButton(
                        child: Text('주문 대기 알림 보내기'),
                        onPressed: () async {
                          _currentNotifier.updateNewStat1();
                        },
                      ),
                                  ElevatedButton(
                        child: Text('배달 진행 알림 보내기'),
                        onPressed: () async {
                          _currentNotifier.updateNewStat2();
                        },
                      ),
                                  ElevatedButton(
                        child: Text('도착 알림 보내기'),
                        onPressed: () async {
                          _currentNotifier.updateNewStat3();
                        },
                      ),
                                  Padding(
                                  padding: const EdgeInsets.only(top:5, left: 16, bottom: 15, right: 16),
                                  child:
                                  Text('1인당 배달료 : ${currentroomModel == null ? ""
                                      : ((currentroomModel.currentItemPrice)/((currentNotifier.currentList.length)+1)).floor()}원',
                                    style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black54),
                                  ),
                                ),
                                  Divider(
                        height: 2,
                        thickness: 6,
                        color: Colors.grey[200],
                      ),
                                  Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 20, left: 16, bottom: 12),
                                  child: Text('참여자목록',
                                    style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.black87),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: IconButton(
                                    onPressed: () {
                                      _onRefresh();
                                      },
                                    icon: new Icon(Icons.refresh),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 30, top: 20, bottom: 12),
                                  child: Text('입금여부',
                                    style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.grey),
                                  )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                              ],
                            )
                          : Column(
                               children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                            child: Container(
                              child: AnotherStepper(
                                stepperList: stepperData,
                                stepperDirection: Axis.horizontal,
                                horizontalStepperHeight: 70,
                                inverted: false,
                                activeIndex: currentroomModel == null
                                      ? 0
                                      : currentroomModel.currentDeliverStat,
                                barThickness: 8,
                                gap: 50,
                              ),
                            ),
                          ),
                                  ),
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(top:5, left: 16, bottom: 5, right: 16),
                                       child:
                                       Text('모집마감 시간 ${currentroomModel == null ? "" : currentroomModel.currentTime} 에 모집인원이 '
                                           '확정된 후 배달비를 포함해 송금해주세요!',
                                         style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.red),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(top:5, left: 16, bottom: 5, right: 16),
                                       child:
                                       Text('1인당 배달료 : ${currentroomModel == null ? ""
                                           : ((currentroomModel.currentItemPrice)/((currentNotifier.currentList.length)+1)).floor()}원',
                                         style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black54),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(top:5, left: 16, bottom: 5, right: 16),
                                       child:
                                       Text('방장 계좌번호 : ${currentroomModel == null ? "" : currentroomModel.currentBank} ${currentroomModel == null ? "" : currentroomModel.currentAccount}',
                                         style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black54),
                                       ),
                                     ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Padding(
                                           padding: const EdgeInsets.only(top:5, left: 16, bottom: 10, right: 16),
                                           child:
                                           Text('방장 전화번호 : ${currentroomModel == null ? "" : currentroomModel.currentPhone}',
                                             style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black54),
                                           ),
                                         ),
                                           Padding(
                                             padding: const EdgeInsets.only(top:5, bottom: 10, right: 30),
                                             child: InkWell(
                                               child: Container(
                                                   padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                                                   child: Text('픽업위치'),
                                                   constraints: BoxConstraints(minHeight: 20, maxWidth: _size.width * 0.6),
                                                   decoration: BoxDecoration(
                                                     color: Colors.grey[300],

                                                     borderRadius: BorderRadius.only(
                                                         topRight: roundedCorner,
                                                         topLeft: roundedCorner,
                                                         bottomRight: roundedCorner,
                                                         bottomLeft: roundedCorner
                                                     ),
                                                 ),
                                               ),
                                               onTap: () {
                                                 showDialog(context: context, builder: (BuildContext context){
                                                   return AlertDialog(
                                                     shape: RoundedRectangleBorder(
                                                         borderRadius: BorderRadius.circular(10.0)),
                                                     title: Column(
                                                       children: <Widget>[
                                                         new Text("픽업위치"),
                                                       ],
                                                     ),
                                                     content: SizedBox(
                                                       height: 150,
                                                       child: Column(
                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                           Row(
                                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                             children: [
                                                               Padding(
                                                                 padding: const EdgeInsets.only(left: 10, bottom: 12, top: 12),
                                                                 child: Text(currentroomModel == null ? "" :currentroomModel.currentAddress1,
                                                                   style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.black87),
                                                                 ),
                                                               ),
                                                               CupertinoButton(
                                                                   borderRadius: BorderRadius.circular(0),
                                                                   minSize: 0.0,
                                                                   padding: EdgeInsets.all(3),
                                                                   child: Text('COPY',
                                                                       style: TextStyle(fontFamily: "BMJUA", fontSize: 10, color: Colors.white)),
                                                                   color: Colors.black,
                                                                   onPressed: () {
                                                                     Clipboard.setData(ClipboardData(text: currentroomModel == null ? "" :currentroomModel.currentAddress1));
                                                                   })
                                                             ],
                                                           ),
                                                           Padding(
                                                             padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                                                             child: Text(currentroomModel == null ? "" :currentroomModel.currentAddress2,
                                                               style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.black87),
                                                             ),
                                                           ),
                                                         ],
                                                       ),
                                                     ),
                                                   );
                                                 });
                                               },
                                             ),
                                           )
                                       ],
                                     ),
                                   ],
                                 ),
                                  Divider(
                            height: 2,
                            thickness: 6,
                            color: Colors.grey[200],
                          ),
                                  Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, left: 16, bottom: 12),
                                      child: Text('참여자목록',
                                        style: TextStyle(fontFamily: "BMJUA", fontSize: 20, color: Colors.black87),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: IconButton(
                                        onPressed: () {
                                          _onRefresh();
                                        },
                                        icon: new Icon(Icons.refresh),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(right: 30, top: 20, bottom: 12),
                                        child:  Text('입금여부',
                                          style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.grey),
                                        )
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                               ],
                            ),
                      Expanded(
                          child: Container(
                            color: Colors.white,
                            child: RefreshIndicator(
                              onRefresh: _onRefresh,
                              child: ListView.separated(
                                  padding: EdgeInsets.all(16),
                                  itemBuilder: (context, index) {
                                    CurrentModel currentModel = currents[index];
                                    return Current(
                                      size: _size,
                                      isSeller: isSelling,
                                      currentroomKey: widget.currentroomKey,
                                      currentModel: currents[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Divider(
                                        height: 2,
                                        thickness: 2,
                                        color: Colors.grey[200],
                                      ),
                                    );
                                  },
                                  itemCount: currents.length),
                            ),
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _deleteCurrent(context),
                      ),
                    ],
                  ),
                ),
              );
            }
        )
    );
  }
  Widget _deleteCurrent(BuildContext context) {
    CurrentroomModel? currentroomModel = context.read<CurrentNotifier>().currentroomModel;
    return FutureBuilder<ItemModel>(
      future: ItemService().getItem(currentroomModel == null ? "" : currentroomModel.itemKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ItemModel itemModel = snapshot.data!;
          UserModel userModel = context
              .read<UserNotifier>()
              .userModel!;
          String currentKey = '${userModel.userKey}_${currentroomModel == null
              ? ""
              : currentroomModel.itemKey}';
            return TextButton(onPressed: () async {
              await ItemService().decreaseParticipants(currentroomModel == null
                  ? ""
                  : currentroomModel.itemKey, itemModel);
              await CurrentService()
                  .deleteCurrent(
                  widget.currentroomKey
                  , currentKey,
                  currentroomModel == null
                  ? ""
                  : currentroomModel.chatroomKey);
              context.beamBack();
            },
                child: Text("    취소하기    "));
        }
        return Container();
      },
    );
  }
}