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
    this.logoEmoji = '📱',
    this.isPopular = false,
  });

  /// Canonical local image asset path (defaults to assets/brands/<id>.png)
  String get assetPath => logoAsset ?? 'assets/brands/$id.png';
}

final List<BrandModel> mockBrands = [
  BrandModel(
    id: 'apple',
    name: 'Apple',
    logoAsset: 'assets/brands/apple.png',
    logoEmoji: '🍎',
    isPopular: true,
  ),
  BrandModel(
    id: 'samsung',
    name: 'Samsung',
    logoAsset: 'assets/brands/samsung.png',
    logoEmoji: '📱',
    isPopular: true,
  ),
  BrandModel(
    id: 'xiaomi',
    name: 'Xiaomi',
    subtitle: 'Redmi / Mi',
    logoAsset: 'assets/brands/xiaomi.png',
    logoEmoji: '⬛',
    isPopular: true,
  ),
  BrandModel(
    id: 'oneplus',
    name: 'OnePlus',
    logoAsset: 'assets/brands/oneplus.png',
    logoEmoji: '🔴',
    isPopular: true,
  ),
  BrandModel(
    id: 'pixel',
    name: 'Google Pixel',
    logoAsset: 'assets/brands/pixel.png',
    logoEmoji: '🌈',
    isPopular: true,
  ),
  BrandModel(
    id: 'vivo',
    name: 'Vivo',
    logoAsset: 'assets/brands/vivo.png',
    logoEmoji: '💙',
    isPopular: false,
  ),
  BrandModel(
    id: 'oppo',
    name: 'Oppo',
    logoAsset: 'assets/brands/oppo.png',
    logoEmoji: '💚',
    isPopular: false,
  ),
  BrandModel(
    id: 'realme',
    name: 'Realme',
    logoAsset: 'assets/brands/realme.png',
    logoEmoji: '⚡',
    isPopular: false,
  ),
  BrandModel(
    id: 'motorola',
    name: 'Motorola',
    logoAsset: 'assets/brands/motorola.png',
    logoEmoji: '🌀',
    isPopular: false,
  ),
  BrandModel(
    id: 'nothing',
    name: 'Nothing',
    logoAsset: 'assets/brands/nothing.png',
    logoEmoji: '⚪',
    isPopular: false,
  ),
  BrandModel(
    id: 'huawei',
    name: 'Huawei',
    logoAsset: 'assets/brands/huawei.png',
    logoEmoji: '🔴',
    isPopular: false,
  ),
  BrandModel(
    id: 'nokia',
    name: 'Nokia',
    logoAsset: 'assets/brands/nokia.png',
    logoEmoji: '🔷',
    isPopular: false,
  ),
  BrandModel(
    id: 'other',
    name: 'Other Brands',
    logoAsset: 'assets/brands/other.png',
    logoEmoji: '📲',
    isPopular: false,
  ),
];
