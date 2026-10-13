import 'package:flutter/material.dart';
import '../models/party_model.dart';
import '../models/item_model.dart';
import '../models/transaction_model.dart';
import '../models/business_model.dart';

class MyBillBookState extends ChangeNotifier {
  // Businesses
  final List<BusinessModel> _businesses = [
    BusinessModel(
      id: 'biz-1',
      name: 'Business Name',
      gstin: '24AAACC1206D1ZM',
      phone: '9198011787',
      address: 'Shop 14, Commercial Complex, Sector 18',
      initial: 'B',
      isDefault: true,
    ),
    BusinessModel(
      id: 'biz-2',
      name: 'Gupta Enterprises',
      gstin: '07AAAAA0000A1Z5',
      phone: '9876543210',
      address: 'Main Market, Karol Bagh, Delhi',
      initial: 'G',
      isDefault: false,
    ),
  ];
  late String _activeBusinessId;

  // Parties
  final List<PartyModel> _parties = [
    PartyModel(
      id: 'p-cash',
      name: 'Cash Sale',
      phone: '',
      type: PartyType.customer,
      balance: 0.0,
      category: 'Customer',
    ),
    PartyModel(
      id: 'p-1',
      name: 'Ankit Mishra',
      phone: '9876543210',
      type: PartyType.customer,
      balance: 14500.0,
      gstNumber: '24AAACC1206D1ZM',
      panNumber: 'AAACC1206D',
      billingAddress: 'B-12, Sector 62, Noida, UP',
      category: 'Customer',
    ),
    PartyModel(
      id: 'p-2',
      name: 'Gupta Garments',
      phone: '9812345678',
      type: PartyType.customer,
      balance: 9060.0,
      gstNumber: '07AAECG1234F1Z2',
      billingAddress: 'Chandni Chowk, Delhi',
      category: 'Customer',
    ),
    PartyModel(
      id: 'p-3',
      name: 'Sharma Wholesalers',
      phone: '9845123654',
      type: PartyType.supplier,
      balance: -7500.0, // To Pay
      gstNumber: '09AAICS9876K1Z9',
      billingAddress: 'G.T. Road, Ghaziabad',
      category: 'Supplier',
    ),
  ];

  // Items
  final List<ItemModel> _items = [
    ItemModel(
      id: 'item-1',
      name: 'Sample Item',
      hsn: '8471',
      type: ItemType.product,
      salesPrice: 220.0,
      purchasePrice: 190.0,
      stockQuantity: 124.0,
      unit: 'BOX',
      gstRate: 'None',
      discountPercent: 0.0,
      inventoryTracking: 'IMEI/Serial No',
    ),
    ItemModel(
      id: 'item-2',
      name: 'Kissan Fruit Jam 500 gm',
      hsn: '2007',
      type: ItemType.product,
      salesPrice: 130.0,
      purchasePrice: 115.0,
      stockQuantity: 45.0,
      unit: 'PCS',
      gstRate: '12%',
      discountPercent: 10.0,
      inventoryTracking: 'Standard',
    ),
    ItemModel(
      id: 'item-3',
      name: 'Fortune Kachi Ghani 1L',
      hsn: '1514',
      type: ItemType.product,
      salesPrice: 175.0,
      purchasePrice: 155.0,
      stockQuantity: 60.0,
      unit: 'PCS',
      gstRate: '5%',
      discountPercent: 5.0,
      inventoryTracking: 'Standard',
    ),
    ItemModel(
      id: 'item-4',
      name: 'Ashirvaad Atta 5kg',
      hsn: '1101',
      type: ItemType.product,
      salesPrice: 240.0,
      purchasePrice: 210.0,
      stockQuantity: 30.0,
      unit: 'BAG',
      gstRate: 'None',
      discountPercent: 0.0,
      inventoryTracking: 'Standard',
    ),
  ];

  // Transactions
  final List<TransactionModel> _transactions = [
    TransactionModel(
      id: 'tx-1',
      invoiceNumber: 'Sales Invoice #1',
      type: TransactionType.salesInvoice,
      partyId: 'p-1',
      partyName: 'Ankit Mishra',
      amount: 14500.0,
      date: DateTime.now().subtract(const Duration(hours: 3)),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      paymentMode: 'Credit',
      note: 'Order dispatched via courier',
      items: [
        InvoiceItemLine(
          itemId: 'item-1',
          itemName: 'Sample Item',
          quantity: 50,
          unitPrice: 220,
          unit: 'BOX',
        ),
        InvoiceItemLine(
          itemId: 'item-2',
          itemName: 'Kissan Fruit Jam 500 gm',
          quantity: 25,
          unitPrice: 130,
          unit: 'PCS',
        ),
      ],
      isPaid: false,
    ),
    TransactionModel(
      id: 'tx-2',
      invoiceNumber: 'Received Payment #1',
      type: TransactionType.paymentIn,
      partyId: 'p-2',
      partyName: 'Gupta Garments',
      amount: 4200.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentMode: 'Cash',
      note: 'Part payment received in store',
      isPaid: true,
    ),
  ];

  // Filters & State Variables
  String _partyFilter = 'All'; // All, To Pay, To Collect
  String _partySort = 'A-Z'; // A-Z, Z-A, High-Low, Low-High
  String _partySearchQuery = '';

  String _itemCategoryFilter = 'All'; // All, Products, Services
  String _itemSearchQuery = '';

  int _selectedNavIndex = 0;

  MyBillBookState() {
    _activeBusinessId = _businesses.first.id;
  }

  // Getters
  int get selectedNavIndex => _selectedNavIndex;
  List<BusinessModel> get businesses => List.unmodifiable(_businesses);
  BusinessModel get activeBusiness =>
      _businesses.firstWhere((b) => b.id == _activeBusinessId, orElse: () => _businesses.first);

  List<PartyModel> get parties => List.unmodifiable(_parties);
  List<ItemModel> get items => List.unmodifiable(_items);
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  String get partyFilter => _partyFilter;
  String get partySort => _partySort;
  String get partySearchQuery => _partySearchQuery;
  String get itemCategoryFilter => _itemCategoryFilter;
  String get itemSearchQuery => _itemSearchQuery;

  // Computed Financial Metrics
  double get toCollect {
    return _parties
        .where((p) => p.balance > 0)
        .fold(0.0, (sum, p) => sum + p.balance);
  }

  double get toPay {
    return _parties
        .where((p) => p.balance < 0)
        .fold(0.0, (sum, p) => sum + p.balance.abs());
  }

  double get totalStockValue {
    return _items.fold(0.0, (sum, i) => sum + i.stockValue);
  }

  double get thisWeekSales {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _transactions
        .where((t) => t.type == TransactionType.salesInvoice && t.date.isAfter(weekStart))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalCashBankBalance {
    // Net cash collected
    return 23560.0;
  }

  // Navigation
  void setNavIndex(int index) {
    _selectedNavIndex = index;
    notifyListeners();
  }

  // Business Switcher
  void switchBusiness(String id) {
    _activeBusinessId = id;
    notifyListeners();
  }

  void addBusiness(String name, String? gstin, String? phone) {
    final newBiz = BusinessModel(
      id: 'biz-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      gstin: gstin,
      phone: phone,
      initial: name.isNotEmpty ? name[0].toUpperCase() : 'B',
    );
    _businesses.add(newBiz);
    _activeBusinessId = newBiz.id;
    notifyListeners();
  }

  // Party Methods
  void setPartyFilter(String filter) {
    _partyFilter = filter;
    notifyListeners();
  }

  void setPartySort(String sort) {
    _partySort = sort;
    notifyListeners();
  }

  void setPartySearchQuery(String query) {
    _partySearchQuery = query;
    notifyListeners();
  }

  List<PartyModel> get filteredParties {
    var list = _parties.where((p) {
      if (_partyFilter == 'To Collect' && p.balance <= 0) return false;
      if (_partyFilter == 'To Pay' && p.balance >= 0) return false;
      if (_partySearchQuery.isNotEmpty) {
        final q = _partySearchQuery.toLowerCase();
        final matchName = p.name.toLowerCase().contains(q);
        final matchPhone = (p.phone ?? '').contains(q);
        return matchName || matchPhone;
      }
      return true;
    }).toList();

    if (_partySort == 'A-Z') {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_partySort == 'Z-A') {
      list.sort((a, b) => b.name.compareTo(a.name));
    } else if (_partySort == 'High-Low') {
      list.sort((a, b) => b.balance.compareTo(a.balance));
    } else if (_partySort == 'Low-High') {
      list.sort((a, b) => a.balance.compareTo(b.balance));
    }
    return list;
  }

  void addParty(PartyModel party) {
    _parties.add(party);
    notifyListeners();
  }

  // Item Methods
  void setItemCategoryFilter(String category) {
    _itemCategoryFilter = category;
    notifyListeners();
  }

  void setItemSearchQuery(String query) {
    _itemSearchQuery = query;
    notifyListeners();
  }

  List<ItemModel> get filteredItems {
    return _items.where((i) {
      if (_itemCategoryFilter == 'Products' && i.type != ItemType.product) return false;
      if (_itemCategoryFilter == 'Services' && i.type != ItemType.service) return false;
      if (_itemSearchQuery.isNotEmpty) {
        final q = _itemSearchQuery.toLowerCase();
        return i.name.toLowerCase().contains(q) || (i.hsn ?? '').contains(q);
      }
      return true;
    }).toList();
  }

  void addItem(ItemModel item) {
    _items.add(item);
    notifyListeners();
  }

  void updateItemStock(String itemId, double newQuantity) {
    final idx = _items.indexWhere((i) => i.id == itemId);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(stockQuantity: newQuantity);
      notifyListeners();
    }
  }

  // Invoices & Payments
  void addInvoice(TransactionModel tx) {
    _transactions.insert(0, tx);
    // Update Party balance
    final partyIdx = _parties.indexWhere((p) => p.id == tx.partyId);
    if (partyIdx != -1) {
      _parties[partyIdx] = _parties[partyIdx].copyWith(
        balance: _parties[partyIdx].balance + tx.amount,
      );
    }
    // Deduct stock for items
    for (final line in tx.items) {
      final itemIdx = _items.indexWhere((i) => i.id == line.itemId);
      if (itemIdx != -1) {
        final currentStock = _items[itemIdx].stockQuantity;
        _items[itemIdx] = _items[itemIdx].copyWith(
          stockQuantity: (currentStock - line.quantity).clamp(0, double.infinity),
        );
      }
    }
    notifyListeners();
  }

  void addPaymentIn(TransactionModel tx) {
    _transactions.insert(0, tx);
    // Deduct from Party receivable balance
    final partyIdx = _parties.indexWhere((p) => p.id == tx.partyId);
    if (partyIdx != -1) {
      _parties[partyIdx] = _parties[partyIdx].copyWith(
        balance: _parties[partyIdx].balance - tx.amount,
      );
    }
    notifyListeners();
  }
}

class MyBillBookScope extends InheritedWidget {
  final MyBillBookState state;

  const MyBillBookScope({
    super.key,
    required this.state,
    required super.child,
  });

  static MyBillBookState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<MyBillBookScope>();
    assert(scope != null, 'No MyBillBookScope found in context');
    return scope!.state;
  }

  @override
  bool updateShouldNotify(covariant MyBillBookScope oldWidget) => true;
}
