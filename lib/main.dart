import 'package:darty_json/darty_json.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/browse_screen.dart';
import 'screens/history_screen.dart';
import 'screens/item_details_creen.dart';
import 'screens/profile_screen.dart';
import 'services/cocktaildb_provider.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CocktailDbProvider>(() => CocktailDbProvider());

    // controllers
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BrowseController>(() => BrowseController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<ItemDetailController>(() => ItemDetailController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: HomePage.route.name,
    defaultTransition: Transition.fade,
    getPages: [
      HomePage.route,
      AnotherScreen.route,
    ],
    initialBinding: AppBindings(),
  ));
}
