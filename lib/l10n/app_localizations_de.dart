// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get feed_title => 'Feed';

  @override
  String get feed_source_1 => 'Quelle 1';

  @override
  String get feed_source_2 => 'Quelle 2';

  @override
  String get feed_filter_all => 'Alle';

  @override
  String get feed_filter_male => 'Männlich';

  @override
  String get feed_filter_female => 'Weiblich';

  @override
  String get feed_error_retry => 'Erneut versuchen';

  @override
  String get failure_connection =>
      'Keine Internetverbindung. Bitte überprüfe deine Verbindung und versuche es erneut.';

  @override
  String get failure_server =>
      'Bei uns ist etwas schiefgelaufen. Bitte versuche es später erneut.';

  @override
  String get failure_timeout =>
      'Die Anfrage hat zu lange gedauert. Bitte versuche es erneut.';

  @override
  String get failure_parse =>
      'Die Inhalte konnten nicht geladen werden. Bitte versuche es später erneut.';

  @override
  String get failure_unknown =>
      'Ein unerwarteter Fehler ist aufgetreten. Bitte versuche es später erneut.';
}
