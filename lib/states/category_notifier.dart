import 'package:flutter/material.dart';
import 'package:app_3/utils/logger.dart';

CategoryNotifier categoryNotifier = CategoryNotifier();

class CategoryNotifier extends ChangeNotifier {
  String _selectedCategoryInEng = 'none';

  String get currentCategoryInEng => _selectedCategoryInEng;
  String get currentCategoryInKor {
    logger.d("currentCategoryInKor called!!!!");
    return categoriesMapEngToKor[_selectedCategoryInEng]!;
  }

  void setNewCategoryWithEng(String newCategory) {
    if (categoriesMapEngToKor.keys.contains(newCategory)) {
      _selectedCategoryInEng = newCategory;
      notifyListeners();
    }
  }

  void setNewCategoryWithKor(String newCategory) {
    if (categoriesMapEngToKor.values.contains(newCategory)) {
      _selectedCategoryInEng = categoriesMapKorToEng[newCategory]!;
      notifyListeners();
    }
  }
}

const Map<String, String> categoriesMapEngToKor = {
  'none':'선택',
  'korean':'한식',
  'chinese':'중식',
  'chicken':'치킨',
  'burger':'버거',
  'pizza':'피자',
  'japanese':'일식',
  'cafe/dessert':'카페/디저트',
};

Map<String, String> categoriesMapKorToEng = {
  '선택':'none',
  '한식':'korean',
  '중식':'chinese',
  '치킨':'chicken',
  '버거':'burger',
  '피자':'pizza',
  '일식':'japanese',
  '카페/디저트':'cafe/dessert',
};
