import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  Future<void> toggleAppBarIsVisible() async {
    emit(SettingsState(appBarIsVisible: !state.appBarIsVisible));
  }
}
