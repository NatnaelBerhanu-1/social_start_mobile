import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:social_start/utils/constants.dart';

class ThemeViewModel extends ChangeNotifier {
  var hiveBox = Hive.lazyBox(kAppCacheDBName);
  bool nightMode = false;

  setNightMode(bool nightMode){
    hiveBox.put("night_mode", nightMode);
    this.nightMode = nightMode;
    notifyListeners();
  }

  getNightMode() async {
   nightMode = await hiveBox.get("night_mode", defaultValue: false);
   notifyListeners();
  }

}