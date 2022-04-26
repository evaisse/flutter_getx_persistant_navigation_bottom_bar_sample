import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final title = 'Profile'.obs;
}

class ProfileScreen extends GetView<ProfileController> {
  static var route = GetPage(name: '/profile', page: () => const ProfileScreen());

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
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
