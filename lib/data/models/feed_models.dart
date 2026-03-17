import 'package:coding_challenge/core/exceptions.dart';
import 'package:equatable/equatable.dart';

sealed class FeedItem {
  const FeedItem();

  int get id;

  static FeedItem? fromJson(Map<String, dynamic> json) {
    try {
      return switch (json['type'] as String?) {
        'teaser' => TeaserModel.fromJson(json),
        'slider' => SliderModel.fromJson(json),
        'brand_slider' => BrandSliderModel.fromJson(json),
        _ => null,
      };
    } catch (_) {
      return null;
    }
  }
}

class TeaserModel extends FeedItem with EquatableMixin {
  @override
  final int id;
  final String url;
  final String? gender;
  final DateTime? expiresAt;
  final String? headline;
  final String? imageUrl;

  TeaserModel({
    required this.id,
    required this.url,
    this.gender,
    this.expiresAt,
    this.headline,
    this.imageUrl,
  });

  factory TeaserModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>;
    final url = attrs['url'] as String?;
    if (url == null) {
      throw const ParseException('Teaser is missing required field: url');
    }

    return TeaserModel(
      id: json['id'] as int,
      url: url,
      gender: json['gender'] as String?,
      expiresAt: DateTime.tryParse(json['expires_at'] as String? ?? ''),
      headline: attrs['headline'] as String?,
      imageUrl: attrs['image_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, gender, expiresAt, headline, imageUrl, url];
}

class SliderModel extends FeedItem with EquatableMixin {
  @override
  final int id;
  final List<SliderSubItemModel> subItems;

  SliderModel({required this.id, required this.subItems});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>;
    final rawItems = attrs['items'] as List<dynamic>;
    final subItems = rawItems
        .map((e) => SliderSubItemModel.fromJson(e as Map<String, dynamic>))
        .nonNulls
        .toList();

    return SliderModel(id: json['id'] as int, subItems: subItems);
  }

  @override
  List<Object?> get props => [id, subItems];
}

class BrandSliderModel extends FeedItem with EquatableMixin {
  @override
  final int id;
  final String itemsUrl;
  final List<SliderSubItemModel>? subItems; // null = still loading

  BrandSliderModel({required this.id, required this.itemsUrl, this.subItems});

  factory BrandSliderModel.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>;
    return BrandSliderModel(
      id: json['id'] as int,
      itemsUrl: attrs['items_url'] as String,
    );
  }

  BrandSliderModel copyWithSubItems(List<SliderSubItemModel> subItems) {
    return BrandSliderModel(id: id, itemsUrl: itemsUrl, subItems: subItems);
  }

  @override
  List<Object?> get props => [id, itemsUrl, subItems];
}

class SliderSubItemModel with EquatableMixin {
  final int id;
  final String url;
  final String? gender;
  final DateTime? expiresAt;
  final String? headline;
  final String? imageUrl;

  SliderSubItemModel({
    required this.id,
    required this.url,
    this.gender,
    this.expiresAt,
    this.headline,
    this.imageUrl,
  });

  static SliderSubItemModel? fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String?;
    if (url == null) return null;

    return SliderSubItemModel(
      id: json['id'] as int,
      url: url,
      gender: json['gender'] as String?,
      expiresAt: DateTime.tryParse(json['expires_at'] as String? ?? ''),
      headline: json['headline'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, gender, expiresAt, headline, imageUrl, url];
}
