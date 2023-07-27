import 'package:app_3/constants/data_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// itemKey : ""
/// currentItemKey : ""
/// currentDeliverStat : 0
/// currentDeliverTime : 0
/// currentSellerPhone : ""
/// geoFirePoint : ""
/// currentRoomKey : ""

class CurrentroomModel {
  late String itemKey;
  late String currentSellerKey;
  late String chatroomKey;
  late int currentDeliverStat;
  late num currentDeliverTime;
  late String currentTitle;
  late num currentItemPrice;
  late String currentTime;
  late String? currentPhone;
  late num currentAccount;
  late String currentBank;
  late String currentAddress1;
  late String currentAddress2;
  late String currentRoomKey;
  late bool currentClosed;
  DocumentReference? reference;


  CurrentroomModel({
      required this.itemKey,
      required this.currentSellerKey,
      required this.chatroomKey,
      required this.currentDeliverStat,
      required this.currentDeliverTime,
      required this.currentTitle,
      required this.currentItemPrice,
      required this.currentTime,
      required this.currentPhone,
      required this.currentAccount,
      required this.currentBank,
      required this.currentAddress1,
      required this.currentAddress2,
      required this.currentRoomKey,
      required this.currentClosed,
      this.reference});

  CurrentroomModel.fromJson(
      Map<String, dynamic> json, this.currentRoomKey, this.reference) {
    itemKey = json[DOC_ITEMKEY] ?? "";
    currentSellerKey = json[DOC_CURRENTSELLERKEY] ?? "";
    chatroomKey = json[DOC_CHATROOMKEY] ?? "";
    currentDeliverStat = json[DOC_CURRENTDELIVERSTAT] ?? 0;
    currentDeliverTime = json[DOC_CURRENTDELIVERTIME] ?? 0;
    currentTitle = json[DOC_CURRENTTITLE] ?? 0;
    currentItemPrice = json[DOC_CURRENTITEMPRICE] ?? 0;
    currentTime = json[DOC_ITEMTIME] ?? "";
    currentPhone = json[DOC_CURRENTPHONE] ?? "";
    currentAccount = json[DOC_CURRENTACCOUNT] ?? 0;
    currentBank = json[DOC_CURRENTBANK] ?? "";
    currentAddress1 = json[DOC_CURRENTADDRESS1] ?? "";
    currentAddress2 = json[DOC_CURRENTADDRESS2] ?? "";
    currentRoomKey = json[DOC_CURRENTROOMKEY] ?? "";
    currentClosed = json[DOC_CURRENTCLOSED] ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[DOC_ITEMKEY] = itemKey;
    map[DOC_CURRENTSELLERKEY] = currentSellerKey;
    map[DOC_CHATROOMKEY] = chatroomKey;
    map[DOC_CURRENTDELIVERSTAT] = currentDeliverStat;
    map[DOC_CURRENTDELIVERTIME] = currentDeliverTime;
    map[DOC_CURRENTTITLE] = currentTitle;
    map[DOC_CURRENTITEMPRICE] = currentItemPrice;
    map[DOC_ITEMTIME] = currentTime;
    map[DOC_CURRENTPHONE] = currentPhone;
    map[DOC_CURRENTACCOUNT] = currentAccount;
    map[DOC_CURRENTBANK] = currentBank;
    map[DOC_CURRENTADDRESS1] = currentAddress1;
    map[DOC_CURRENTADDRESS2] = currentAddress2;
    map[DOC_CURRENTROOMKEY] = currentRoomKey;
    map[DOC_CURRENTCLOSED] = currentClosed;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    final map = <String, dynamic>{};
    map[DOC_CURRENTSELLERKEY] = currentSellerKey;
    map[DOC_CURRENTTITLE] = currentTitle;
    map[DOC_CURRENTROOMKEY] = currentRoomKey;
    map[DOC_CURRENTCLOSED]= currentClosed;
    return map;
  }

  CurrentroomModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  CurrentroomModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateCurrentroomKey(String currentSellerKey, String itemKey) {
    return '${itemKey}_$currentSellerKey';
  }

}