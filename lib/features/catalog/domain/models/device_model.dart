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

final Map<String, List<DeviceModel>> mockDevicesByBrand = {
  'apple': [
    DeviceModel(id: 'iphone17promax', brandId: 'apple', name: 'iPhone 17 Pro Max', series: 'iPhone 17', releaseYear: 2025),
    DeviceModel(id: 'iphone17pro', brandId: 'apple', name: 'iPhone 17 Pro', series: 'iPhone 17', releaseYear: 2025),
    DeviceModel(id: 'iphone17', brandId: 'apple', name: 'iPhone 17', series: 'iPhone 17', releaseYear: 2025),
    DeviceModel(id: 'iphone16promax', brandId: 'apple', name: 'iPhone 16 Pro Max', series: 'iPhone 16', releaseYear: 2024),
    DeviceModel(id: 'iphone16pro', brandId: 'apple', name: 'iPhone 16 Pro', series: 'iPhone 16', releaseYear: 2024),
    DeviceModel(id: 'iphone16', brandId: 'apple', name: 'iPhone 16', series: 'iPhone 16', releaseYear: 2024),
    DeviceModel(id: 'iphone16plus', brandId: 'apple', name: 'iPhone 16 Plus', series: 'iPhone 16', releaseYear: 2024),
    DeviceModel(id: 'iphone15promax', brandId: 'apple', name: 'iPhone 15 Pro Max', series: 'iPhone 15', releaseYear: 2023),
    DeviceModel(id: 'iphone15pro', brandId: 'apple', name: 'iPhone 15 Pro', series: 'iPhone 15', releaseYear: 2023),
    DeviceModel(id: 'iphone15', brandId: 'apple', name: 'iPhone 15', series: 'iPhone 15', releaseYear: 2023),
    DeviceModel(id: 'iphone14promax', brandId: 'apple', name: 'iPhone 14 Pro Max', series: 'iPhone 14', releaseYear: 2022),
    DeviceModel(id: 'iphone14pro', brandId: 'apple', name: 'iPhone 14 Pro', series: 'iPhone 14', releaseYear: 2022),
    DeviceModel(id: 'iphone14', brandId: 'apple', name: 'iPhone 14', series: 'iPhone 14', releaseYear: 2022),
    DeviceModel(id: 'iphone13', brandId: 'apple', name: 'iPhone 13', series: 'iPhone 13', releaseYear: 2021),
    DeviceModel(id: 'iphone13promax', brandId: 'apple', name: 'iPhone 13 Pro Max', series: 'iPhone 13', releaseYear: 2021),
  ],
  'samsung': [
    DeviceModel(id: 's25ultra', brandId: 'samsung', name: 'Galaxy S25 Ultra', series: 'Galaxy S25', releaseYear: 2025),
    DeviceModel(id: 's25plus', brandId: 'samsung', name: 'Galaxy S25+', series: 'Galaxy S25', releaseYear: 2025),
    DeviceModel(id: 's25', brandId: 'samsung', name: 'Galaxy S25', series: 'Galaxy S25', releaseYear: 2025),
    DeviceModel(id: 's24ultra', brandId: 'samsung', name: 'Galaxy S24 Ultra', series: 'Galaxy S24', releaseYear: 2024),
    DeviceModel(id: 's24plus', brandId: 'samsung', name: 'Galaxy S24+', series: 'Galaxy S24', releaseYear: 2024),
    DeviceModel(id: 's24', brandId: 'samsung', name: 'Galaxy S24', series: 'Galaxy S24', releaseYear: 2024),
    DeviceModel(id: 'a55', brandId: 'samsung', name: 'Galaxy A55 5G', series: 'Galaxy A', releaseYear: 2024),
    DeviceModel(id: 'a35', brandId: 'samsung', name: 'Galaxy A35 5G', series: 'Galaxy A', releaseYear: 2024),
    DeviceModel(id: 'a15', brandId: 'samsung', name: 'Galaxy A15', series: 'Galaxy A', releaseYear: 2024),
  ],
  'oneplus': [
    DeviceModel(id: 'op13', brandId: 'oneplus', name: 'OnePlus 13', series: 'OnePlus 13', releaseYear: 2025),
    DeviceModel(id: 'op12', brandId: 'oneplus', name: 'OnePlus 12', series: 'OnePlus 12', releaseYear: 2024),
    DeviceModel(id: 'op12r', brandId: 'oneplus', name: 'OnePlus 12R', series: 'OnePlus 12', releaseYear: 2024),
    DeviceModel(id: 'op11', brandId: 'oneplus', name: 'OnePlus 11', series: 'OnePlus 11', releaseYear: 2023),
    DeviceModel(id: 'opnord4', brandId: 'oneplus', name: 'Nord 4', series: 'Nord', releaseYear: 2024),
    DeviceModel(id: 'opnord3', brandId: 'oneplus', name: 'Nord 3', series: 'Nord', releaseYear: 2023),
  ],
  'xiaomi': [
    DeviceModel(id: 'mi14ultra', brandId: 'xiaomi', name: 'Xiaomi 14 Ultra', series: 'Xiaomi 14', releaseYear: 2024),
    DeviceModel(id: 'mi14', brandId: 'xiaomi', name: 'Xiaomi 14', series: 'Xiaomi 14', releaseYear: 2024),
    DeviceModel(id: 'mi13', brandId: 'xiaomi', name: 'Xiaomi 13', series: 'Xiaomi 13', releaseYear: 2023),
  ],
  'pixel': [
    DeviceModel(id: 'pixel9proXL', brandId: 'pixel', name: 'Pixel 9 Pro XL', series: 'Pixel 9', releaseYear: 2024),
    DeviceModel(id: 'pixel9pro', brandId: 'pixel', name: 'Pixel 9 Pro', series: 'Pixel 9', releaseYear: 2024),
    DeviceModel(id: 'pixel9', brandId: 'pixel', name: 'Pixel 9', series: 'Pixel 9', releaseYear: 2024),
    DeviceModel(id: 'pixel8pro', brandId: 'pixel', name: 'Pixel 8 Pro', series: 'Pixel 8', releaseYear: 2023),
    DeviceModel(id: 'pixel8', brandId: 'pixel', name: 'Pixel 8', series: 'Pixel 8', releaseYear: 2023),
  ],
};
