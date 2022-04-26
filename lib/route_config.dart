import 'package:get/get.dart';

import 'navigator_mixin.dart';

class RouteConfig {
  final GetPageBuilder builder;
  final NavigationControllerMixin Function()? navigatorController;

  RouteConfig({required this.builder, this.navigatorController});
}
