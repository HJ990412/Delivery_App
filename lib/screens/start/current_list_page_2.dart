import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/router/locations.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CurrentListPage2 extends StatefulWidget {
  final String userKey;
  const CurrentListPage2({Key? key, required this.userKey}) : super(key: key);

  @override
  State<CurrentListPage2> createState() => _CurrentListPage2State();
}

class _CurrentListPage2State extends State<CurrentListPage2> {
  bool init = false;
  List<CurrentroomModel> currentrooms = [];

  @override
  void initState() {
    if (!init) {
      _onRefresh();
      init = true;
    }
    super.initState();
  }

  Future _onRefresh() async {
    currentrooms.clear();
    currentrooms.addAll(await CurrentService().getMyCurrentList(widget.userKey));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            onPressed: () {
              context.beamBack(); //뒤로가기 속성 가져오기
            },
            style: TextButton.styleFrom(
                primary: Colors.black87,
                backgroundColor:
                Theme
                    .of(context)
                    .appBarTheme
                    .backgroundColor),
            child: Text('뒤로', style: TextStyle(
                fontFamily: "BMJUA", fontSize: 12, color: Colors
                .white, fontWeight: FontWeight.w100)),
          ),
          title: Text(
            '나의 다모아',
            style: TextStyle(fontFamily: "BMJUA",
                fontSize: 20,
                color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: LayoutBuilder(
            builder: (context, snapshot) {
              Size size = MediaQuery.of(context).size;

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      CurrentroomModel currentroomModel = currentrooms[index];
                      bool iamBuyer = currentroomModel.currentSellerKey != widget.userKey;

                      return ListTile(
                        onTap: () {
                          context.beamToNamed('/$LOCATION_CURRENT/${currentroomModel.currentRoomKey}');
                        },
                        leading: currentroomModel.currentClosed
                            ? ExtendedImage.asset(
                          'assets/images/finish_icon.png',
                          shape: BoxShape.circle,
                          fit: BoxFit.cover,
                          height: size.width / 8,
                          width: size.width / 8,)
                            : ExtendedImage.asset(
                          'assets/images/leader_icon.png',
                          shape: BoxShape.circle,
                          fit: BoxFit.cover,
                          height: size.width / 8,
                          width: size.width / 8,),
                        title: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: "${currentroomModel.currentTitle}",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        subtitle: Text(
                          "픽업 장소 : ${currentroomModel.currentAddress1} ${currentroomModel.currentAddress2}",
                          maxLines: 2,
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
                    itemCount: currentrooms.length
                ),
              );

            })
    );
  }
}