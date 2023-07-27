import 'package:app_3/constants/data_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentModel {
  late String currentKey;
  late bool depositCheck;
  late String? currentPhoneNum;
  late String currentMenu1;
  late num currentPrice1;
  late String currentMenu2;
  late num currentPrice2;
  late String currentMenu3;
  late num currentPrice3;
  late DateTime userCreatedDate;
  late String userKey;
  late DocumentReference? reference;

  CurrentModel(
      {required this.depositCheck,
        required this.currentPhoneNum,
        required this.currentMenu1,
        required this.currentPrice1,
        required this.currentMenu2,
        required this.currentPrice2,
        required this.currentMenu3,
        required this.currentPrice3,
        required this.userCreatedDate,
        required this.userKey,
        required this.currentKey,
        this.reference});

  CurrentModel.fromJson(Map<String, dynamic> json, this.currentKey, this.reference) {
    depositCheck = json[DOC_DEPOSITCHECK] ?? false;
    currentPhoneNum = json[DOC_CURRENTPHONENUM] ?? "";
    currentMenu1 = json[DOC_CURRENTMENU1] ?? "";
    currentPrice1 = json[DOC_CURRENTPRICE1] ?? 0;
    currentMenu2 = json[DOC_CURRENTMENU2] ?? "";
    currentPrice2 = json[DOC_CURRENTPRICE2] ?? 0;
    currentMenu3 = json[DOC_CURRENTMENU3] ?? "";
    currentPrice3 = json[DOC_CURRENTPRICE3] ?? 0;
    userCreatedDate = json[DOC_USERCREATEDDATE] == null
        ? DateTime.now().toUtc()
        : (json[DOC_USERCREATEDDATE] as Timestamp).toDate();
    userKey = json[DOC_USERKEY] ?? "";
    currentKey = json[DOC_CURRENTKEY] ?? "";
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map[DOC_DEPOSITCHECK] = depositCheck;
    map[DOC_CURRENTPHONENUM] = currentPhoneNum;
    map[DOC_CURRENTMENU1] = currentMenu1;
    map[DOC_CURRENTPRICE1] = currentPrice1;
    map[DOC_CURRENTMENU2] = currentMenu2;
    map[DOC_CURRENTPRICE2] = currentPrice2;
    map[DOC_CURRENTMENU3] = currentMenu3;
    map[DOC_CURRENTPRICE3] = currentPrice3;
    map[DOC_USERCREATEDDATE] = userCreatedDate;
    map[DOC_USERKEY] = userKey;
    map[DOC_CURRENTKEY] = currentKey;
    return map;
  }

  CurrentModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data(), snapshot.id, snapshot.reference);

  CurrentModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : this.fromJson(snapshot.data()!, snapshot.id, snapshot.reference);

  static String generateCurrentKey(String userKey, String itemKey) {
    return '${userKey}_$itemKey';
  }
}