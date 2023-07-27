
import 'package:app_3/constants/common_size.dart';
import 'package:app_3/constants/shared_pref_keys.dart';
import 'package:app_3/data/address_model.dart';
import 'package:app_3/data/address_model2.dart';
import 'package:app_3/screens/current/current_list_page.dart';
import 'package:app_3/screens/item/item_list_page.dart';
import 'package:app_3/screens/start/address_service.dart';
import 'package:app_3/utils/logger.dart';
import 'package:beamer/src/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/router/locations.dart';
import 'package:app_3/screens/home/map_page.dart';
import 'package:app_3/states/user_notifier.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat/chat_list_page.dart';
import 'home/items_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    UserModel? userModel = context.read<UserNotifier>().userModel;
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.address,
            style: TextStyle(fontFamily: "BMJUA", fontSize: 15, color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                context.beamToNamed('/$LOCATION_SEARCH');
              },
              icon: Icon(Icons.search),
              color: Colors.white,),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.beamToNamed("/");
            },
            color: Colors.white,
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: (userModel == null)
          ? Container()
          :IndexedStack(
             index: _bottomSelectedIndex,
             children: [
               ItemsPage(userKey: userModel.userKey),
               ChatListPage(userKey: userModel.userKey),
               CurrentListPage(userKey: userModel.userKey),
               ItemListPage(userKey: userModel.userKey),
        ],
      ),
      floatingActionButton: FloatingActionButton(

            onPressed: () {
              context.beamToNamed('input');
            },
            shape: CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),


      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectedIndex == 0
                  ? 'assets/icons/icon_home_select.png'
                  : 'assets/icons/icon_home_normal.png'),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectedIndex == 1
                  ? 'assets/icons/icon_chat_select.png'
                  : 'assets/icons/icon_chat_normal.png'),
            ),
            label: '참여내역',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectedIndex == 2
                  ? 'assets/icons/icon_info_select.png'
                  : 'assets/icons/icon_info_normal.png'),
            ),
            label: '다모아',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(_bottomSelectedIndex == 3
                  ? 'assets/icons/icon_info_select.png'
                  : 'assets/icons/icon_info_normal.png'),
            ),
            label: '주문방',
          ),
        ],
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
      ),
    );
  }
}