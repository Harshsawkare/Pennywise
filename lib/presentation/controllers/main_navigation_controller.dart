import 'package:get/get.dart';

/// Main navigation controller managing tab navigation state
/// Handles the active tab index for bottom navigation bar
class MainNavigationController extends GetxController {
  // Observable state for current tab index
  final RxInt currentIndex = 0.obs;

  /// Changes the active tab
  /// [index] - The index of the tab to navigate to (0-3)
  void changeTab(int index) {
    if (index >= 0 && index <= 3) {
      currentIndex.value = index;
    }
  }

  /// Gets the current tab index
  int get currentTabIndex => currentIndex.value;
}

