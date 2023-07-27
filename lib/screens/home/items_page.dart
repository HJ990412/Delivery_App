import 'package:app_3/constants/data_keys.dart';
import 'package:app_3/data/chatroom_model.dart';
import 'package:app_3/data/user_model.dart';
import 'package:app_3/repo/chat_service.dart';
import 'package:app_3/states/category_notifier.dart';
import 'package:app_3/utils/logger.dart';
import 'package:app_3/utils/time_calculation.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_3/constants/common_size.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:app_3/repo/user_service.dart';
import 'package:app_3/router/locations.dart';
import 'package:shimmer/shimmer.dart';
import 'package:beamer/beamer.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatefulWidget {
  final String userKey;
  const ItemsPage({Key? key, required this.userKey}) : super(key: key);

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  bool init = false;
  List<ItemModel> items = [];
  List<ItemModel> chickens = [];
  List<ItemModel> pizza = [];
  List<ItemModel> burger = [];
  List<ItemModel> chinese = [];
  List<ItemModel> korean = [];
  List<ItemModel> japanese = [];
  List<ItemModel> cafe = [];

  String catepizza = 'pizza';

  @override
  void initState() {
    if (!init) {
      _onRefresh();
      _onChickenRefresh();
      _onPizzaRefresh();
      _onBurgerRefresh();
      _onChineseRefresh();
      _onKoreanRefresh();
      _onJapaneseRefresh();
      _onCafeRefresh();
      init = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        Size size = MediaQuery.of(context).size;
        final imgSize = size.width / 4;

        return ContainedTabBarView(
          tabs: [
            Text("전체" ,),
            Text("치킨" ,),
            Text("피자" ,),
            Text("버거" ,),
            Text("중식", ),
            Text("한식", ),
            Text("일식", ),
            Text("카페/디저트",),
          ],
          tabBarProperties: TabBarProperties(
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey[400],
            isScrollable: false
          ),
          views: [
            (items.isNotEmpty)
                ?_listView(imgSize)
                :_shimmerListView(imgSize),
            (chickens.isNotEmpty)
                ?_ChickenlistView(imgSize)
                :_shimmerListView1(imgSize),
            (pizza.isNotEmpty)
                ?_PizzalistView(imgSize)
                :_shimmerListView2(imgSize),
            (burger.isNotEmpty)
                ?_BurgerlistView(imgSize)
                :_shimmerListView3(imgSize),
            (chinese.isNotEmpty)
                ?_ChineselistView(imgSize)
                :_shimmerListView4(imgSize),
            (korean.isNotEmpty)
                ?_KoreanlistView(imgSize)
                :_shimmerListView5(imgSize),
            (japanese.isNotEmpty)
                ?_JapaneselistView(imgSize)
                :_shimmerListView6(imgSize),
            (cafe.isNotEmpty)
                ?_CafelistView(imgSize)
                :_shimmerListView7(imgSize),
          ],
          onChange: (index) => print(index),
        );

      },
    );
  }

  Future _onRefresh() async {
    items.clear();
    items.addAll(await ItemService().getItems(widget.userKey));
    setState(() {});
  }

  Future _onChickenRefresh() async {
    chickens.clear();
    chickens.addAll(await ItemService().getChickenItems(widget.userKey));
    setState(() {});
  }

  Future _onPizzaRefresh() async {
    pizza.clear();
    pizza.addAll(await ItemService().getPizzaItems(widget.userKey));
    setState(() {});
  }

  Future _onBurgerRefresh() async {
    burger.clear();
    burger.addAll(await ItemService().getBurgerItems(widget.userKey));
    setState(() {});
  }

  Future _onChineseRefresh() async {
    chinese.clear();
    chinese.addAll(await ItemService().getChineseItems(widget.userKey));
    setState(() {});
  }

  Future _onKoreanRefresh() async {
    korean.clear();
    korean.addAll(await ItemService().getKoreanItems(widget.userKey));
    setState(() {});
  }

  Future _onJapaneseRefresh() async {
    japanese.clear();
    japanese.addAll(await ItemService().getJapaneseItems(widget.userKey));
    setState(() {});
  }

  Future _onCafeRefresh() async {
    cafe.clear();
    cafe.addAll(await ItemService().getCafeItems(widget.userKey));
    setState(() {});
  }

  Widget _listView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = items[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }

          },
          itemCount: items.length),
    );
  }
  Widget _ChickenlistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onChickenRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = chickens[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: chickens.length),
    );
  }
  Widget _PizzalistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onPizzaRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = pizza[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: pizza.length),
    );
  }
  Widget _BurgerlistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onBurgerRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = burger[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: burger.length),
    );
  }
  Widget _ChineselistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onChineseRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = chinese[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: chinese.length),
    );
  }
  Widget _KoreanlistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onKoreanRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = korean[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: korean.length),
    );
  }
  Widget _JapaneselistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onJapaneseRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = japanese[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: japanese.length),
    );
  }
  Widget _CafelistView(double imgSize) {
    return RefreshIndicator(
      onRefresh: _onCafeRefresh,
      child: ListView.separated(
          separatorBuilder: (context, index){
            return Divider(
              height: common_sm_padding * 2,  //높이
              thickness: 0,  // 구분선
              color: Colors.grey[200],  // 구분석 색
              indent: common_sm_padding,  // 좌측 구분선 패딩
              endIndent: common_sm_padding,  // 우측 구분선 패딩
            );
          },
          padding: EdgeInsets.all(common_bg_padding),
          itemBuilder: (context, index){
            ItemModel item = cafe[index];
            bool closed = item.closed;
            if(closed == false) {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: InkWell(
                  onTap: (){
                    context.beamToNamed('/$LOCATION_ITEM/:${item.itemKey}');
                  },
                  child: SizedBox(
                    height: imgSize,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: imgSize,
                              width: imgSize,
                              child:((){
                                switch (item.category) {
                                  case 'chicken':
                                    return ExtendedImage.asset(
                                      'assets/images/chicken_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'pizza':
                                    return ExtendedImage.asset(
                                      'assets/images/pizza_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'burger':
                                    return ExtendedImage.asset(
                                      'assets/images/burger_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'chinese':
                                    return ExtendedImage.asset(
                                      'assets/images/chinese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'korean':
                                    return ExtendedImage.asset(
                                      'assets/images/korean_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'japanese':
                                    return ExtendedImage.asset(
                                      'assets/images/japanese_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  case 'cafe/dessert':
                                    return ExtendedImage.asset(
                                      'assets/images/cafe_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.circle,
                                    );
                                  default:
                                    return ExtendedImage.asset(
                                      'assets/images/food_icon.png',
                                      fit: BoxFit.cover,
                                      shape: BoxShape.rectangle,
                                    );
                                }
                              })(),
                            ),
                            SizedBox(height: 15),
                            Text("${item.participants} 명 참여중", style: Theme.of(context).textTheme.subtitle1),
                          ],
                        ),
                        SizedBox(width: common_bg_padding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(Icons.food_bank),
                                  Text("  "),
                                  Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(CupertinoIcons.money_dollar_circle_fill),
                                  Text("  "),
                                  Text('${item.price.toString()}원'
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.timer),
                                  Text("  "),
                                  item.closed
                                      ? Text("모집마감", style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w100),
                                  )
                                      : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.place),
                                  Text("  "),
                                  Flexible(
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: TextSpan(
                                            text: item.itemAddress1,
                                            style: Theme.of(context).textTheme.bodyText2
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
            else {
              return Container(
                padding: EdgeInsets.all(common_sm_padding),
                height: 160.0,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 0,
                        blurRadius: 5.0,
                        offset: Offset(0, 10),
                      ),
                    ]
                ),
                child: SizedBox(
                  height: imgSize,
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: imgSize,
                            width: imgSize,
                            child:((){
                              switch (item.category) {
                                case 'chicken':
                                  return ExtendedImage.asset(
                                    'assets/images/chicken_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'pizza':
                                  return ExtendedImage.asset(
                                    'assets/images/pizza_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'burger':
                                  return ExtendedImage.asset(
                                    'assets/images/burger_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'chinese':
                                  return ExtendedImage.asset(
                                    'assets/images/chinese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'korean':
                                  return ExtendedImage.asset(
                                    'assets/images/korean_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'japanese':
                                  return ExtendedImage.asset(
                                    'assets/images/japanese_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                case 'cafe/dessert':
                                  return ExtendedImage.asset(
                                    'assets/images/cafe_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.circle,
                                  );
                                default:
                                  return ExtendedImage.asset(
                                    'assets/images/food_icon.png',
                                    fit: BoxFit.cover,
                                    shape: BoxShape.rectangle,
                                  );
                              }
                            })(),
                          ),
                          SizedBox(height: 15),
                          Text(categoriesMapEngToKor[item.category] ?? "선택", style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                      SizedBox(width: common_bg_padding),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.food_bank),
                                Text("  "),
                                Text(item.title, style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(CupertinoIcons.money_dollar_circle_fill),
                                Text("  "),
                                Text('${item.price.toString()}원'
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.timer),
                                Text("  "),
                                item.closed
                                    ? Text("모집마감", style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w100),
                                )
                                    : Text(item.time, style: Theme.of(context).textTheme.bodyText2)
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.place),
                                Text("  "),
                                Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      text: TextSpan(
                                          text: item.itemAddress1,
                                          style: Theme.of(context).textTheme.bodyText2
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          },
          itemCount: cafe.length),
    );
  }

  Widget _shimmerListView(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView1(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onChickenRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView2(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onPizzaRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView3(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onBurgerRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView4(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onChineseRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView5(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onKoreanRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView6(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onJapaneseRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
  Widget _shimmerListView7(double imgSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: RefreshIndicator(
        onRefresh: _onCafeRefresh,
        child: ListView.separated(
            padding: EdgeInsets.all(common_bg_padding),
            separatorBuilder: (context, index){
              return Divider(
                height: common_sm_padding * 3,  //높이
                thickness: 1,  // 구분선
                color: Colors.grey[200],  // 구분석 색
                indent: common_sm_padding,  // 좌측 구분선 패딩
                endIndent: common_sm_padding,  // 우측 구분선 패딩
              );
            },
            itemBuilder: (context, index){
              return SizedBox(
                height: imgSize,
                child: Row(
                  children: [
                    Container(
                      height: imgSize,
                      width: imgSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    SizedBox(width: common_bg_padding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            width: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 20,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          Expanded(child: Container(),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 16,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: 50),
      ),
    );
  }
}