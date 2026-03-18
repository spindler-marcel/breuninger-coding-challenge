import 'package:coding_challenge/core/gender_filter.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';

extension GenderFilterL10n on GenderFilter {
  String label(AppLocalizations l10n) => switch (this) {
        GenderFilter.all => l10n.feed_filter_all,
        GenderFilter.male => l10n.feed_filter_male,
        GenderFilter.female => l10n.feed_filter_female,
      };
}
