// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get feed_title => 'Feed';

  @override
  String get feed_source_1 => 'Source 1';

  @override
  String get feed_source_2 => 'Source 2';

  @override
  String get feed_filter_all => 'All';

  @override
  String get feed_filter_male => 'Male';

  @override
  String get feed_filter_female => 'Female';

  @override
  String get feed_error_retry => 'Retry';

  @override
  String get failure_connection =>
      'No internet connection. Please check your connection and try again.';

  @override
  String get failure_server =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get failure_timeout => 'The connection timed out. Please try again.';

  @override
  String get failure_parse =>
      'We couldn\'t load the content. Please try again later.';

  @override
  String get failure_unknown =>
      'An unexpected error occurred. Please try again later.';
}
