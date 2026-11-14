class BookingDraft {
  final String? brandId;
  final String? brandName;
  final String? modelId;
  final String? modelName;
  final List<String> selectedServiceIds;
  final List<String> selectedServiceNames;
  final double estimatedCost;
  final String? problemDescription;
  final List<String> issuePhotoPaths;
  final String? flatNo;
  final String? streetAddress;
  final String? landmark;
  final String? city;
  final String? pincode;
  final String? contactPhone;
  final String? addressType;
  final DateTime? pickupDate;
  final String? pickupTimeSlot;

  const BookingDraft({
    this.brandId,
    this.brandName,
    this.modelId,
    this.modelName,
    this.selectedServiceIds = const [],
    this.selectedServiceNames = const [],
    this.estimatedCost = 0.0,
    this.problemDescription,
    this.issuePhotoPaths = const [],
    this.flatNo,
    this.streetAddress,
    this.landmark,
    this.city,
    this.pincode,
    this.contactPhone,
    this.addressType = 'Home',
    this.pickupDate,
    this.pickupTimeSlot,
  });

  BookingDraft copyWith({
    String? brandId,
    String? brandName,
    String? modelId,
    String? modelName,
    List<String>? selectedServiceIds,
    List<String>? selectedServiceNames,
    double? estimatedCost,
    String? problemDescription,
    List<String>? issuePhotoPaths,
    String? flatNo,
    String? streetAddress,
    String? landmark,
    String? city,
    String? pincode,
    String? contactPhone,
    String? addressType,
    DateTime? pickupDate,
    String? pickupTimeSlot,
  }) {
    return BookingDraft(
      brandId: brandId ?? this.brandId,
      brandName: brandName ?? this.brandName,
      modelId: modelId ?? this.modelId,
      modelName: modelName ?? this.modelName,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      selectedServiceNames: selectedServiceNames ?? this.selectedServiceNames,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      problemDescription: problemDescription ?? this.problemDescription,
      issuePhotoPaths: issuePhotoPaths ?? this.issuePhotoPaths,
      flatNo: flatNo ?? this.flatNo,
      streetAddress: streetAddress ?? this.streetAddress,
      landmark: landmark ?? this.landmark,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      contactPhone: contactPhone ?? this.contactPhone,
      addressType: addressType ?? this.addressType,
      pickupDate: pickupDate ?? this.pickupDate,
      pickupTimeSlot: pickupTimeSlot ?? this.pickupTimeSlot,
    );
  }

  String get fullAddress {
    final parts = [flatNo, streetAddress, landmark, city, pincode]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  bool get isComplete =>
      brandId != null &&
      modelId != null &&
      selectedServiceIds.isNotEmpty &&
      streetAddress != null &&
      streetAddress!.isNotEmpty &&
      contactPhone != null &&
      contactPhone!.isNotEmpty &&
      pickupDate != null &&
      pickupTimeSlot != null;
}
