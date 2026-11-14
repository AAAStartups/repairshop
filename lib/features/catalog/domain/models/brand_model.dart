class BrandModel {
  final String id;
  final String name;
  final String logoEmoji;
  final bool isPopular;

  const BrandModel({
    required this.id,
    required this.name,
    required this.logoEmoji,
    this.isPopular = false,
  });
}

final List<BrandModel> mockBrands = [
  BrandModel(id: 'apple', name: 'Apple', logoEmoji: '🍎', isPopular: true),
  BrandModel(id: 'samsung', name: 'Samsung', logoEmoji: '📱', isPopular: true),
  BrandModel(id: 'oneplus', name: 'OnePlus', logoEmoji: '🔴', isPopular: true),
  BrandModel(id: 'xiaomi', name: 'Xiaomi', logoEmoji: '⬛', isPopular: true),
  BrandModel(id: 'redmi', name: 'Redmi', logoEmoji: '🔷', isPopular: false),
  BrandModel(id: 'vivo', name: 'Vivo', logoEmoji: '💙', isPopular: false),
  BrandModel(id: 'oppo', name: 'Oppo', logoEmoji: '💚', isPopular: false),
  BrandModel(id: 'realme', name: 'Realme', logoEmoji: '⚡', isPopular: false),
  BrandModel(id: 'motorola', name: 'Motorola', logoEmoji: '🌀', isPopular: false),
  BrandModel(id: 'pixel', name: 'Google Pixel', logoEmoji: '🌈', isPopular: true),
  BrandModel(id: 'nothing', name: 'Nothing', logoEmoji: '⚪', isPopular: false),
  BrandModel(id: 'other', name: 'Other', logoEmoji: '📲', isPopular: false),
];
