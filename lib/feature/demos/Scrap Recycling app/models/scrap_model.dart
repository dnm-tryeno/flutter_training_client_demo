import 'package:flutter/material.dart';

/// User Role: Customer (Household / Retail), Vendor (Bulk Commercial / Godown),
/// Rider (Pickup Agent), or Admin Panel
enum UserRole {
  customer,
  vendor,
  rider,
  admin,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Customer (Retail)';
      case UserRole.vendor:
        return 'Vendor (Bulk / Godown)';
      case UserRole.rider:
        return 'Pickup Agent (Rider)';
      case UserRole.admin:
        return 'Admin Panel';
    }
  }

  String get shortName {
    switch (this) {
      case UserRole.customer:
        return 'Customer';
      case UserRole.vendor:
        return 'Vendor';
      case UserRole.rider:
        return 'Rider';
      case UserRole.admin:
        return 'Admin';
    }
  }
}

/// Scrap Category grouping exactly matching reference app
enum ScrapCategoryType {
  paper,
  plastic,
  metal,
  eWaste,
  rubber,
  others,
}

extension ScrapCategoryTypeExtension on ScrapCategoryType {
  String get title {
    switch (this) {
      case ScrapCategoryType.paper:
        return 'Paper';
      case ScrapCategoryType.plastic:
        return 'Plastic';
      case ScrapCategoryType.metal:
        return 'Metal';
      case ScrapCategoryType.eWaste:
        return 'E-Waste';
      case ScrapCategoryType.rubber:
        return 'Rubber';
      case ScrapCategoryType.others:
        return 'Others';
    }
  }

  String get hindiTitle {
    switch (this) {
      case ScrapCategoryType.paper:
        return 'कागज़';
      case ScrapCategoryType.plastic:
        return 'प्लास्टिक';
      case ScrapCategoryType.metal:
        return 'लोहा / धातु';
      case ScrapCategoryType.eWaste:
        return 'ई-कचरा';
      case ScrapCategoryType.rubber:
        return 'रबर / टायर';
      case ScrapCategoryType.others:
        return 'अन्य / बैटरी';
    }
  }

  IconData get icon {
    switch (this) {
      case ScrapCategoryType.paper:
        return Icons.menu_book_rounded;
      case ScrapCategoryType.plastic:
        return Icons.water_drop_rounded;
      case ScrapCategoryType.metal:
        return Icons.hardware_rounded;
      case ScrapCategoryType.eWaste:
        return Icons.devices_other_rounded;
      case ScrapCategoryType.rubber:
        return Icons.album_rounded;
      case ScrapCategoryType.others:
        return Icons.battery_charging_full_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ScrapCategoryType.paper:
        return const Color(0xFFD97706);
      case ScrapCategoryType.plastic:
        return const Color(0xFF0284C7);
      case ScrapCategoryType.metal:
        return const Color(0xFF475569);
      case ScrapCategoryType.eWaste:
        return const Color(0xFF7C3AED);
      case ScrapCategoryType.rubber:
        return const Color(0xFF1E293B);
      case ScrapCategoryType.others:
        return const Color(0xFF059669);
    }
  }

  String get assetPath {
    switch (this) {
      case ScrapCategoryType.paper:
        return 'assets/images/scrap/cat_paper.png';
      case ScrapCategoryType.plastic:
        return 'assets/images/scrap/cat_plastic.png';
      case ScrapCategoryType.metal:
        return 'assets/images/scrap/cat_metal.png';
      case ScrapCategoryType.eWaste:
        return 'assets/images/scrap/cat_ewaste.png';
      case ScrapCategoryType.rubber:
        return 'assets/images/scrap/cat_rubber.png';
      case ScrapCategoryType.others:
        return 'assets/images/scrap/cat_others.png';
    }
  }

  String get imageUrl {
    switch (this) {
      case ScrapCategoryType.paper:
        return 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=400&auto=format&fit=crop&q=80';
      case ScrapCategoryType.plastic:
        return 'https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=400&auto=format&fit=crop&q=80';
      case ScrapCategoryType.metal:
        return 'https://images.unsplash.com/photo-1535813547-99c456a41d4a?w=400&auto=format&fit=crop&q=80';
      case ScrapCategoryType.eWaste:
        return 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400&auto=format&fit=crop&q=80';
      case ScrapCategoryType.rubber:
        return 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?w=400&auto=format&fit=crop&q=80';
      case ScrapCategoryType.others:
        return 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=400&auto=format&fit=crop&q=80';
    }
  }
}

/// Bulk Quantity Slab for Commercial Vendors
class VendorSlab {
  final double minKg;
  final double? maxKg; // null means and above
  final double ratePerKg;

  const VendorSlab({
    required this.minKg,
    this.maxKg,
    required this.ratePerKg,
  });

  String get slabLabel {
    if (maxKg == null) {
      return '${minKg.toInt()}+ kg';
    }
    return '${minKg.toInt()} - ${maxKg!.toInt()} kg';
  }

  bool matches(double kg) {
    if (maxKg == null) {
      return kg >= minKg;
    }
    return kg >= minKg && kg < maxKg!;
  }
}

/// Individual Scrap Material definition
class ScrapMaterial {
  final String id;
  final String name;
  final String hindiName;
  final ScrapCategoryType category;
  final String unit; // 'kg' or 'pc'
  double retailRate; // ₹ per unit (mutable for admin updates)
  final List<VendorSlab> vendorSlabs;
  final String description;
  final IconData icon;
  final Color color;
  final String imageUrl;
  final String? assetPath;

  ScrapMaterial({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.category,
    required this.unit,
    required this.retailRate,
    required this.vendorSlabs,
    required this.description,
    required this.icon,
    required this.color,
    required this.imageUrl,
    this.assetPath,
  });

  String get displayAsset => assetPath ?? category.assetPath;

  /// Get applicable rate for a given quantity & role
  double getRateFor(double qty, UserRole role) {
    if (role == UserRole.vendor) {
      for (final slab in vendorSlabs) {
        if (slab.matches(qty)) {
          return slab.ratePerKg;
        }
      }
      // If below lowest slab, fallback to retail or first slab
      return vendorSlabs.isNotEmpty ? vendorSlabs.first.ratePerKg : retailRate;
    }
    return retailRate;
  }

  VendorSlab? getActiveSlab(double qty) {
    for (final slab in vendorSlabs) {
      if (slab.matches(qty)) return slab;
    }
    return vendorSlabs.isNotEmpty ? vendorSlabs.first : null;
  }
}

/// Item in a pickup request
class PickupItem {
  final ScrapMaterial material;
  double estimatedQty;
  double? actualQty;
  double appliedRate;

  PickupItem({
    required this.material,
    required this.estimatedQty,
    this.actualQty,
    required this.appliedRate,
  });

  double get estimatedTotal => estimatedQty * appliedRate;
  double get actualTotal => (actualQty ?? estimatedQty) * appliedRate;
}

/// Pickup Request Status Lifecycle
enum PickupStatus {
  requested,
  accepted,
  riderAssigned,
  onTheWay,
  reached,
  completed,
  cancelled,
}

extension PickupStatusExtension on PickupStatus {
  String get label {
    switch (this) {
      case PickupStatus.requested:
        return 'Request Placed';
      case PickupStatus.accepted:
        return 'Accepted by Hub';
      case PickupStatus.riderAssigned:
        return 'Agent Assigned';
      case PickupStatus.onTheWay:
        return 'On The Way';
      case PickupStatus.reached:
        return 'Arrived & Weighing';
      case PickupStatus.completed:
        return 'Completed & Paid';
      case PickupStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get hindiLabel {
    switch (this) {
      case PickupStatus.requested:
        return 'रिक्वेस्ट दर्ज';
      case PickupStatus.accepted:
        return 'हब द्वारा स्वीकृत';
      case PickupStatus.riderAssigned:
        return 'एजेंट नियत';
      case PickupStatus.onTheWay:
        return 'रास्ते में है';
      case PickupStatus.reached:
        return 'पहुंच गया - वजन जारी';
      case PickupStatus.completed:
        return 'पूर्ण एवं भुगतान सफल';
      case PickupStatus.cancelled:
        return 'रद्द';
    }
  }

  IconData get icon {
    switch (this) {
      case PickupStatus.requested:
        return Icons.hourglass_top_rounded;
      case PickupStatus.accepted:
        return Icons.task_alt_rounded;
      case PickupStatus.riderAssigned:
        return Icons.person_pin_circle_rounded;
      case PickupStatus.onTheWay:
        return Icons.two_wheeler_rounded;
      case PickupStatus.reached:
        return Icons.scale_rounded;
      case PickupStatus.completed:
        return Icons.check_circle_rounded;
      case PickupStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PickupStatus.requested:
        return const Color(0xFFF59E0B);
      case PickupStatus.accepted:
        return const Color(0xFF3B82F6);
      case PickupStatus.riderAssigned:
        return const Color(0xFF6366F1);
      case PickupStatus.onTheWay:
        return const Color(0xFF0EA5E9);
      case PickupStatus.reached:
        return const Color(0xFF8B5CF6);
      case PickupStatus.completed:
        return const Color(0xFF10B981);
      case PickupStatus.cancelled:
        return const Color(0xFFEF4444);
    }
  }

  int get stepIndex {
    switch (this) {
      case PickupStatus.requested:
        return 0;
      case PickupStatus.accepted:
        return 1;
      case PickupStatus.riderAssigned:
        return 2;
      case PickupStatus.onTheWay:
        return 3;
      case PickupStatus.reached:
        return 4;
      case PickupStatus.completed:
        return 5;
      case PickupStatus.cancelled:
        return -1;
    }
  }
}

/// Address Model
class PickupAddress {
  final String id;
  final String label; // 'Home', 'Godown / Warehouse', 'Office'
  final String fullAddress;
  final String landmark;
  final String pincode;
  final String city;
  final bool isDefault;

  const PickupAddress({
    required this.id,
    required this.label,
    required this.fullAddress,
    required this.landmark,
    required this.pincode,
    required this.city,
    this.isDefault = false,
  });
}

/// Rider Profile Model
class RiderProfile {
  final String id;
  final String name;
  final String phone;
  final double rating;
  final int totalPickups;
  final String vehicleModel;
  final String vehicleNumber;

  const RiderProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.totalPickups,
    required this.vehicleModel,
    required this.vehicleNumber,
  });
}

/// Vendor Profile Model
class VendorProfile {
  final String businessName;
  final String ownerName;
  final String phone;
  final String gstin;
  final String godownAddress;
  final String city;
  final bool isApproved;
  final String tier;

  const VendorProfile({
    required this.businessName,
    required this.ownerName,
    required this.phone,
    required this.gstin,
    required this.godownAddress,
    required this.city,
    required this.isApproved,
    required this.tier,
  });
}

/// Pickup Request (Order) Model
class PickupRequest {
  final String id;
  final UserRole userRole;
  final String userName;
  final String userPhone;
  final PickupAddress address;
  final String slotDate;
  final String slotTime;
  final List<PickupItem> items;
  PickupStatus status;
  RiderProfile? assignedRider;
  final String paymentMethod; // 'Cash on Weighing', 'Instant UPI', 'Bank NEFT'
  String paymentStatus; // 'Pending', 'Paid', 'Settled'
  final String otp;
  final String? notes;
  final int photosAttached;
  final double pickupCharge;
  final String deliveryMode; // 'Doorstep Pickup' or 'Self-Delivery to Hub'
  final DateTime createdAt;
  bool hasDigitalSignature;
  double? finalSettledAmount;
  int? rating;
  String? feedback;

  PickupRequest({
    required this.id,
    required this.userRole,
    required this.userName,
    required this.userPhone,
    required this.address,
    required this.slotDate,
    required this.slotTime,
    required this.items,
    required this.status,
    this.assignedRider,
    required this.paymentMethod,
    this.paymentStatus = 'Pending',
    required this.otp,
    this.notes,
    this.photosAttached = 0,
    this.pickupCharge = 0.0,
    this.deliveryMode = 'Doorstep Pickup',
    required this.createdAt,
    this.hasDigitalSignature = false,
    this.finalSettledAmount,
    this.rating,
    this.feedback,
  });

  double get estimatedTotal {
    double sum = 0;
    for (final item in items) {
      sum += item.estimatedTotal;
    }
    return sum - pickupCharge;
  }

  double get estimatedWeight {
    double sum = 0;
    for (final item in items) {
      if (item.material.unit == 'kg') {
        sum += item.estimatedQty;
      }
    }
    return sum;
  }

  double get actualTotal {
    if (finalSettledAmount != null) return finalSettledAmount!;
    double sum = 0;
    for (final item in items) {
      sum += item.actualTotal;
    }
    return sum - pickupCharge;
  }

  double get actualWeight {
    double sum = 0;
    for (final item in items) {
      if (item.material.unit == 'kg') {
        sum += item.actualQty ?? item.estimatedQty;
      }
    }
    return sum;
  }
}
