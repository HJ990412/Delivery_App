import 'package:extended_image/extended_image.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatelessWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size size = MediaQuery.of(context).size;

        final imgOne = size.width - 32;
        final imgTwo = imgOne * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                SizedBox(
                  width: imgOne,
                  height: imgOne,
                  child: Stack(
                    children: [
                      ExtendedImage.asset('assets/images/intro_one.png'),
                    ],
                  ),
                ),
                Text(
                  '우리 동네 공동 배달',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                Text(
                  '이 어플은 동네 공동배달 앱이에요.\n내 동네를 설정하고 시작해보세요!',
                  style: TextStyle(fontSize: 13),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: () async {
                        context.read<PageController>().animateToPage(1,
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeOut);
                      },
                      child: Text(
                        '내 동네 설정하고 시작하기',
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}