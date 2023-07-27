
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/router/locations.dart';
import 'package:beamer/beamer.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CurrentListPage extends StatefulWidget {
  final String userKey;
  const CurrentListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<CurrentListPage> createState() => _CurrentListPageState();
}

class _CurrentListPageState extends State<CurrentListPage> {
  bool init = false;
  List<CurrentroomModel> currentrooms = [];
  List<CurrentroomModel> doneCurrentrooms = [];

  @override
  void initState() {
    if (!init) {
      _onRefresh();
      _onDoneRefresh();
      init = true;
    }
    super.initState();
  }

  Future _onRefresh() async {
    currentrooms.clear();
    currentrooms.addAll(await CurrentService().getMyCurrentList(widget.userKey));
    setState(() {});
  }

  Future _onDoneRefresh() async {
    doneCurrentrooms.clear();
    doneCurrentrooms.addAll(await CurrentService().getMyDoneCurrentList(widget.userKey));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: LayoutBuilder(
        builder: (context, snapshot) {
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

        })
    );
  }

  Widget _continueList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            CurrentroomModel currentroomModel = currentrooms[index];
            bool iamBuyer = currentroomModel.currentSellerKey != widget.userKey;
            Size size = MediaQuery.of(context).size;

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
                width: size.width / 8,) ,
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
  }
  Widget _doneList() {
    return RefreshIndicator(
      onRefresh: _onDoneRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            CurrentroomModel currentroomModel = doneCurrentrooms[index];
            bool iamBuyer = currentroomModel.currentSellerKey != widget.userKey;
            Size size = MediaQuery.of(context).size;

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
                width: size.width / 8,) ,
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
          itemCount: doneCurrentrooms.length
      ),
    );
  }
}
