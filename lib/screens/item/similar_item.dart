import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app_3/data/item_model.dart';
import 'package:app_3/screens/item/item_detail_screen.dart';

class SimilarItem extends StatelessWidget {
  final ItemModel _itemModel;
  const SimilarItem(this._itemModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ItemDetailScreen(_itemModel.itemKey);
        }));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 9 / 8,
            child: ExtendedImage.network('assets/images/food_icon.png',
                fit: BoxFit.cover,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8)),
          ),
          SizedBox(height: 7),
          Text(
            _itemModel.title,
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 7),
          Text('${_itemModel.price.toString()}원',
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}