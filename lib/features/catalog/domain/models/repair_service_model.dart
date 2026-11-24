class RepairServiceModel {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final double? estimatedPrice;
  final bool isPriceOnInspection;
  final String? estimatedTime;
  final String? warrantyPeriod;
  final String? category;
  final String? badge;
  final double? mrp;
  final String? discount;
  final String? deviceName;

  const RepairServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    this.estimatedPrice,
    this.isPriceOnInspection = false,
    this.estimatedTime,
    this.warrantyPeriod,
    this.category,
    this.badge,
    this.mrp,
    this.discount,
    this.deviceName,
  });

  String get priceDisplay {
    if (isPriceOnInspection) return 'Price on Inspection';
    if (estimatedPrice != null) return '₹${estimatedPrice!.toInt()}';
    return 'Price on Inspection';
  }

  String? get mrpDisplay {
    if (mrp != null) return '₹${mrp!.toInt()}';
    if (estimatedPrice != null) return '₹${(estimatedPrice! * 1.8).round()}';
    return null;
  }
}
