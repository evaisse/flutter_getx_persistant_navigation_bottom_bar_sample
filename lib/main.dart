import 'package:darty_json/darty_json.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: HomePage.route.name,
    defaultTransition: Transition.fade,
    getPages: [
      HomePage.route,
      AnotherPage.route,
    ],
    initialBinding: AppBindings(),
  ));
}

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

class Cocktail {
  String id;
  String name;
  String description;
  Uri? imageUrl;

  Cocktail(this.id, this.name, this.description, this.imageUrl);

  factory Cocktail.fromJson(Json json) {
    return Cocktail(
      json['idDrink'].stringValue,
      json['strDrink'].stringValue,
      json['strInstructions'].stringValue,
      json['strDrinkThumb'].booleanValue ? Uri.parse(json['strDrinkThumb'].stringValue) : null,
    );
  }
}

class CocktailDbProvider extends GetConnect {
  Future<Json> fetch(String url) async {
    var res = await get(url);
    if (res.statusCode != 200) throw 'Api error, response ${res.statusCode} ${res.bodyString}';
    return Json.fromString(res.bodyString ?? '{}');
  }

  Future<List<Cocktail>> fetchSome() async {
    var res = await fetch('https://www.thecocktaildb.com/api/json/v1/1/search.php?f=a');
    return res['drinks'].listValue.map((e) => Cocktail.fromJson(e)).toList();
  }

  Future<Cocktail> fetchOne(String id) async {
    var res = await fetch('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id');
    return Cocktail.fromJson(res);
  }
}

class BarService extends GetxService {}

class HomeController extends GetxController {
  var currentIndex = 0.obs;

  final pages = <GetPage>[
    BrowsePage.route,
    HistoryPage.route,
    ProfilePage.route,
  ];

  void changePage(int index) {
    currentIndex.value = index;
    Get.toNamed(pages[index].name, id: 1);
  }

  Route onGenerateRoute(RouteSettings settings) {
    var routeName = settings.name;
    var searchPages = [HomePage.route, ItemDetailPage.route];
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

class BrowseController extends GetxController with StateMixin<List<Cocktail>> {
  final title = 'Browser'.obs;

  @override
  void onInit() async {
    super.onInit();
    change(null, status: RxStatus.loading());
    try {
      var items = await Get.find<CocktailDbProvider>().fetchSome();
      change(items, status: items.isNotEmpty ? RxStatus.success() : RxStatus.empty());
    } catch (e) {
      change(null, status: RxStatus.error("$e"));
    }
  }
}

class BrowsePage extends GetView<BrowseController> {
  static final route = GetPage(name: '/browse', page: () => const BrowsePage());

  const BrowsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(title: title),
      body: controller.obx(
        (state) => buildListView(context, state!),
        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        // onLoading: CustomLoadingIndicator(),
        onEmpty: Text('No data found'),
        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        // onError: (error)=>Text(error),
      ),
    );
  }

  buildListView(BuildContext context, List<Cocktail> state) {
    return ListView.builder(
      itemCount: state.length,
      itemBuilder: (context, index) {
        var item = state[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text(item.id),
          onTap: () {
            Get.toNamed(ItemDetailPage.route.name, id: 1);
          },
        );
      },
    );
  }
}

class HistoryController extends GetxController {
  final title = 'History'.obs;
}

class HistoryPage extends GetView<HistoryController> {
  static final route = GetPage(name: '/history', page: () => const HistoryPage());

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

class ProfileController extends GetxController {
  final title = 'Profile'.obs;
}

class ProfilePage extends GetView<ProfileController> {
  static var route = GetPage(name: '/settings', page: () => const ProfilePage());

  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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

class ItemDetailController extends GetxController {
  final title = 'detail'.obs;
}

class ItemDetailPage extends GetView<ItemDetailController> {
  static final route = GetPage(name: '/browse/cocktails/:id', page: () => ItemDetailPage());

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
    super.onInit();
    counter.value = counter.value + 1;
  }
}

class AnotherPage extends GetView<AnotherPageController> {
  static var route = GetPage(
    name: '/another',
    page: () => const AnotherPage(),
    binding: AnotherPageBindings(),
  );

  const AnotherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Another Page')), body: Container());
  }
}
