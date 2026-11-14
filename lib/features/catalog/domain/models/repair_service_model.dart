class RepairServiceModel {
  final String id;
  final String name;
  final String description;
  final String iconEmoji;
  final double? estimatedPrice;
  final bool isPriceOnInspection;
  final String? estimatedTime;
  final String? warrantyPeriod;

  const RepairServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconEmoji,
    this.estimatedPrice,
    this.isPriceOnInspection = false,
    this.estimatedTime,
    this.warrantyPeriod,
  });

  String get priceDisplay {
    if (isPriceOnInspection) return 'Price on Inspection';
    if (estimatedPrice != null) return '₹${estimatedPrice!.toInt()}';
    return 'Price on Inspection';
  }
}

final List<RepairServiceModel> mockRepairServices = [
  RepairServiceModel(
    id: 'screen_replacement',
    name: 'Screen Replacement',
    description: 'Cracked or broken display, touch issues',
    iconEmoji: '📱',
    estimatedPrice: 2499,
    estimatedTime: '2-3 hours',
    warrantyPeriod: '6 months',
  ),
  RepairServiceModel(
    id: 'battery_replacement',
    name: 'Battery Replacement',
    description: 'Fast drain, swollen battery, not charging',
    iconEmoji: '🔋',
    estimatedPrice: 999,
    estimatedTime: '1-2 hours',
    warrantyPeriod: '6 months',
  ),
  RepairServiceModel(
    id: 'back_glass',
    name: 'Back Glass Replacement',
    description: 'Cracked back panel or frame damage',
    iconEmoji: '🪟',
    estimatedPrice: 1499,
    estimatedTime: '2-3 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'charging_port',
    name: 'Charging Port Repair',
    description: 'Not charging, loose connector, slow charge',
    iconEmoji: '🔌',
    estimatedPrice: 799,
    estimatedTime: '1-2 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'camera_repair',
    name: 'Camera Repair',
    description: 'Blurry photos, camera not opening, lens damage',
    iconEmoji: '📷',
    isPriceOnInspection: true,
    estimatedTime: '2-4 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'speaker_repair',
    name: 'Speaker Repair',
    description: 'No sound, muffled audio, earpiece issues',
    iconEmoji: '🔊',
    estimatedPrice: 699,
    estimatedTime: '1-2 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'mic_repair',
    name: 'Microphone Repair',
    description: 'Caller cannot hear you, mic not working',
    iconEmoji: '🎤',
    estimatedPrice: 599,
    estimatedTime: '1-2 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'water_damage',
    name: 'Water Damage Repair',
    description: 'Device fell in water, liquid damage',
    iconEmoji: '💧',
    isPriceOnInspection: true,
    estimatedTime: '24-48 hours',
  ),
  RepairServiceModel(
    id: 'software',
    name: 'Software Troubleshooting',
    description: 'Slow performance, app crashes, virus removal',
    iconEmoji: '⚙️',
    estimatedPrice: 499,
    estimatedTime: '1-3 hours',
  ),
  RepairServiceModel(
    id: 'power_button',
    name: 'Power Button Repair',
    description: 'Volume or power button not working',
    iconEmoji: '🔘',
    estimatedPrice: 599,
    estimatedTime: '1-2 hours',
    warrantyPeriod: '3 months',
  ),
  RepairServiceModel(
    id: 'other',
    name: 'Other Issues',
    description: 'Describe your issue and we will diagnose',
    iconEmoji: '🔧',
    isPriceOnInspection: true,
  ),
];
