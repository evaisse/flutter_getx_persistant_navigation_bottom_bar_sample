import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/cocktaildb_provider.dart';
import 'item_details_creen.dart';

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

class BrowseScreen extends GetView<BrowseController> {
  static final page = GetPage(name: '/browse', page: () => const BrowseScreen());

  const BrowseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(title: title),
      body: controller.obx(
        (state) => buildListView(context, state!),
        onEmpty: const Text('No data found'),
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
            Get.toNamed(
              ItemDetailScreen.route.name,
              arguments: {"id": item.id},
              id: 1,
            );
          },
        );
      },
    );
  }
}
