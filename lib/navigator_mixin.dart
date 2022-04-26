import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A mixin a controller can use to provide a sub-navigation to the screen
/// It's main goal is to move the routing logic to the controller
mixin NavigationControllerMixin {
  // Avoid using the same sub navigation key in more than one places
  static int _nextSubNavigationKey = 0;

  /// A getter that provides the next unique sub navigation key to use
  static int get nextSubNavigationKey => _nextSubNavigationKey++;

  /// The sub-navigation key
  final int navKey = nextSubNavigationKey;

  /// Initial route
  String? getInitialRoute();

  /// Routing callback which provides a route for a given [RouteSettings]
  /// This is where you do the actual routing of the hosted sub-navigation
  Route<dynamic>? onGenerateRoute(RouteSettings routeSettings);

  /// Routing callback called when [onGenerateRoute] did not provide a route
  Route<dynamic>? onUnknownRoute(RouteSettings routeSettings);

  List<NavigatorObserver> getObservers() => [];

  /// Navigator widget to insert in the screen
  Widget getNavigator() => Navigator(
        key: Get.nestedKey(navKey),
        initialRoute: getInitialRoute(),
        onGenerateRoute: onGenerateRoute,
        onUnknownRoute: onUnknownRoute,
        observers: getObservers(),
      );
}
