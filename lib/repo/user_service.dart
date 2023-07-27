import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_3/constants/data_keys.dart';
import 'package:app_3/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final UserService _userService = UserService._internal();
  factory UserService() => _userService;
  UserService._internal();

  Future createNewUser(Map<String, dynamic> json, String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(json);
    }
  }

  Future<UserModel> getUserModel(String userKey) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
    await documentReference.get();
    UserModel userModel = UserModel.fromSnapshot(documentSnapshot);
    return userModel;
  }

  Future updateAddress(String userKey, UserModel userModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_USERS).doc(userKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_ADDRESS: userModel.address,
        DOC_GEOFIREPOINT: userModel.geoFirePoint.data
      });
    });
  }
}