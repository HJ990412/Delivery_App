import 'package:app_3/data/item_model.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/router/locations.dart';
import 'package:beamer/beamer.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ItemListPage extends StatefulWidget {
  final String userKey;
  const ItemListPage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  bool init = false;
  List<ItemModel> myitems = [];
  List<ItemModel> myDoneitems = [];

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
    myitems.clear();
    myitems.addAll(await ItemService().getUserItems(widget.userKey));
    setState(() {});
  }

  Future _onDoneRefresh() async {
    myDoneitems.clear();
    myDoneitems.addAll(await ItemService().getDoneUserItems(widget.userKey));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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

        });
  }

  Widget _continueList() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            ItemModel itemModel = myitems[index];
            Size size = MediaQuery.of(context).size;
            return ListTile(
              onTap: () {
                context.beamToNamed('/$LOCATION_ITEM/:${itemModel.itemKey}');
              },
              leading: itemModel.closed
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
                  text: "${itemModel.title}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              subtitle: Text(
                "마감 설정 시간 : ${itemModel.time}",
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
          itemCount: myitems.length
      ),
    );
  }
  Widget _doneList() {
    return RefreshIndicator(
      onRefresh: _onDoneRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            ItemModel itemModel = myDoneitems[index];
            Size size = MediaQuery.of(context).size;
            return ListTile(
              onTap: () {
                context.beamToNamed('/$LOCATION_ITEM/:${itemModel.itemKey}');
              },
              leading: itemModel.closed
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
                  text: "${itemModel.title}",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              subtitle: Text(
                "마감 설정 시간 : ${itemModel.time}",
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
          itemCount: myDoneitems.length
      ),
    );
  }
}