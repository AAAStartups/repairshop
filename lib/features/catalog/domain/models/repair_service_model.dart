import 'package:flutter/material.dart';

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
  final String? imageUrl;

  const RepairServiceModel({
    required this.id,
    required this.name,
    required this.description,
    this.iconEmoji = '',
    this.estimatedPrice,
    this.isPriceOnInspection = false,
    this.estimatedTime,
    this.warrantyPeriod,
    this.category,
    this.badge,
    this.mrp,
    this.discount,
    this.deviceName,
    this.imageUrl,
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

  /// High-resolution natural workshop photograph asset for this service
  String get imageAsset {
    final cat = (category ?? '').toUpperCase();
    final n = name.toLowerCase();
    if (cat.contains('SCREEN') || n.contains('screen') || n.contains('display')) {
      return 'assets/images/repairs/screen_repair.jpg';
    }
    if (cat.contains('BATTERY') || n.contains('battery')) {
      return 'assets/images/repairs/battery_repair.jpg';
    }
    if (cat.contains('CHARGING') || n.contains('charging') || n.contains('port')) {
      return 'assets/images/repairs/charging_port.jpg';
    }
    if (cat.contains('WATER') || n.contains('liquid') || n.contains('water')) {
      return 'assets/images/repairs/water_damage.jpg';
    }
    if (cat.contains('CAMERA') || n.contains('camera') || n.contains('lens')) {
      return 'assets/images/repairs/camera_repair.jpg';
    }
    if (cat.contains('BACK_GLASS') || n.contains('back') || n.contains('glass')) {
      return 'assets/images/repairs/back_glass.jpg';
    }
    if (cat.contains('MOTHERBOARD') || n.contains('board') || n.contains('ic') || n.contains('chip')) {
      return 'assets/images/repairs/motherboard_repair.jpg';
    }
    return 'assets/images/repairs/diagnostics.jpg';
  }

  /// Cloudinary / Supabase public CDN URL for this repair photograph
  String get cdnImageUrl {
    final cat = (category ?? '').toUpperCase();
    final n = name.toLowerCase();
    const baseUrl = 'https://alenvqljzoobubcpsuxa.supabase.co/storage/v1/object/public/device-photos';
    if (cat.contains('SCREEN') || n.contains('screen') || n.contains('display')) {
      return '$baseUrl/repairs_screen_repair.jpg';
    }
    if (cat.contains('BATTERY') || n.contains('battery')) {
      return '$baseUrl/repairs_battery_repair.jpg';
    }
    if (cat.contains('CHARGING') || n.contains('charging') || n.contains('port')) {
      return '$baseUrl/repairs_charging_port.jpg';
    }
    if (cat.contains('WATER') || n.contains('liquid') || n.contains('water')) {
      return '$baseUrl/repairs_water_damage.jpg';
    }
    if (cat.contains('CAMERA') || n.contains('camera') || n.contains('lens')) {
      return '$baseUrl/repairs_camera_repair.jpg';
    }
    if (cat.contains('BACK_GLASS') || n.contains('back') || n.contains('glass')) {
      return '$baseUrl/repairs_back_glass.jpg';
    }
    if (cat.contains('MOTHERBOARD') || n.contains('board') || n.contains('ic') || n.contains('chip')) {
      return '$baseUrl/repairs_motherboard_repair.jpg';
    }
    return '$baseUrl/repairs_diagnostics.jpg';
  }

  /// Crisp Material IconData for compact UI or error fallback
  IconData get iconData {
    final cat = (category ?? '').toUpperCase();
    final n = name.toLowerCase();
    if (cat.contains('SCREEN') || n.contains('screen') || n.contains('display')) {
      return Icons.smartphone_rounded;
    }
    if (cat.contains('BATTERY') || n.contains('battery')) {
      return Icons.battery_charging_full_rounded;
    }
    if (cat.contains('CHARGING') || n.contains('charging') || n.contains('port')) {
      return Icons.power_rounded;
    }
    if (cat.contains('WATER') || n.contains('liquid') || n.contains('water')) {
      return Icons.water_drop_rounded;
    }
    if (cat.contains('CAMERA') || n.contains('camera') || n.contains('lens')) {
      return Icons.photo_camera_rounded;
    }
    if (cat.contains('BACK_GLASS') || n.contains('back') || n.contains('glass')) {
      return Icons.flip_to_back_rounded;
    }
    if (cat.contains('MOTHERBOARD') || n.contains('board') || n.contains('ic')) {
      return Icons.memory_rounded;
    }
    return Icons.build_rounded;
  }
}
