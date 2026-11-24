class BrandModel {
  final String id;
  final String name;
  final String? subtitle;
  final String? logoAsset;
  final String logoEmoji;
  final bool isPopular;

  const BrandModel({
    required this.id,
    required this.name,
    this.subtitle,
    this.logoAsset,
    this.logoEmoji = '',
    this.isPopular = false,
  });

  /// Canonical local image asset path (defaults to assets/brands/<id>.png)
  String get assetPath => logoAsset ?? 'assets/brands/$id.png';
}
