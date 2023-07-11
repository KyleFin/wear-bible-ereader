import 'dart:async';
import 'dart:developer';

import 'package:bookshelf_repository/bookshelf_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wear_os_connectivity/flutter_wear_os_connectivity.dart';
import 'package:wear_os_bible_ereader/counter/counter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await runZonedGuarded(
    () async {
      // Add cross-flavor configuration here
      final flutterWearOsConnectivity = FlutterWearOsConnectivity();
      // WidgetsFlutterBinding.ensureInitialized();
      // await flutterWearOsConnectivity.configureWearableAPI();

      runApp(
        BlocProvider(
          create: (_) => PositionCubit(
            FlutterWearOsConnectivityBookshelfRepository(
              flutterWearOsConnectivity,
            ),
          ),
          child: await builder(),
        ),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
