import 'dart:async';

import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:latlng/latlng.dart';
import 'package:app_3/constants/data_keys.dart';
import 'package:app_3/data/item_model.dart';

class ItemService {
  static final ItemService _itemService = ItemService._internal();
  factory ItemService() => _itemService;
  ItemService._internal();

  Future createNewItem(
      ItemModel itemModel, String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS)
        .doc(itemKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, itemModel.toJson());
        transaction.set(userItemDocReference, itemModel.toMinJson());
      });
    }
  }

  Future<ItemModel> getItem(String itemKey) async {
    if (itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    ItemModel itemModel = ItemModel.fromSnapshot(documentSnapshot);
    return itemModel;
  }

  Future<List<ItemModel>> getUserItems(String userKey,
      {String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CLOSED, isEqualTo: false)
        .get();
    List<ItemModel> items = [];
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(itemKey != null && itemKey == itemModel.itemKey))
        items.add(itemModel);
    }
    return items;
  }

  Future<List<ItemModel>> getDoneUserItems(String userKey,
      {String? itemKey}) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CLOSED, isEqualTo: true)
        .get();
    List<ItemModel> doneitems = [];
    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(itemKey != null && itemKey == itemModel.itemKey))
        doneitems.add(itemModel);
    }
    return doneitems;
  }

  Future<List<ItemModel>> getItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_USERKEY, isNotEqualTo: userKey)
        .get();

    List<ItemModel> items = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      items.add(itemModel);
    }
    return items;
  }

  Future<List<ItemModel>> getChickenItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "chicken")
        .get();

    List<ItemModel> chickens = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      chickens.add(itemModel);
    }
    return chickens;
  }

  Future<List<ItemModel>> getPizzaItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "pizza")
        .get();

    List<ItemModel> pizza = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      pizza.add(itemModel);
    }
    return pizza;
  }

  Future<List<ItemModel>> getBurgerItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);

    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "burger")
        .get();

    List<ItemModel> burger = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      burger.add(itemModel);
    }
    return burger;
  }

  Future<List<ItemModel>> getChineseItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "chinese")
        .get();

    List<ItemModel> chinese = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      chinese.add(itemModel);
    }
    return chinese;
  }

  Future<List<ItemModel>> getKoreanItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "korean")
        .get();

    List<ItemModel> korean = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      korean.add(itemModel);
    }
    return korean;
  }

  Future<List<ItemModel>> getJapaneseItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "japanese")
        .get();

    List<ItemModel> japanese = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      japanese.add(itemModel);
    }
    return japanese;
  }

  Future<List<ItemModel>> getCafeItems(String userKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance.collection(COL_ITEMS);
    QuerySnapshot<Map<String, dynamic>> snapshots = await collectionReference
        .where(DOC_CATEGORY, isEqualTo: "cafe/dessert")
        .get();

    List<ItemModel> cafe = [];

    for (int i = 0; i < snapshots.size; i++) {
      ItemModel itemModel = ItemModel.fromQuerySnapshot(snapshots.docs[i]);
      if (!(userKey == itemModel.userKey))
      cafe.add(itemModel);
    }
    return cafe;
  }

  Future<List<ItemModel>> getNearByItems(String userKey, LatLng latLng) async {
    final geo = Geoflutterfire();
    final itemCol = FirebaseFirestore.instance.collection(COL_ITEMS);
    GeoFirePoint center = GeoFirePoint(latLng.latitude, latLng.longitude);
    double radius = 10;
    var field = 'geoFirePoint';

    List<ItemModel> items = [];
    List<DocumentSnapshot<Map<String, dynamic>>> snapshots = await geo
        .collection(collectionRef: itemCol)
        .within(center: center, radius: radius, field: field)
        .first;
    for (int i = 0; i < snapshots.length; i++) {
      ItemModel itemModel = ItemModel.fromSnapshot(snapshots[i]);
      if (!(userKey != null && userKey == itemModel.userKey))
      items.add(itemModel);
    }
    return items;
  }

  Future closedUpdate(String userkey, String itemKey,ItemModel itemModel) async {
    if (itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_ITEMS)
            .doc(itemKey);

    DocumentReference<Map<String, dynamic>> userdocumentReference =
        FirebaseFirestore.instance
            .collection(COL_USERS)
            .doc(userkey)
            .collection(COL_USER_ITEMS)
            .doc(itemKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference,{
        DOC_CLOSED: itemModel.closed,
      });
      transaction.update(userdocumentReference,{
        DOC_CLOSED: itemModel.closed,
      });
    });
  }

  Future increaseParticipants(String itemKey, ItemModel itemModel) async {
    if (itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_ITEMS)
            .doc(itemKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_PARTICIPANTS: itemModel.participants + 1,
      });
    });
  }

  Future decreaseParticipants(String itemKey, ItemModel itemModel) async {
    if (itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_ITEMS)
        .doc(itemKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_PARTICIPANTS: itemModel.participants - 1,
      });
    });
  }

  Future deleteItem(String itemKey, String userKey) async {
    if (itemKey[0] == ':') {
      itemKey = itemKey.substring(1);
    }
    DocumentReference<Map<String,dynamic>> documentReference =
        FirebaseFirestore.instance.collection(COL_ITEMS).doc(itemKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS)
        .doc(itemKey);

    await documentReference.delete();
    await userItemDocReference.delete();
  }
}