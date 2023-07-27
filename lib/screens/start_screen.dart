import 'package:app_3/screens/start/address_page.dart';
import 'package:app_3/screens/start/intro_page.dart';
import 'package:app_3/screens/start/phone_auth_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartScreen extends StatelessWidget {

  PageController _pageController = PageController();

  StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<PageController>.value(
      value: _pageController,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          //physics: NeverScrollableScrollPhysics(),
          children: [
          IntroPage(),
          AddressPage(),
          PhoneAuthPage(),
        ]
        ),
      ),
    );
  }
}
