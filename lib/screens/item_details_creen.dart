import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/cocktaildb_provider.dart';

class ItemDetailController extends GetxController with StateMixin<Cocktail> {
  final title = 'detail'.obs;

  @override
  void onInit() async {
    change(null, status: RxStatus.loading());
    try {
      var params = Get.parameters;
      var res = await Get.find<CocktailDbProvider>().fetchOne(params['id']!);
      change(res, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error("$e"));
    }
  }
}

class ItemDetailScreen extends GetView<ItemDetailController> {
  static final route = GetPage(name: '/browse/cocktails/:id', page: () => ItemDetailScreen());

  const ItemDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = Text(controller.title.value);
    return Scaffold(
      appBar: AppBar(
        title: controller.obx(
          (state) => Text(state?.name ?? ''),
          onEmpty: const Text('...'),
        ),
      ),
      body: Center(
        child: controller.obx(
          (state) => buildDetail(state!),
          onEmpty: const Text('...'),
        ),
      ),
    );
  }

  Widget buildDetail(Cocktail item) {
    return Container(
      child: Row(children: [
        Image.network(item.imageUrl.toString()),
        Text('Cocktail: ${item.description}'),
      ]),
    );
  }
}
