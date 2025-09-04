part of 'settings_cubit.dart';

@immutable
class SettingsState {
  const SettingsState({
    this.appBarIsVisible = false,
    this.rotation = 0,
    this.horizontalPadding = 24,
  });

  final bool appBarIsVisible;
  final double rotation;
  final double horizontalPadding;
}
