import 'dart:async';

import 'package:app_3/constants/data_keys.dart';
import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CurrentService {
  static final CurrentService _currentService = CurrentService._internal();
  factory CurrentService() => _currentService;
  CurrentService._internal();

  Future createNewCurrentRoom(CurrentroomModel currentroomModel, String currentroomKey,
      String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_CURRENTS).doc(currentroomKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS)
        .doc(itemKey)
        .collection(COL_USER_CURRENTROOM)
        .doc(currentroomKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(documentReference, currentroomModel.toJson());
        transaction.set(userItemDocReference, currentroomModel.toMinJson());
      });
    }
  }

  Future createNewUser(String currentroomKey, String currentKey, CurrentModel currentModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .collection(COL_CURRENT)
        .doc(currentKey);

    await documentReference.set(currentModel.toJson());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, currentModel.toJson());
    });
  }

  Stream<CurrentroomModel> connectCurrentroom(String currentroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .snapshots()
        .transform(snapshotToCurrentroom);
  }

  var snapshotToCurrentroom = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      CurrentroomModel>.fromHandlers(handleData: (snapshot, sink) {
    CurrentroomModel currentroom = CurrentroomModel.fromSnapshot(snapshot);
    sink.add(currentroom);
  });


  Future deleteCurrentRoom(CurrentroomModel currentroomModel, String currentroomKey,
      String itemKey, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_CURRENTS).doc(currentroomKey);
    DocumentReference<Map<String, dynamic>> userItemDocReference =
    FirebaseFirestore.instance
        .collection(COL_USERS)
        .doc(userKey)
        .collection(COL_USER_ITEMS)
        .doc(itemKey)
        .collection(COL_USER_CURRENTROOM)
        .doc(currentroomKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(documentReference);
        transaction.delete(userItemDocReference);
      });
    }
  }

  Future updateNewStat(String currentroomKey, CurrentroomModel? currentroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_CURRENTDELIVERSTAT: currentroomModel?.currentDeliverStat,
      });
    });
  }

  Future refreshNewStat(String currentroomKey, CurrentroomModel? currentroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_CURRENTS)
            .doc(currentroomKey);


    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_CURRENTDELIVERTIME: currentroomModel?.currentDeliverTime,
      });
    });
  }

  Future<List<CurrentroomModel>> getMyCurrentList(String myUserkey) async {
    List<CurrentroomModel> currentrooms = [];

    QuerySnapshot<Map<String, dynamic>> selling = await FirebaseFirestore
        .instance
        .collection(COL_CURRENTS)
        .where(DOC_CURRENTSELLERKEY, isEqualTo: myUserkey)
        .where(DOC_CURRENTCLOSED, isEqualTo: false)
        .get();

    selling.docs.forEach((documentSnapshot) {
      currentrooms.add(CurrentroomModel.fromQuerySnapshot(documentSnapshot));
    });

    print('chatroom list - ${currentrooms.length}');


    return currentrooms;
  }

  Future<List<CurrentroomModel>> getMyDoneCurrentList(String myUserkey) async {
    List<CurrentroomModel> doneCurrentrooms = [];

    QuerySnapshot<Map<String, dynamic>> selling = await FirebaseFirestore
        .instance
        .collection(COL_CURRENTS)
        .where(DOC_CURRENTSELLERKEY, isEqualTo: myUserkey)
        .where(DOC_CURRENTCLOSED, isEqualTo: true)
        .get();

    selling.docs.forEach((documentSnapshot) {
      doneCurrentrooms.add(CurrentroomModel.fromQuerySnapshot(documentSnapshot));
    });

    print('chatroom list - ${doneCurrentrooms.length}');


    return doneCurrentrooms;
  }

  Future<List<CurrentModel>> getCurrentList(String currentroomKey) async {
    CollectionReference<Map<String, dynamic>> collectionReference =
    FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .collection(COL_CURRENT);
    QuerySnapshot<Map<String, dynamic>> snapshot = await collectionReference
        .orderBy(DOC_USERCREATEDDATE, descending: true)
        .get();

    List<CurrentModel> currentlist = [];

    snapshot.docs.forEach((docSnapshot) {
      CurrentModel currentModel = CurrentModel.fromQuerySnapshot(docSnapshot);
      currentlist.add(currentModel);
    });
    return currentlist;
  }

  Future<List<CurrentModel>> getLatestCurrents(
      String currentroomKey, DocumentReference currentLatestCurrentRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .collection(COL_CURRENT)
        .orderBy(DOC_USERCREATEDDATE, descending: true)
        .endBeforeDocument(await currentLatestCurrentRef.get())
        .get();

    List<CurrentModel> currentlist = [];

    snapshot.docs.forEach((docSnapshot) {
      CurrentModel currentModel = CurrentModel.fromQuerySnapshot(docSnapshot);
      currentlist.add(currentModel);
    });
    return currentlist;
  }

  Future<List<CurrentModel>> getOlderCurrents(
      String currentroomKey, DocumentReference oldestCurrentRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .collection(COL_CURRENT)
        .orderBy(DOC_USERCREATEDDATE, descending: true)
        .startAfterDocument(await oldestCurrentRef.get())
        .get();

    List<CurrentModel> currentlist = [];

    snapshot.docs.forEach((docSnapshot) {
      CurrentModel currentModel = CurrentModel.fromQuerySnapshot(docSnapshot);
      currentlist.add(currentModel);
    });
    return currentlist;
  }

  Future updateNewDeposit(String currentKey, String currentroomKey ,CurrentModel currentModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey)
        .collection(COL_CURRENT)
        .doc(currentKey);


    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_DEPOSITCHECK: currentModel.depositCheck,
      });
    });
  }

  Future updateNewClosed(String currentroomKey ,CurrentroomModel currentroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CURRENTS)
        .doc(currentroomKey);


    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_CURRENTCLOSED: currentroomModel.currentClosed,
      });
    });
  }

  Future deleteCurrent(String currentRoomKey, String currentKey, String chatroomKey) async {
    if (currentRoomKey[0] == ':') {
      currentRoomKey = currentRoomKey.substring(1);
    }
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance
            .collection(COL_CURRENTS)
            .doc(currentRoomKey)
            .collection(COL_CURRENT)
            .doc(currentKey);
    DocumentReference<Map<String, dynamic>> chatroomDocumentReference =
        FirebaseFirestore.instance
            .collection(COL_CHATROOMS)
            .doc(chatroomKey);

    await documentReference.delete();
    await chatroomDocumentReference.delete();
  }
}

