import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/states/current_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const roundedCorner = Radius.circular(20);

class Current extends StatefulWidget {
  final Size size;
  final bool isSeller;
  final String currentroomKey;
  final CurrentModel currentModel;

  const Current(
       {Key? key,
         required this.size,
         required this.isSeller,
         required this.currentroomKey,
         required this.currentModel})
       : super(key: key);

  @override
  State<Current> createState() => _CurrentState();
}

class _CurrentState extends State<Current> {

  @override
  void initState() {
    _currentNotifier = CurrentNotifier(widget.currentroomKey);
  }

  @override
  void dispose() {
    super.dispose();
  }

  late CurrentNotifier _currentNotifier;

  @override
  Widget build(BuildContext context) {
    return widget.isSeller ? _buildSellerView(context) : _buildBuyerView(context) ;
  }

  Widget _buildBuyerView(BuildContext context) {
    return ChangeNotifierProvider<CurrentNotifier>.value(
      value: _currentNotifier,
      child: Consumer<CurrentNotifier>(
        builder: (context, currentNotifier, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5),
                    child: InkWell(
                      child: Container(
                        child: Text('${widget.currentModel.currentPhoneNum!} 님의 주문내역',
                            style: Theme.of(context).textTheme.bodyText1!),
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                        constraints:
                        BoxConstraints(minHeight: 40, maxWidth: widget.size.width * 0.5),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.only(
                                topRight: roundedCorner,
                                topLeft: Radius.circular(2),
                                bottomRight: roundedCorner,
                                bottomLeft: roundedCorner
                            )
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                title: Column(
                                  children: <Widget>[
                                    new Text("${widget.currentModel.currentPhoneNum} 님의 주문내역"),
                                  ],
                                ),
                                content: SizedBox(
                                  height: 195,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 16, bottom: 12),
                                            child: Text('메뉴', style: TextStyle(color: Colors.grey, fontSize: 15),),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 12),
                                            child: Text('가격', style: TextStyle(color: Colors.grey, fontSize: 15),),
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
                                                child: Text(widget.currentModel.currentMenu1,
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                                                child: Text(widget.currentModel.currentMenu2,
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
                                                child: Text(widget.currentModel.currentMenu3,
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only( bottom: 12, top: 12),
                                                child: Text(widget.currentModel.currentPrice1.toString(),
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only( bottom: 12, top: 12),
                                                child: Text(widget.currentModel.currentPrice2.toString(),
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only( bottom: 12, top: 12),
                                                child: Text(widget.currentModel.currentPrice3.toString(),
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
                                              ),
                                            ],
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
                                          Padding(
                                            padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
                                            child: Text('총 결제금액', style: TextStyle(color: Colors.black87, fontSize: 15),),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(bottom: 12, top: 12),
                                                child: Text((widget.currentModel.currentPrice1 + widget.currentModel.currentPrice2 + widget.currentModel.currentPrice3).toString(),
                                                  style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.black87),),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                        );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
                      child: widget.currentModel.depositCheck
                          ? Text('입금확인',
                          style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.green))
                          : Text('입금대기',
                          style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.grey))
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );


  }

  Widget _buildSellerView(BuildContext context) {
    return ChangeNotifierProvider<CurrentNotifier>.value(
        value: _currentNotifier,
       child: Consumer<CurrentNotifier>(
         builder: (context, currentNotifier, child) {
           CurrentroomModel? currentroomModel = context.read<CurrentNotifier>().currentroomModel;
           return Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
           Padding(
           padding: const EdgeInsets.only( bottom: 5, top: 5),
           child: InkWell(
           child: Container(
           child: Text('${widget.currentModel.currentPhoneNum!} 님의 주문내역',
           style: Theme.of(context).textTheme.bodyText1!),
           padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
           constraints:
           BoxConstraints(minHeight: 40, maxWidth: widget.size.width * 0.5),
           decoration: BoxDecoration(
           color: Colors.grey[300],
           borderRadius: BorderRadius.only(
           topRight: roundedCorner,
           topLeft: Radius.circular(2),
           bottomRight: roundedCorner,
           bottomLeft: roundedCorner
           )
           ),
           ),
           onTap: () {
           showDialog(
           context: context,
           barrierDismissible: true,
           builder: (BuildContext context){
           return AlertDialog(
           shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10.0)),
           title: Column(
           children: <Widget>[
           new Text("${widget.currentModel.currentPhoneNum} 님의 주문내역"),
           ],
           ),
           content: SizedBox(
           height: 195,
           child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
           Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
           Padding(
           padding: const EdgeInsets.only(left: 16, bottom: 12),
           child: Text('메뉴', style: TextStyle(color: Colors.grey, fontSize: 15),),
           ),
           Padding(
           padding: const EdgeInsets.only(bottom: 12),
           child: Text('가격', style: TextStyle(color: Colors.grey, fontSize: 15),),
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
           child: Text(widget.currentModel.currentMenu1,
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
           ),
           Padding(
           padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
           child: Text(widget.currentModel.currentMenu2,
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
           ),
           Padding(
           padding: const EdgeInsets.only(left: 16, bottom: 12, top: 12),
           child: Text(widget.currentModel.currentMenu3,
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
           ),
           ],
           ),
           Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
           Padding(
           padding: const EdgeInsets.only( bottom: 12, top: 12),
           child: Text(widget.currentModel.currentPrice1.toString(),
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
           ),
           Padding(
           padding: const EdgeInsets.only( bottom: 12, top: 12),
           child: Text(widget.currentModel.currentPrice2.toString(),
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),
           ),
           ),
           Padding(
           padding: const EdgeInsets.only( bottom: 12, top: 12),
           child: Text(widget.currentModel.currentPrice3.toString(),
           style: TextStyle(fontFamily: "BMJUA", fontSize: 13, color: Colors.black87),),
           ),
           ],
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
           Padding(
           padding: const EdgeInsets.only(top: 12, left: 16, bottom: 12),
           child: Text('총 결제금액', style: TextStyle(color: Colors.black87, fontSize: 15),),
           ),
           Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
           Padding(
           padding: const EdgeInsets.only(bottom: 12, top: 12),
           child: Text((widget.currentModel.currentPrice1 + widget.currentModel.currentPrice2 + widget.currentModel.currentPrice3).toString(),
           style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.black87),),
           )
           ],
           )
           ],
           )
           ],
           ),
           ),
           );
           }
           );
           },
           ),
           ),
             Padding(
               padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
               child:
                 Switch(
                   value: widget.currentModel.depositCheck,
                   onChanged: (value) {
                     setState(() {
                       widget.currentModel.depositCheck = value;
                       _currentNotifier.refreshNewDeposit(widget.currentModel);
                     });
                     },
                   activeColor: Colors.green,
                 ),
             ),
           Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
           Padding(
           padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
           child: widget.currentModel.depositCheck
               ? Text('입금확인',
               style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.green))
               : Text('입금대기',
               style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.grey))
           ),
           ]
           ,
           )
           ,
           ]
           ,
           );
            }
           )
       );
  }
}



