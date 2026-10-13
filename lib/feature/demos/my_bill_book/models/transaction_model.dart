enum TransactionType { salesInvoice, paymentIn, purchaseInvoice, paymentOut }

class InvoiceItemLine {
  final String itemId;
  final String itemName;
  final double quantity;
  final double unitPrice;
  final String unit;
  final double taxPercent;

  InvoiceItemLine({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
    this.unit = 'PCS',
    this.taxPercent = 0.0,
  });

  double get subtotal => quantity * unitPrice;
  double get taxAmount => subtotal * (taxPercent / 100);
  double get total => subtotal + taxAmount;
}

class TransactionModel {
  final String id;
  final String invoiceNumber;
  final TransactionType type;
  final String partyId;
  final String partyName;
  final double amount;
  final DateTime date;
  final DateTime? dueDate;
  final String paymentMode; // Cash, Bank, UPI, Cheque
  final String? note;
  final List<InvoiceItemLine> items;
  final bool isPaid;

  TransactionModel({
    required this.id,
    required this.invoiceNumber,
    required this.type,
    required this.partyId,
    required this.partyName,
    required this.amount,
    required this.date,
    this.dueDate,
    this.paymentMode = 'Cash',
    this.note,
    this.items = const [],
    this.isPaid = false,
  });
}
