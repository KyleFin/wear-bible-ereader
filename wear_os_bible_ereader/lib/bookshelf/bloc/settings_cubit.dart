import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> toggleAppBarIsVisible() async {
    emit(
      SettingsState(
        appBarIsVisible: !state.appBarIsVisible,
        rotation: state.rotation,
        horizontalPadding: state.horizontalPadding,
      ),
    );
  }

  Future<void> setRotation(double rotation) async {
    emit(
      SettingsState(
        appBarIsVisible: state.appBarIsVisible,
        rotation: rotation,
        horizontalPadding: state.horizontalPadding,
      ),
    );
  }

  Future<void> incrementHorizontalPadding() async =>
      _setHorizontalPadding(state.horizontalPadding + 1);

  Future<void> decrementHorizontalPadding() async =>
      _setHorizontalPadding(state.horizontalPadding - 1);

  Future<void> _setHorizontalPadding(double width) async {
    emit(
      SettingsState(
        appBarIsVisible: state.appBarIsVisible,
        rotation: state.rotation,
        horizontalPadding: width.clamp(0, 30),
      ),
    );
  }
}
