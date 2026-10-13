class BusinessModel {
  final String id;
  final String name;
  final String? gstin;
  final String? phone;
  final String? address;
  final String initial;
  final bool isDefault;

  BusinessModel({
    required this.id,
    required this.name,
    this.gstin,
    this.phone,
    this.address,
    required this.initial,
    this.isDefault = false,
  });
}
