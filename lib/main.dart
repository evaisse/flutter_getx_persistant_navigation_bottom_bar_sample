import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    defaultTransition: Transition.fade,
    getPages: [
      GetPage(
        name: '/home',
        page: () => const HomePage(),
      ),
      GetPage(
        name: '/another',
        page: () => const AnotherPage(),
        binding: AnotherPageBindings(),
      ),
    ],
    initialBinding: AppBindings(),
  ));
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ItemProvider>(() => ItemProvider());

    // controllers
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BrowseController>(() => BrowseController());
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<ItemDetailController>(() => ItemDetailController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}

class Item {
  String id;
  String name;
  String description;
  Uri? imageUrl;

  Item(this.id, this.name, this.description, this.imageUrl);

  factory Item.fromJson(dynamic e) {
    var i = e['drinks'] as Map<String, dynamic>;
    return Item(i['idDrink'], i['strDrink'], i['strI'], i['strDrinkThumb'] ? Uri.parse(i['strDrinkThumb']) : null);
  }
}

class ItemProvider extends GetConnect {
  Future<List<Item>> fetchSome() async {
    var res = await get('https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a');
    return (jsonDecode(res.bodyString ?? '{}') as List).map((e) => Item.fromJson(e)).toList();
  }

  Future<Item> fetchOne(String id) async {
    var res = await get('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id');
    return Item.fromJson(jsonDecode(res.bodyString ?? '{}') as Map);
  }
}

class BarService extends GetxService {}

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final pages = <String>['/browse', '/history', '/settings'];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index], id: 1);
  }

  Route onGenerateRoute(RouteSettings settings) {
    if (settings.name == '/history') {
      return GetPageRoute(
        settings: settings,
        page: () => const HistoryPage(),
      );
    }

    if (settings.name == '/settings') {
      return GetPageRoute(
        settings: settings,
        page: () => const SettingsPage(),
      );
    }

    return GetPageRoute(
      settings: settings,
      page: () => const BrowsePage(),
    );
  }
}

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '/browse',
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: controller.currentIndex.value,
          selectedItemColor: Colors.pink,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}

class BrowsePage extends GetView<BrowseController> {
  const BrowsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(title: title),
      body: Center(
        child: Container(
          child: title,
        ),
      ),
    );
  }
}

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(title: title),
      body: Center(
        child: Container(
          child: title,
        ),
      ),
    );
  }
}

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Text(controller.title.value),
            ),
            ElevatedButton(
              child: const Text('Another Page'),
              onPressed: () => Get.toNamed('/another'),
            ),
          ],
        ),
      ),
    );
  }
}

class BrowseController extends GetxController {
  final title = 'Browser'.obs;
}

class HistoryController extends GetxController {
  final title = 'History'.obs;
}

class SettingsController extends GetxController {
  final title = 'Settings'.obs;
}

class ItemDetailController extends GetxController {
  final title = 'detail'.obs;
}

class ItemDetailPage extends GetView<ItemDetailController> {
  const ItemDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(title: title),
      body: Center(
        child: Container(
          child: title,
        ),
      ),
    );
  }
}

class AnotherPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnotherPageController>(() => AnotherPageController());
  }
}

class AnotherPageController extends GetxController {
  final counter = 0.obs;

  @override
  void onInit() {
    counter.value = counter.value + 1;
  }
}

class AnotherPage extends GetView<AnotherPageController> {
  const AnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Another Page')), body: Container());
  }
}
