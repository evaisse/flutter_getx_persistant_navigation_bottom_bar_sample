import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'browse_screen.dart';
import 'history_screen.dart';
import 'item_details_creen.dart';
import 'profile_screen.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final pages = <GetPage>[
    BrowseScreen.page,
    HistoryScreen.page,
    ProfileScreen.route,
  ];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index].name, id: 1);
  }

  Route onGenerateRoute(RouteSettings settings) {
    var routeName = settings.name;
    var searchPages = [HomePage.route, ItemDetailScreen.route];
    searchPages.addAll(pages);
    routeName = routeName == '/' ? pages.first.name : routeName;
    var p = searchPages.firstWhere((element) => element.name == routeName);

    return GetPageRoute(routeName: p.name, settings: settings, page: p.page);
  }
}

class HomePage extends GetView<HomeController> {
  static var route = GetPage(
    name: '/home',
    page: () => const HomePage(),
  );

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: controller.pages[0].name,
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
              label: 'Profile',
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
