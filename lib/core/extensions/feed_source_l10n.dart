import 'package:coding_challenge/core/constants.dart';
import 'package:coding_challenge/l10n/app_localizations.dart';

/// Provides a localized display label for each [FeedSource] value.
extension FeedSourceL10n on FeedSource {
  String label(AppLocalizations l10n) => switch (this) {
        FeedSource.source1 => l10n.feed_source_1,
        FeedSource.source2 => l10n.feed_source_2,
      };
}
