import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_3/constants/data_keys.dart';
import 'package:app_3/data/chat_model.dart';
import 'package:app_3/data/chatroom_model.dart';

class ChatService {
  static final ChatService _chatService = ChatService._internal();
  factory ChatService() => _chatService;
  ChatService._internal();

  Future createNewChatroom(ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(
        ChatroomModel.generateChatRoomKey(
            chatroomModel.buyerKey, chatroomModel.itemKey));
    final DocumentSnapshot documentSnapshot = await documentReference.get();

    if (!documentSnapshot.exists) {
      await documentReference.set(chatroomModel.toJson());
    }
  }

  Future createNewChat(String chatroomKey, ChatModel chatModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .doc();

    DocumentReference<Map<String, dynamic>> chatroomDocRef =
    FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    await documentReference.set(chatModel.toJson());

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatModel.toJson());
      transaction.update(chatroomDocRef, {
        DOC_LASTMSG: chatModel.msg,
        DOC_LASTMSGTIME: chatModel.createdDate,
        DOC_LASTMSGUSERKEY: chatModel.userKey
      });
    });
  }

  Stream<ChatroomModel> connectChatroom(String chatroomKey) {
    return FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .snapshots()
        .transform(snapshotToChatroom);
  }

  var snapshotToChatroom = StreamTransformer<
      DocumentSnapshot<Map<String, dynamic>>,
      ChatroomModel>.fromHandlers(handleData: (snapshot, sink) {
    ChatroomModel chatroom = ChatroomModel.fromSnapshot(snapshot);
    sink.add(chatroom);
  });

  Future<List<ChatModel>> getChatList(String chatroomKey) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .limit(10)
        .get();

    List<ChatModel> chatlist = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  Future<List<ChatModel>> getLatestChats(
      String chatroomKey, DocumentReference currentLatestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .endBeforeDocument(await currentLatestChatRef.get())
        .get();

    List<ChatModel> chatlist = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  Future<List<ChatModel>> getOlderChats(
      String chatroomKey, DocumentReference oldestChatRef) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey)
        .collection(COL_CHATS)
        .orderBy(DOC_CREATEDDATE, descending: true)
        .startAfterDocument(await oldestChatRef.get())
        .limit(10)
        .get();

    List<ChatModel> chatlist = [];

    snapshot.docs.forEach((docSnapshot) {
      ChatModel chatModel = ChatModel.fromQuerySnapshot(docSnapshot);
      chatlist.add(chatModel);
    });
    return chatlist;
  }

  Future<List<ChatroomModel>> getMyChatList(String myUserkey) async {
    List<ChatroomModel> chatrooms = [];

    QuerySnapshot<Map<String, dynamic>> buying = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_BUYERKEY, isEqualTo: myUserkey)
        .where(DOC_CHATROOMCLOSED, isEqualTo: false)
        .get();

    buying.docs.forEach((documentSnapshot) {
      chatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    });

    print('chatroom list - ${chatrooms.length}');

    chatrooms.sort((a, b) => (a.lastMsgTime).compareTo(b.lastMsgTime));

    return chatrooms;
  }

  Future<List<ChatroomModel>> getMyDoneChatList(String myUserkey) async {
    List<ChatroomModel> doneChatrooms = [];

    QuerySnapshot<Map<String, dynamic>> buying = await FirebaseFirestore
        .instance
        .collection(COL_CHATROOMS)
        .where(DOC_BUYERKEY, isEqualTo: myUserkey)
        .where(DOC_CHATROOMCLOSED, isEqualTo: true)
        .get();

    buying.docs.forEach((documentSnapshot) {
      doneChatrooms.add(ChatroomModel.fromQuerySnapshot(documentSnapshot));
    });

    print('chatroom list - ${doneChatrooms.length}');

    doneChatrooms.sort((a, b) => (a.lastMsgTime).compareTo(b.lastMsgTime));

    return doneChatrooms;
  }

  Future updateChatClosed(String chatroomKey ,ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey);


    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_CHATROOMCLOSED: chatroomModel.chatroomClosed,
      });
    });
  }

  Future increaseEntrance(String chatroomKey, ChatroomModel chatroomModel) async {
    DocumentReference<Map<String, dynamic>> documentReference =
    FirebaseFirestore.instance
        .collection(COL_CHATROOMS)
        .doc(chatroomKey);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(documentReference, {
        DOC_STAT: chatroomModel.stat + 1,
      });
    });
  }

  Future deleteChatroom(String chatroomKey) async {

    DocumentReference<Map<String,dynamic>> documentReference =
    FirebaseFirestore.instance.collection(COL_CHATROOMS).doc(chatroomKey);

    await documentReference.delete();
  }
}