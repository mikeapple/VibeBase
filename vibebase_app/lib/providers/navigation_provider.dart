import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current tab index provider
final currentTabProvider = StateProvider<int>((ref) => 0);

/// Tab names for easy reference
enum AppTab {
  home,
  profile,
  settings,
}
