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
  'vivo': [
    DeviceModel(id: 'vivox100pro', brandId: 'vivo', name: 'Vivo X100 Pro', series: 'X Series', releaseYear: 2024),
    DeviceModel(id: 'vivox100', brandId: 'vivo', name: 'Vivo X100', series: 'X Series', releaseYear: 2024),
    DeviceModel(id: 'vivov30pro', brandId: 'vivo', name: 'Vivo V30 Pro', series: 'V Series', releaseYear: 2024),
  ],
  'oppo': [
    DeviceModel(id: 'findx7ultra', brandId: 'oppo', name: 'Find X7 Ultra', series: 'Find X Series', releaseYear: 2024),
    DeviceModel(id: 'reno11pro', brandId: 'oppo', name: 'Reno 11 Pro 5G', series: 'Reno Series', releaseYear: 2024),
  ],
  'realme': [
    DeviceModel(id: 'gt5pro', brandId: 'realme', name: 'Realme GT5 Pro', series: 'GT Series', releaseYear: 2024),
    DeviceModel(id: 'realme12proplus', brandId: 'realme', name: 'Realme 12 Pro+ 5G', series: 'Number Series', releaseYear: 2024),
  ],
  'motorola': [
    DeviceModel(id: 'edge50ultra', brandId: 'motorola', name: 'Edge 50 Ultra', series: 'Edge Series', releaseYear: 2024),
    DeviceModel(id: 'razr50ultra', brandId: 'motorola', name: 'Razr 50 Ultra', series: 'Razr Series', releaseYear: 2024),
  ],
  'nothing': [
    DeviceModel(id: 'phone2', brandId: 'nothing', name: 'Nothing Phone (2)', series: 'Phone Series', releaseYear: 2023),
    DeviceModel(id: 'phone2a', brandId: 'nothing', name: 'Nothing Phone (2a)', series: 'Phone Series', releaseYear: 2024),
  ],
  'huawei': [
    DeviceModel(id: 'pura70ultra', brandId: 'huawei', name: 'Pura 70 Ultra', series: 'Pura Series', releaseYear: 2024),
    DeviceModel(id: 'mate60pro', brandId: 'huawei', name: 'Mate 60 Pro', series: 'Mate Series', releaseYear: 2023),
  ],
  'nokia': [
    DeviceModel(id: 'g42', brandId: 'nokia', name: 'Nokia G42 5G', series: 'G Series', releaseYear: 2023),
    DeviceModel(id: 'xr21', brandId: 'nokia', name: 'Nokia XR21 Tough', series: 'XR Series', releaseYear: 2023),
  ],
  'other': [
    DeviceModel(id: 'othergeneric', brandId: 'other', name: 'Other Smartphone Model', series: 'Universal', releaseYear: 2024),
  ],
};
