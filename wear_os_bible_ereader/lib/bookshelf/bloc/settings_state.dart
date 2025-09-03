part of 'settings_cubit.dart';

@immutable
class SettingsState {
  const SettingsState({this.appBarIsVisible = false, this.rotation = 0.0});

  final bool appBarIsVisible;
  final double rotation;
}
