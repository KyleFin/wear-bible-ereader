import 'package:flutter/widgets.dart';
import 'package:wear_os_bible_ereader/l10n/arb/app_localizations.dart';

export 'package:wear_os_bible_ereader/l10n/arb/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
