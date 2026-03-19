import 'package:coding_challenge/data/feed_list_changes.dart';
import 'package:coding_challenge/data/models/feed_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TeaserModel item(int id) => TeaserModel(id: id, url: 'https://example.com/$id');

  group('FeedListChanges.between', () {
    test('detects added items', () {
      final oldItems = [item(1), item(2)];
      final newItems = [item(1), item(2), item(3)];

      final changes = FeedListChanges.between(oldItems: oldItems, newItems: newItems);

      expect(changes.added, containsAll([3]));
      expect(changes.removed, isEmpty);
    });

    test('detects removed items', () {
      final oldItems = [item(1), item(2), item(3)];
      final newItems = [item(1), item(3)];

      final changes = FeedListChanges.between(oldItems: oldItems, newItems: newItems);

      expect(changes.removed, containsAll([2]));
      expect(changes.added, isEmpty);
    });

    test('detects both added and removed items', () {
      final oldItems = [item(1), item(2)];
      final newItems = [item(2), item(3)];

      final changes = FeedListChanges.between(oldItems: oldItems, newItems: newItems);

      expect(changes.added, containsAll([3]));
      expect(changes.removed, containsAll([1]));
    });

    test('returns no changes when lists are identical', () {
      final items = [item(1), item(2)];

      final changes = FeedListChanges.between(oldItems: items, newItems: items);

      expect(changes.isEmpty, isTrue);
    });

    test('detects all items added when old list is empty', () {
      final changes = FeedListChanges.between(
        oldItems: [],
        newItems: [item(1), item(2)],
      );

      expect(changes.added, containsAll([1, 2]));
      expect(changes.removed, isEmpty);
    });

    test('detects all items removed when new list is empty', () {
      final changes = FeedListChanges.between(
        oldItems: [item(1), item(2)],
        newItems: [],
      );

      expect(changes.removed, containsAll([1, 2]));
      expect(changes.added, isEmpty);
    });

    test('isEmpty is true when both lists are empty', () {
      final changes = FeedListChanges.between(oldItems: [], newItems: []);

      expect(changes.isEmpty, isTrue);
    });

    test('isEmpty is false when there are changes', () {
      final changes = FeedListChanges.between(
        oldItems: [item(1)],
        newItems: [item(2)],
      );

      expect(changes.isEmpty, isFalse);
    });
  });
}
