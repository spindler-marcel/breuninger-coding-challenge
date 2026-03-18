import 'package:coding_challenge/core/failures/app_failure.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';

class AppFailureMapper {
  static String map(AppFailure failure, AppLocalizations l10n) {
    return switch (failure) {
      ConnectionFailure() => l10n.failure_connection,
      ServerFailure() => l10n.failure_server,
      TimeoutFailure() => l10n.failure_timeout,
      ParseFailure() => l10n.failure_parse,
      UnknownFailure() => l10n.failure_unknown,
    };
  }
}
