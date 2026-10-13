enum PartyType { customer, supplier }

class PartyModel {
  final String id;
  final String name;
  final String? phone;
  final PartyType type;
  final double balance; // positive = to collect, negative = to pay
  final String? gstNumber;
  final String? panNumber;
  final String? billingAddress;
  final String? category;
  final DateTime createdAt;

  PartyModel({
    required this.id,
    required this.name,
    this.phone,
    this.type = PartyType.customer,
    this.balance = 0.0,
    this.gstNumber,
    this.panNumber,
    this.billingAddress,
    this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PartyModel copyWith({
    String? id,
    String? name,
    String? phone,
    PartyType? type,
    double? balance,
    String? gstNumber,
    String? panNumber,
    String? billingAddress,
    String? category,
    DateTime? createdAt,
  }) {
    return PartyModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      billingAddress: billingAddress ?? this.billingAddress,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
