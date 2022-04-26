import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class AnotherScreen extends GetView<AnotherPageController> {
  static var route = GetPage(
    name: '/another',
    page: () => const AnotherScreen(),
    binding: AnotherPageBindings(),
  );

  const AnotherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Another Page')), body: Container());
  }
}
