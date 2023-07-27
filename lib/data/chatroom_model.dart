import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:app_3/constants/data_keys.dart';

/// item_image : ""
/// item_title : ""
/// item_key : ""
/// item_address : ""
/// item_price : 0.0
/// seller_key : ""
/// buyer_key : ""
/// seller_image : ""
/// buyer_image : ""
/// geo_fire_point : ""
/// last_msg : ""
/// last_msg_time : "2012-04-21T18:25:43-05:00"
/// last_msg_user_key : ""
/// chatroom_key : ""
class ChatroomModel {
  late String itemTitle;
  late String itemKey;
  late String currentroomKey;
  late String itemAddress1;
  late String itemAddress2;
  late num itemPrice;
  late String itemTime;
  late num itemAccount;
  late String itemBank;
  late String? itemPhoneNum;
  late String? buyerPhoneNum;
  late String menu1;
  late String menu2;
  late String menu3;
  late num menuPrice1;
  late num menuPrice2;
  late num menuPrice3;
  late String sellerKey;
  late String buyerKey;
  late String sellerImage;
  late String buyerImage;
  late GeoFirePoint geoFirePoint;
  late String lastMsg;
  late DateTime lastMsgTime;
  late String lastMsgUserKey;
  late bool chatroomClosed;
  late num stat;
  late String chatroomKey;
  DocumentReference? reference;

  ChatroomModel(
      {required this.itemTitle,
        required this.itemKey,
        required this.currentroomKey,
        required this.itemAddress1,
        required this.itemAddress2,
        required this.itemPrice,
        required this.itemTime,
        required this.itemAccount,
        required this.itemBank,
        required this.itemPhoneNum,
        required this.buyerPhoneNum,
        required this.menu1,
        required this.menu2,
        required this.menu3,
        required this.menuPrice1,
        required this.menuPrice2,
        required this.menuPrice3,
        required this.sellerKey,
        required this.buyerKey,
        required this.sellerImage,
        required this.buyerImage,
        required this.geoFirePoint,
        this.lastMsg = "",
        required this.lastMsgTime,
        this.lastMsgUserKey = "",
        required this.chatroomClosed,
        required this.stat,
        required this.chatroomKey,
        this.reference});

  ChatroomModel.fromJson(
      Map<String, dynamic> json, this.chatroomKey, this.reference) {
    itemTitle = json[DOC_ITEMTITLE] ?? "";
    itemKey = json[DOC_ITEMKEY] ?? "";
    currentroomKey = json[DOC_CURRENTROOMKEY] ?? "";
    itemAddress1 = json[DOC_ITEMADDRESS1] ?? "";
    itemAddress2 = json[DOC_ITEMADDRESS2] ?? "";
    itemPrice = json[DOC_ITEMPRICE] ?? 0;
    itemTime = json[DOC_ITEMTIME] ?? "";
    itemAccount = json[DOC_ITEMACCOUNT] ?? 0;
    itemBank = json[DOC_ITEMBANK] ?? "";
    itemPhoneNum = json[DOC_ITEMPHONENUM] ?? "";
    buyerPhoneNum = json[DOC_BUYERPHONENUM] ?? "";
    menu1 = json[DOC_MENU1] ?? "";
    menu2 = json[DOC_MENU2] ?? "";
    menu3 = json[DOC_MENU3] ?? "";
    menuPrice1 = json[DOC_MENUPRICE1] ?? 0;
    menuPrice2 = json[DOC_MENUPRICE2] ?? 0;
    menuPrice3 = json[DOC_MENUPRICE3] ?? 0;
    sellerKey = json[DOC_SELLERKEY] ?? "";
    buyerKey = json[DOC_BUYERKEY] ?? "";
    sellerImage = json[DOC_SELLERIMAGE] ?? "";
    buyerImage = json[DOC_BUYERIMAGE] ?? "";
    geoFirePoint = json[DOC_GEOFIREPOINT] == null
        ? GeoFirePoint(0, 0)
        : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
        (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
    lastMsg = json[DOC_LASTMSG] ?? "";
    lastMsgTime = json[DOC_LASTMSGTIME] == null
        ? DateTime.now().toUtc()
        : (json[DOC_LASTMSGTIME] as Timestamp).toDate();
    lastMsgUserKey = json[DOC_LASTMSGUSERKEY] ?? "";
    chatroomClosed = json[DOC_CHATROOMCLOSED] ?? false;
    stat = json[DOC_STAT] ?? 0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_ITEMTITLE] = itemTitle;
    map[DOC_ITEMKEY] = itemKey;
    map[DOC_CURRENTROOMKEY] = currentroomKey;
    map[DOC_ITEMADDRESS1] = itemAddress1;
    map[DOC_ITEMADDRESS2] = itemAddress2;
    map[DOC_ITEMPRICE] = itemPrice;
    map[DOC_ITEMTIME] = itemTime;
    map[DOC_ITEMACCOUNT] = itemAccount;
    map[DOC_ITEMBANK] = itemBank;
    map[DOC_ITEMPHONENUM] = itemPhoneNum;
    map[DOC_BUYERPHONENUM] = buyerPhoneNum;
    map[DOC_MENU1] = menu1;
    map[DOC_MENU2] = menu2;
    map[DOC_MENU3] = menu3;
    map[DOC_MENUPRICE1] = menuPrice1;
    map[DOC_MENUPRICE2] = menuPrice2;
    map[DOC_MENUPRICE3] = menuPrice3;
    map[DOC_SELLERKEY] = sellerKey;
    map[DOC_BUYERKEY] = buyerKey;
    map[DOC_SELLERIMAGE] = sellerImage;
    map[DOC_BUYERIMAGE] = buyerImage;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_LASTMSG] = lastMsg;
    map[DOC_LASTMSGTIME] = lastMsgTime;
    map[DOC_LASTMSGUSERKEY] = lastMsgUserKey;
    map[DOC_CHATROOMCLOSED] = chatroomClosed;
    map[DOC_STAT] = stat;

    return map;
  }

  ChatroomModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ChatroomModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateChatRoomKey(String buyer, String itemKey) {
    return '${itemKey}_$buyer';
  }
}