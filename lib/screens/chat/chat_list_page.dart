import 'package:app_3/repo/algolia_service.dart';
import 'package:beamer/src/beamer.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/repo/chat_service.dart';

class ChatListPage extends StatefulWidget {
  final String userKey;
  const ChatListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  bool init = false;
  List<ChatroomModel> chatrooms = [];
  List<ChatroomModel> doneChatrooms = [];

  @override
  void initState() {
    if (!init) {
      _onRefresh();
      init = true;
    }
    super.initState();
  }

  Future _onRefresh() async {
    chatrooms.clear();
    chatrooms.addAll(await ChatService().getMyChatList(widget.userKey));
    setState(() {});
  }

  Future _onDoneRefresh() async {
    doneChatrooms.clear();
    doneChatrooms.addAll(await ChatService().getMyDoneChatList(widget.userKey));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          Size size = MediaQuery.of(context).size;
          return ContainedTabBarView(
            tabs: [
              Text("진행 중"),
              Text("완료")
            ],
            tabBarProperties: TabBarProperties(
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey[400],
                isScrollable: false
            ),
            views: [
              _continueList(),
              _doneList()
            ],
            onChange: (index) => print(index),
          );
        });
  }

  Widget _continueList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
        itemBuilder: (context, index) {
          ChatroomModel chatroomModel = chatrooms[index];
          bool iamBuyer = chatroomModel.buyerKey == widget.userKey;
          Size size = MediaQuery.of(context).size;
          return ListTile(
            onTap: () {
              context.beamToNamed('/${chatroomModel.chatroomKey}');
            },
            leading: chatroomModel.chatroomClosed
                ? ExtendedImage.asset(
              'assets/images/finish_icon.png',
              shape: BoxShape.circle,
              fit: BoxFit.cover,
              height: size.width / 8,
              width: size.width / 8,)
                : ExtendedImage.asset(
              'assets/images/food_icon.png',
              shape: BoxShape.circle,
              fit: BoxFit.cover,
              height: size.width / 8,
              width: size.width / 8,) ,
            title: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "${chatroomModel.itemTitle}",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            subtitle: Text(
              "${chatroomModel.menu1} ...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey[300],
          );
        },
        itemCount: chatrooms.length,
      ),
    );
  }
  Widget _doneList() {
    return RefreshIndicator(
      onRefresh: _onDoneRefresh,
      child: ListView.separated(
        itemBuilder: (context, index) {
          ChatroomModel chatroomModel = doneChatrooms[index];
          bool iamBuyer = chatroomModel.buyerKey == widget.userKey;
          Size size = MediaQuery.of(context).size;
          return ListTile(
            onTap: () {
              context.beamToNamed('/${chatroomModel.chatroomKey}');
            },
            leading: chatroomModel.chatroomClosed
                ? ExtendedImage.asset(
              'assets/images/finish_icon.png',
              shape: BoxShape.circle,
              fit: BoxFit.cover,
              height: size.width / 8,
              width: size.width / 8,)
                : ExtendedImage.asset(
              'assets/images/food_icon.png',
              shape: BoxShape.circle,
              fit: BoxFit.cover,
              height: size.width / 8,
              width: size.width / 8,) ,
            title: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: "${chatroomModel.itemTitle}",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            subtitle: Text(
              "${chatroomModel.menu1} ...",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey[300],
          );
        },
        itemCount: doneChatrooms.length,
      ),
    );
  }
}