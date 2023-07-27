import 'package:app_3/states/category_notifier.dart';
import 'package:app_3/utils/time_calculation.dart';
import 'package:beamer/beamer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_3/constants/common_size.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/router/locations.dart';

class ItemListWidget extends StatelessWidget {
  final ItemModel item;
  double? imgSize;
  ItemListWidget(this.item, {Key? key, this.imgSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imgSize == null) {
      Size size = MediaQuery.of(context).size;
      imgSize = size.width / 4;
    }

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
        onTap: () {
          BeamState beamState = Beamer.of(context).currentConfiguration!;
          String currentPath = beamState.uri.toString();
          String newPath = (currentPath == '/')
              ? '/$LOCATION_ITEM/${item.itemKey}'
              : '$currentPath/${item.itemKey}';

          context.beamToNamed(newPath);
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
                    child: ExtendedImage.asset(
                      'assets/images/food_icon.png',
                      fit: BoxFit.cover,
                      shape: BoxShape.circle,
                    ),
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
                                  text: item.itemAddress2,
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
}