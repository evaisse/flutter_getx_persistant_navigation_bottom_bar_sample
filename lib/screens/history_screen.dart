import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final title = 'History'.obs;
}

class HistoryScreen extends GetView<HistoryController> {
  static final page = GetPage(name: '/history', page: () => const HistoryScreen());

  const HistoryScreen({Key? key}) : super(key: key);

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
