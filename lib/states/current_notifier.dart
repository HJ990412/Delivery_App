import 'package:app_3/data/current_model.dart';
import 'package:app_3/data/currentroom_model.dart';
import 'package:app_3/repo/current_service.dart';
import 'package:app_3/repo/item_service.dart';
import 'package:flutter/foundation.dart';

class CurrentNotifier extends ChangeNotifier{
  CurrentroomModel? _currentroomModel;
  List<CurrentModel> _currentList = [];
  final String _currentroomKey;


  CurrentNotifier(this._currentroomKey) {
    CurrentService().connectCurrentroom(_currentroomKey).listen((currentroomModel) {
      this._currentroomModel = currentroomModel;

      if (this._currentList.isEmpty) {
        CurrentService().getCurrentList(_currentroomKey).then((currentList) {
          _currentList.addAll(currentList);
          notifyListeners();
        });
      } else {
        if (this._currentList[0].reference == null) this._currentList.removeAt(0);
        CurrentService()
            .getLatestCurrents(_currentroomKey, this._currentList[0].reference!)
            .then((lateCurrents) {
          this._currentList.insertAll(0, lateCurrents);
          notifyListeners();
        });
      }
    });
  }

  void updateNewStat1() {
    currentroomModel == null
        ? 0
        :currentroomModel?.currentDeliverStat = 0;
    notifyListeners();

    CurrentService().updateNewStat(_currentroomKey, currentroomModel);
  }

  void updateNewStat2() {
    currentroomModel == null
        ? 0
        :currentroomModel?.currentDeliverStat = 1;
    notifyListeners();
    CurrentService().updateNewStat(_currentroomKey, currentroomModel);
  }

  void updateNewStat3() {
    currentroomModel == null
        ? 0
        :currentroomModel?.currentDeliverStat = 2;
    notifyListeners();

    CurrentService().updateNewStat(_currentroomKey, currentroomModel);
  }
  void refreshNewStat() {
    currentroomModel == null
        ? 0
        :currentroomModel?.currentDeliverTime++;
    notifyListeners();
    CurrentService().refreshNewStat(_currentroomKey, currentroomModel);
  }

  void refreshNewDeposit(CurrentModel currentModel) {
    currentModel.depositCheck =  currentModel.depositCheck;
    notifyListeners();

    CurrentService().updateNewDeposit(currentModel.currentKey,_currentroomKey, currentModel);
  }

  void updateClosed() {
    currentroomModel!.currentClosed = currentroomModel!.currentClosed;
    notifyListeners();

    CurrentService().updateNewClosed(_currentroomKey, currentroomModel!);
  }

  List<CurrentModel> get currentList => _currentList;

  CurrentroomModel? get currentroomModel => _currentroomModel;

  String get currentroomKey => _currentroomKey;
}