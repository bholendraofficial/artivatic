import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/data_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  DataModel? dataModel;
  bool isLoading = true;

  loadData() async {
    Uri uri = Uri.parse(
        "https://run.mocky.io/v3/c4ab4c1c-9a55-4174-9ed2-cbbe0738eedf");
    Response response = await Dio().getUri(uri);
    if (kDebugMode) {
      print(response);
    }
    if (response.statusCode == 200) {
      dataModel = DataModel.fromJson(response.data);
    } else {
      dataModel = null; // clear data
    }
    isLoading = false;
    notifyListeners(); // notify to builder
  }

  void reloadData() {
    // reloading restful api
    isLoading = true;
    notifyListeners();
    loadData();
  }
}
