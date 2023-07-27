import 'package:app_3/data/current_model.dart';
import 'package:app_3/repo/algolia_service.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:flutter/foundation.dart';
import 'package:app_3/data/chat_model.dart';
import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/repo/chat_service.dart';

class ChatNotifier extends ChangeNotifier {
  ChatroomModel? _chatroomModel;
  List<ChatModel> _chatList = [];
  final String _chatroomKey;

  ChatNotifier(this._chatroomKey) {
    ChatService().connectChatroom(_chatroomKey).listen((chatroomModel) {
      this._chatroomModel = chatroomModel;

      if (this._chatList.isEmpty) {
        ChatService().getChatList(_chatroomKey).then((chatList) {
          _chatList.addAll(chatList);
          notifyListeners();
        });
      } else {
        if (this._chatList[0].reference == null) this._chatList.removeAt(0);
        ChatService()
            .getLatestChats(_chatroomKey, this._chatList[0].reference!)
            .then((latestChats) {
          this._chatList.insertAll(0, latestChats);
          notifyListeners();
        });
      }
    });
  }

  void addNewChat(ChatModel chatModel) {
    _chatList.insert(0, chatModel);
    notifyListeners();

    ChatService().createNewChat(_chatroomKey, chatModel);
  }

  void updateClosed() {
   chatroomModel!.chatroomClosed = chatroomModel!.chatroomClosed;
    notifyListeners();

    ChatService().updateChatClosed(_chatroomKey, chatroomModel!);
  }

  void deleteChatroom() {
    notifyListeners();

    ChatService().deleteChatroom(_chatroomKey);
  }



  List<ChatModel> get chatList => _chatList;

  ChatroomModel? get chatroomModel => _chatroomModel;

  String get chatroomKey => _chatroomKey;
}