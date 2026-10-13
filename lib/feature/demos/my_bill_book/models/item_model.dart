enum ItemType { product, service }

class ItemModel {
  final String id;
  final String name;
  final String? hsn;
  final ItemType type;
  final double salesPrice;
  final double purchasePrice;
  final double stockQuantity;
  final String unit; // PCS, BOX, KG, etc.
  final String gstRate; // None, 5%, 12%, 18%, 28%
  final double discountPercent;
  final String inventoryTracking; // IMEI/Serial No, Batch, Standard
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.name,
    this.hsn,
    this.type = ItemType.product,
    required this.salesPrice,
    required this.purchasePrice,
    this.stockQuantity = 0.0,
    this.unit = 'PCS',
    this.gstRate = 'None',
    this.discountPercent = 0.0,
    this.inventoryTracking = 'IMEI/Serial No',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get stockValue => stockQuantity * purchasePrice;

  ItemModel copyWith({
    String? id,
    String? name,
    String? hsn,
    ItemType? type,
    double? salesPrice,
    double? purchasePrice,
    double? stockQuantity,
    String? unit,
    String? gstRate,
    double? discountPercent,
    String? inventoryTracking,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      hsn: hsn ?? this.hsn,
      type: type ?? this.type,
      salesPrice: salesPrice ?? this.salesPrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      gstRate: gstRate ?? this.gstRate,
      discountPercent: discountPercent ?? this.discountPercent,
      inventoryTracking: inventoryTracking ?? this.inventoryTracking,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
