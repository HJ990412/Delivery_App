import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:app_3/constants/data_keys.dart';

class ItemModel {
  late String itemKey;
  late String userKey;
  late String currentroomKey;
  late String? phoneNum;
  late String title;
  late String category;
  late num price;
  late String time;
  late String bank;
  late num account;
  late String itemAddress2;
  late String itemAddress1;
  late String address;
  late GeoFirePoint geoFirePoint;
  late DateTime createdDate;
  late bool closed;
  late num participants;
  DocumentReference? reference;

  ItemModel(
      {required this.itemKey,
        required this.userKey,
        required this.currentroomKey,
        required this.phoneNum,
        required this.title,
        required this.category,
        required this.price,
        required this.bank,
        required this.account,
        required this.time,
        required this.itemAddress2,
        required this.itemAddress1,
        required this.address,
        required this.geoFirePoint,
        required this.createdDate,
        required this.closed,
        required this.participants,
        this.reference});

  ItemModel.fromJson(Map<String, dynamic> json, this.itemKey, this.reference) {
    userKey = json[DOC_USERKEY] ?? "";
    currentroomKey = json[DOC_CURRENTROOMKEY] ?? "";
    phoneNum = json[DOC_PHONENUM] ?? "";
    title = json[DOC_TITLE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    bank = json[DOC_BANK] ?? "";
    account = json[DOC_ACCOUNT] ?? 0;
    time = json[DOC_TIME] ?? "";
    itemAddress2 = json[DOC_ITEMADDRESS2] ?? "";
    itemAddress1 = json[DOC_ITEMADDRESS1] ?? "";
    address = json[DOC_ADDRESS] ?? "";
    geoFirePoint = json[DOC_GEOFIREPOINT] == null
        ? GeoFirePoint(0, 0)
        : GeoFirePoint((json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).latitude,
        (json[DOC_GEOFIREPOINT][DOC_GEOPOINT]).longitude);
    createdDate = json[DOC_CREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_CREATEDDATE] as Timestamp).toDate();
    closed = json[DOC_CLOSED] ?? true;
    participants = json[DOC_PARTICIPANTS] ?? 0;
  }
  ItemModel.fromAlgoliaObject(Map<String, dynamic> json, this.itemKey) {
    userKey = json[DOC_USERKEY] ?? "";
    currentroomKey = json[DOC_CURRENTROOMKEY] ?? "";
    phoneNum = json[DOC_PHONENUM] ?? "";
    title = json[DOC_TITLE] ?? "";
    category = json[DOC_CATEGORY] ?? "none";
    price = json[DOC_PRICE] ?? 0;
    time = json[DOC_TIME] ?? "";
    bank = json[DOC_BANK] ?? "";
    account = json[DOC_ACCOUNT] ?? 0;
    address = json[DOC_ADDRESS] ?? "";
    itemAddress2 = json[DOC_ITEMADDRESS2] ?? "";
    geoFirePoint = GeoFirePoint(0, 0);
    createdDate = DateTime.now().toUtc();
    closed = json[DOC_CLOSED] ?? false;
  }

  ItemModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  ItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_USERKEY] = userKey;
    map[DOC_CURRENTROOMKEY] = currentroomKey;
    map[DOC_PHONENUM] = phoneNum;
    map[DOC_TITLE] = title;
    map[DOC_CATEGORY] = category;
    map[DOC_PRICE] = price;
    map[DOC_BANK] = bank;
    map[DOC_ACCOUNT] = account;
    map[DOC_TIME] = time;
    map[DOC_ITEMADDRESS2] = itemAddress2;
    map[DOC_ITEMADDRESS1] = itemAddress1;
    map[DOC_ADDRESS] = address;
    map[DOC_GEOFIREPOINT] = geoFirePoint.data;
    map[DOC_CREATEDDATE] = createdDate;
    map[DOC_CLOSED] = closed;
    map[DOC_PARTICIPANTS] = participants;
    return map;
  }

  Map<String, dynamic> toMinJson() {
    var map = <String, dynamic>{};
    map[DOC_TITLE] = title;
    map[DOC_PRICE] = price;
    map[DOC_TIME] = time;
    map[DOC_BANK] = bank;
    map[DOC_ACCOUNT] = account;
    map[DOC_ITEMADDRESS2] = itemAddress2;
    map[DOC_CLOSED] = closed;
    return map;
  }

  static String generateItemKey(String uid) {
    String timeInMilli = DateTime.now().millisecondsSinceEpoch.toString();
    return '${uid}_$timeInMilli';
  }
}