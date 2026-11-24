class DeviceModel {
  final String id;
  final String brandId;
  final String name;
  final String? series;
  final String? imageUrl;
  final int? releaseYear;

  const DeviceModel({
    required this.id,
    required this.brandId,
    required this.name,
    this.series,
    this.imageUrl,
    this.releaseYear,
  });
}
