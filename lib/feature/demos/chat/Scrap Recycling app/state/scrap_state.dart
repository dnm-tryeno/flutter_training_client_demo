import 'package:flutter/material.dart';
import '../models/scrap_model.dart';

class ScrapState extends ChangeNotifier {
  // Authentication & Session
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserRole _currentRole = UserRole.customer;
  UserRole get currentRole => _currentRole;

  String _phoneNumber = '9876543210';
  String get phoneNumber => _phoneNumber;

  String _userName = 'Vikram Malhotra';
  String get userName => _userName;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _currentLanguage = 'en'; // 'en' or 'hi'
  String get currentLanguage => _currentLanguage;

  String _currentCity = 'Indiranagar, Bengaluru';
  String get currentCity => _currentCity;

  String _currentPincode = '560001';
  String get currentPincode => _currentPincode;

  // Active Demo Mode (Allows instant role preview anywhere)
  UserRole _previewMode = UserRole.customer;
  UserRole get previewMode => _previewMode;

  // Master Scrap Catalog
  late List<ScrapMaterial> _materials;
  List<ScrapMaterial> get materials => _materials;

  // Saved Addresses
  late List<PickupAddress> _addresses;
  List<PickupAddress> get addresses => _addresses;
  late PickupAddress _selectedAddress;
  PickupAddress get selectedAddress => _selectedAddress;

  // Active Cart / Booking Draft
  final Map<String, double> _cartQuantities = {};
  Map<String, double> get cartQuantities => _cartQuantities;

  String _bookingDate = 'Tomorrow, 25 Sep';
  String get bookingDate => _bookingDate;

  String _bookingSlot = '09:00 AM - 12:00 PM';
  String get bookingSlot => _bookingSlot;

  String _paymentMethod = 'Instant UPI (PhonePe/GPay)';
  String get paymentMethod => _paymentMethod;

  String _deliveryMode = 'Doorstep Pickup';
  String get deliveryMode => _deliveryMode;

  int _attachedPhotosCount = 0;
  int get attachedPhotosCount => _attachedPhotosCount;

  // Orders List
  late List<PickupRequest> _orders;
  List<PickupRequest> get orders => _orders;

  // Active Rider Profiles
  late List<RiderProfile> _riders;
  List<RiderProfile> get riders => _riders;

  // Vendor Profile
  late VendorProfile _vendorProfile;
  VendorProfile get vendorProfile => _vendorProfile;

  ScrapState() {
    _initCatalog();
    _initAddresses();
    _initRiders();
    _initVendorProfile();
    _initMockOrders();
  }

  void _initCatalog() {
    _materials = [
      // Paper & Cardboard
      ScrapMaterial(
        id: 'paper_newspaper',
        assetPath: 'assets/images/scrap/cat_paper.png',
        name: 'Newspaper',
        hindiName: 'रद्दी अख़बार',
        category: ScrapCategoryType.paper,
        unit: 'kg',
        retailRate: 16.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 18.0),
          VendorSlab(minKg: 500, maxKg: 1000, ratePerKg: 20.0),
          VendorSlab(minKg: 1000, maxKg: null, ratePerKg: 22.0),
        ],
        description: 'Daily fresh newspapers, flyers and publications.',
        icon: Icons.newspaper_rounded,
        color: const Color(0xFFD97706),
        imageUrl: 'https://images.unsplash.com/photo-1585829365295-ab7cd400c167?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'paper_cardboard',
        assetPath: 'assets/images/scrap/cat_paper.png',
        name: 'Corrugated Box (Cardboard)',
        hindiName: 'कार्टन / गत्ता',
        category: ScrapCategoryType.paper,
        unit: 'kg',
        retailRate: 13.0,
        vendorSlabs: const [
          VendorSlab(minKg: 200, maxKg: 500, ratePerKg: 15.0),
          VendorSlab(minKg: 500, maxKg: 1000, ratePerKg: 16.5),
          VendorSlab(minKg: 1000, maxKg: null, ratePerKg: 18.0),
        ],
        description: 'Packaging boxes, delivery cartons, and thick kraft boards.',
        icon: Icons.inventory_2_rounded,
        color: const Color(0xFFB45309),
        imageUrl: 'https://images.unsplash.com/photo-1530587191325-3db32d826c18?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'paper_white',
        assetPath: 'assets/images/scrap/mat_white_paper.png',
        name: 'Office White Records',
        hindiName: 'सफेद कागज़ / रिकॉर्ड',
        category: ScrapCategoryType.paper,
        unit: 'kg',
        retailRate: 15.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 17.0),
          VendorSlab(minKg: 500, maxKg: null, ratePerKg: 19.0),
        ],
        description: 'A4 sheets, printed files, books & spiral notebooks.',
        icon: Icons.description_rounded,
        color: const Color(0xFF92400E),
        imageUrl: 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=500&auto=format&fit=crop&q=80',
      ),

      // Metals
      ScrapMaterial(
        id: 'metal_iron',
        assetPath: 'assets/images/scrap/cat_metal.png',
        name: 'Iron / Steel Scrap',
        hindiName: 'लोहा व सरिया',
        category: ScrapCategoryType.metal,
        unit: 'kg',
        retailRate: 34.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 38.0),
          VendorSlab(minKg: 500, maxKg: 1000, ratePerKg: 40.0),
          VendorSlab(minKg: 1000, maxKg: null, ratePerKg: 42.5),
        ],
        description: 'TMT rods, angles, grills, gates, sheets and scrap steel.',
        icon: Icons.hardware_rounded,
        color: const Color(0xFF475569),
        imageUrl: 'https://images.unsplash.com/photo-1535813547-99c456a41d4a?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'metal_copper',
        assetPath: 'assets/images/scrap/cat_metal.png',
        name: 'Copper Wire & Scrap',
        hindiName: 'तांबा / कॉपर वायर',
        category: ScrapCategoryType.metal,
        unit: 'kg',
        retailRate: 520.0,
        vendorSlabs: const [
          VendorSlab(minKg: 50, maxKg: 200, ratePerKg: 540.0),
          VendorSlab(minKg: 200, maxKg: null, ratePerKg: 565.0),
        ],
        description: 'Uninsulated cables, copper motor winding and clean pipes.',
        icon: Icons.electric_bolt_rounded,
        color: const Color(0xFFEA580C),
        imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'metal_brass',
        assetPath: 'assets/images/scrap/cat_metal.png',
        name: 'Brass / Peetal',
        hindiName: 'पीतल के बर्तन व पुर्जे',
        category: ScrapCategoryType.metal,
        unit: 'kg',
        retailRate: 340.0,
        vendorSlabs: const [
          VendorSlab(minKg: 50, maxKg: 200, ratePerKg: 360.0),
          VendorSlab(minKg: 200, maxKg: null, ratePerKg: 375.0),
        ],
        description: 'Brass utensils, fittings, valves and decorative castings.',
        icon: Icons.shield_rounded,
        color: const Color(0xFFCA8A04),
        imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'metal_aluminium',
        assetPath: 'assets/images/scrap/cat_metal.png',
        name: 'Aluminium Scrap',
        hindiName: 'एल्युमीनियम',
        category: ScrapCategoryType.metal,
        unit: 'kg',
        retailRate: 140.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 152.0),
          VendorSlab(minKg: 500, maxKg: null, ratePerKg: 162.0),
        ],
        description: 'Window frames, beverage cans, kitchen vessels.',
        icon: Icons.view_sidebar_rounded,
        color: const Color(0xFF64748B),
        imageUrl: 'https://images.unsplash.com/photo-1563245372-f21724e3856d?w=500&auto=format&fit=crop&q=80',
      ),

      // Plastics
      ScrapMaterial(
        id: 'plastic_pet',
        assetPath: 'assets/images/scrap/cat_plastic.png',
        name: 'PET Bottles (Water & Soda)',
        hindiName: 'पीईटी प्लास्टिक बोतलें',
        category: ScrapCategoryType.plastic,
        unit: 'kg',
        retailRate: 16.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 18.0),
          VendorSlab(minKg: 500, maxKg: null, ratePerKg: 20.0),
        ],
        description: 'Clear plastic water, soda and beverage bottles.',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF0284C7),
        imageUrl: 'https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'plastic_hard',
        assetPath: 'assets/images/scrap/cat_plastic.png',
        name: 'Hard Plastic (Buckets/Chairs)',
        hindiName: 'कठोर प्लास्टिक (बाल्टी/कुर्सी)',
        category: ScrapCategoryType.plastic,
        unit: 'kg',
        retailRate: 18.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 20.0),
          VendorSlab(minKg: 500, maxKg: null, ratePerKg: 22.0),
        ],
        description: 'Broken plastic chairs, mugs, crates and heavy containers.',
        icon: Icons.chair_rounded,
        color: const Color(0xFF0369A1),
        imageUrl: 'https://images.unsplash.com/photo-1595278069441-2cf29f8005a4?w=500&auto=format&fit=crop&q=80',
      ),

      // E-Waste
      ScrapMaterial(
        id: 'ewaste_laptop',
        assetPath: 'assets/images/scrap/cat_ewaste.png',
        name: 'Old Laptop / Desktop CPU',
        hindiName: 'लैपटॉप / कंप्यूटर सीपीयू',
        category: ScrapCategoryType.eWaste,
        unit: 'pc',
        retailRate: 350.0,
        vendorSlabs: const [
          VendorSlab(minKg: 10, maxKg: 50, ratePerKg: 400.0),
          VendorSlab(minKg: 50, maxKg: null, ratePerKg: 450.0),
        ],
        description: 'Old computers, dead desktop towers and laptops.',
        icon: Icons.laptop_mac_rounded,
        color: const Color(0xFF7C3AED),
        imageUrl: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'ewaste_mobile',
        assetPath: 'assets/images/scrap/cat_ewaste.png',
        name: 'Old Smartphone / Tablets',
        hindiName: 'स्मार्टफोन / टैबलेट',
        category: ScrapCategoryType.eWaste,
        unit: 'pc',
        retailRate: 120.0,
        vendorSlabs: const [
          VendorSlab(minKg: 20, maxKg: 100, ratePerKg: 140.0),
          VendorSlab(minKg: 100, maxKg: null, ratePerKg: 160.0),
        ],
        description: 'Defunct mobile handsets, motherboards and portable screens.',
        icon: Icons.phone_android_rounded,
        color: const Color(0xFF6D28D9),
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500&auto=format&fit=crop&q=80',
      ),

      // E-Waste
      ScrapMaterial(
        id: 'ewaste_monitor_crt',
        assetPath: 'assets/images/scrap/mat_crt_monitor.png',
        name: 'Monitor (CRT)',
        hindiName: 'सीआरटी मॉनिटर',
        category: ScrapCategoryType.eWaste,
        unit: 'pc',
        retailRate: 100.0,
        vendorSlabs: const [
          VendorSlab(minKg: 5, maxKg: 20, ratePerKg: 120.0),
          VendorSlab(minKg: 20, maxKg: null, ratePerKg: 140.0),
        ],
        description: 'Old heavy tube computer monitors.',
        icon: Icons.tv_rounded,
        color: const Color(0xFF7C3AED),
        imageUrl: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'ewaste_printer',
        assetPath: 'assets/images/scrap/mat_printer.png',
        name: 'Printer',
        hindiName: 'प्रिंटर व स्कैनर',
        category: ScrapCategoryType.eWaste,
        unit: 'kg',
        retailRate: 15.0,
        vendorSlabs: const [
          VendorSlab(minKg: 50, maxKg: 200, ratePerKg: 18.0),
          VendorSlab(minKg: 200, maxKg: null, ratePerKg: 22.0),
        ],
        description: 'Defunct inkjet and laser printers.',
        icon: Icons.print_rounded,
        color: const Color(0xFF6D28D9),
        imageUrl: 'https://images.unsplash.com/photo-1612815154858-60aa4c59eaa6?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'ewaste_monitor_lcd',
        assetPath: 'assets/images/scrap/mat_lcd_monitor.png',
        name: 'Monitor (LCD/LED)',
        hindiName: 'एलसीडी / एलईडी स्क्रीन',
        category: ScrapCategoryType.eWaste,
        unit: 'pc',
        retailRate: 100.0,
        vendorSlabs: const [
          VendorSlab(minKg: 5, maxKg: 20, ratePerKg: 120.0),
          VendorSlab(minKg: 20, maxKg: null, ratePerKg: 150.0),
        ],
        description: 'Flat screen computer monitors.',
        icon: Icons.desktop_windows_rounded,
        color: const Color(0xFF8B5CF6),
        imageUrl: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500&auto=format&fit=crop&q=80',
      ),

      // Rubber
      ScrapMaterial(
        id: 'rubber_tyres',
        assetPath: 'assets/images/scrap/cat_rubber.png',
        name: 'Rubber Tyres',
        hindiName: 'गाड़ी के पुराने टायर',
        category: ScrapCategoryType.rubber,
        unit: 'kg',
        retailRate: 12.0,
        vendorSlabs: const [
          VendorSlab(minKg: 100, maxKg: 500, ratePerKg: 14.0),
          VendorSlab(minKg: 500, maxKg: null, ratePerKg: 16.0),
        ],
        description: 'Old car, bike, and truck tyres.',
        icon: Icons.album_rounded,
        color: const Color(0xFF1E293B),
        imageUrl: 'https://images.unsplash.com/photo-1578844251758-2f71da64c96f?w=500&auto=format&fit=crop&q=80',
      ),

      // Others & Batteries
      ScrapMaterial(
        id: 'others_inverter_battery',
        assetPath: 'assets/images/scrap/mat_inverter_battery.png',
        name: 'Inverter Battery',
        hindiName: 'इन्वर्टर बैटरी',
        category: ScrapCategoryType.others,
        unit: 'pc',
        retailRate: 1700.0,
        vendorSlabs: const [
          VendorSlab(minKg: 5, maxKg: 20, ratePerKg: 1850.0),
          VendorSlab(minKg: 20, maxKg: null, ratePerKg: 2000.0),
        ],
        description: 'Heavy lead-acid inverter batteries.',
        icon: Icons.battery_charging_full_rounded,
        color: const Color(0xFFDC2626),
        imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'others_alkaline_cell',
        assetPath: 'assets/images/scrap/mat_alkaline_cell.png',
        name: 'Alkaline Battery (Cell)',
        hindiName: 'सेल / छोटी बैटरी',
        category: ScrapCategoryType.others,
        unit: 'kg',
        retailRate: 2.0,
        vendorSlabs: const [
          VendorSlab(minKg: 50, maxKg: 200, ratePerKg: 3.5),
        ],
        description: 'AA, AAA, and torch dry cells.',
        icon: Icons.battery_full_rounded,
        color: const Color(0xFFB45309),
        imageUrl: 'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=500&auto=format&fit=crop&q=80',
      ),
      ScrapMaterial(
        id: 'others_ac',
        name: 'Split AC 1.5 Ton',
        hindiName: 'स्प्लिट एसी',
        category: ScrapCategoryType.others,
        unit: 'pc',
        retailRate: 3200.0,
        vendorSlabs: const [
          VendorSlab(minKg: 5, maxKg: 20, ratePerKg: 3400.0),
        ],
        description: 'Air conditioner indoor & outdoor unit.',
        icon: Icons.ac_unit_rounded,
        color: const Color(0xFF059669),
        imageUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=500&auto=format&fit=crop&q=80',
      ),
    ];
  }

  void _initAddresses() {
    _addresses = [
      const PickupAddress(
        id: 'addr_1',
        label: 'Home',
        fullAddress: 'Flat 402, Green Valley Heights, 12th Main, HAL 2nd Stage',
        landmark: 'Near Indiranagar Metro Station',
        pincode: '560001',
        city: 'Bengaluru',
        isDefault: true,
      ),
      const PickupAddress(
        id: 'addr_2',
        label: 'Godown / Warehouse',
        fullAddress: 'Shed No. 14, Okhla Industrial Area Phase 3',
        landmark: 'Opposite Railway Siding',
        pincode: '110020',
        city: 'New Delhi',
        isDefault: false,
      ),
      const PickupAddress(
        id: 'addr_3',
        label: 'Office',
        fullAddress: 'Level 3, Tech Park Plaza, Outer Ring Road',
        landmark: 'Beside Marriott Hotel',
        pincode: '560103',
        city: 'Bengaluru',
        isDefault: false,
      ),
    ];
    _selectedAddress = _addresses.first;
  }

  void _initRiders() {
    _riders = [
      const RiderProfile(
        id: 'rider_1',
        name: 'Rajesh Kumar',
        phone: '+91 98112 34567',
        rating: 4.9,
        totalPickups: 342,
        vehicleModel: 'Hero Electric Cargo Maxi',
        vehicleNumber: 'KA 03 EV 4912',
      ),
      const RiderProfile(
        id: 'rider_2',
        name: 'Amit Singh',
        phone: '+91 97204 88123',
        rating: 4.8,
        totalPickups: 218,
        vehicleModel: 'Tata Ace Gold EV',
        vehicleNumber: 'KA 01 TR 8092',
      ),
    ];
  }

  void _initVendorProfile() {
    _vendorProfile = const VendorProfile(
      businessName: 'Shree Ganesh Scrap & Metal Traders',
      ownerName: 'Mukesh Sharma',
      phone: '+91 98765 43210',
      gstin: '07AAACG9283K1Z5',
      godownAddress: 'Plot 42, Mayapuri Industrial Area Phase 2',
      city: 'New Delhi',
      isApproved: true,
      tier: 'Gold Partner (Tier 1)',
    );
  }

  void _initMockOrders() {
    final newspaper = _materials.firstWhere((m) => m.id == 'paper_newspaper');
    final cardboard = _materials.firstWhere((m) => m.id == 'paper_cardboard');
    final iron = _materials.firstWhere((m) => m.id == 'metal_iron');
    final battery = _materials.firstWhere((m) => m.id == 'others_inverter_battery');

    _orders = [
      // 1. Live Ongoing Order (On The Way)
      PickupRequest(
        id: 'KBD-84920',
        userRole: UserRole.customer,
        userName: 'Vikram Malhotra',
        userPhone: '+91 98765 43210',
        address: _addresses.first,
        slotDate: 'Today, 24 Sep',
        slotTime: '10:00 AM - 01:00 PM',
        items: [
          PickupItem(
            material: newspaper,
            estimatedQty: 25.0,
            actualQty: 27.5,
            appliedRate: 16.0,
          ),
          PickupItem(
            material: cardboard,
            estimatedQty: 30.0,
            actualQty: 32.0,
            appliedRate: 13.0,
          ),
          PickupItem(
            material: iron,
            estimatedQty: 15.0,
            actualQty: 16.0,
            appliedRate: 34.0,
          ),
        ],
        status: PickupStatus.onTheWay,
        assignedRider: _riders.first,
        paymentMethod: 'Instant UPI (PhonePe/GPay)',
        paymentStatus: 'Pending Weighing',
        otp: '8492',
        notes: 'Doorbell is not working, please call upon reaching gate.',
        photosAttached: 2,
        pickupCharge: 0.0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),

      // 2. Bulk Vendor Order (Under Hub Verification)
      PickupRequest(
        id: 'VND-39012',
        userRole: UserRole.vendor,
        userName: 'Shree Ganesh Scrap Godown',
        userPhone: '+91 98765 43210',
        address: _addresses[1],
        slotDate: 'Tomorrow, 25 Sep',
        slotTime: '02:00 PM - 05:00 PM',
        items: [
          PickupItem(
            material: iron,
            estimatedQty: 850.0,
            appliedRate: 40.0, // vendor slab 500-1000kg
          ),
          PickupItem(
            material: cardboard,
            estimatedQty: 600.0,
            appliedRate: 16.5, // vendor slab 500-1000kg
          ),
        ],
        status: PickupStatus.requested,
        paymentMethod: 'Direct Bank NEFT / RTGS',
        paymentStatus: 'Pending Approval',
        otp: '5173',
        deliveryMode: 'Doorstep Pickup',
        notes: 'Forklift available at shed 14 for heavy metal loading.',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),

      // 3. Completed Past Order
      PickupRequest(
        id: 'KBD-71089',
        userRole: UserRole.customer,
        userName: 'Vikram Malhotra',
        userPhone: '+91 98765 43210',
        address: _addresses.first,
        slotDate: '18 Sep 2026',
        slotTime: '11:00 AM - 02:00 PM',
        items: [
          PickupItem(
            material: battery,
            estimatedQty: 1.0,
            actualQty: 1.0,
            appliedRate: 1850.0,
          ),
          PickupItem(
            material: newspaper,
            estimatedQty: 18.0,
            actualQty: 19.5,
            appliedRate: 16.0,
          ),
        ],
        status: PickupStatus.completed,
        assignedRider: _riders.first,
        paymentMethod: 'Instant UPI',
        paymentStatus: 'Paid (Ref: UPI/2026/89412)',
        otp: '9182',
        hasDigitalSignature: true,
        finalSettledAmount: 2162.0,
        rating: 5,
        feedback: 'Very punctual rider Rajesh! Brought digital scale and transferred cash immediately.',
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
    ];
  }

  // --- Actions ---

  void login({required String phone, String? name, UserRole? role}) {
    _isLoggedIn = true;
    _phoneNumber = phone;
    if (name != null && name.isNotEmpty) {
      _userName = name;
    }
    if (role != null) {
      _currentRole = role;
      _previewMode = role;
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setRole(UserRole role) {
    _currentRole = role;
    _previewMode = role;
    notifyListeners();
  }

  void setPreviewMode(UserRole role) {
    _previewMode = role;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }

  void setLocation(String city, String pincode) {
    _currentCity = city;
    _currentPincode = pincode;
    notifyListeners();
  }

  void setSelectedAddress(PickupAddress addr) {
    _selectedAddress = addr;
    notifyListeners();
  }

  void setBookingDate(String date) {
    _bookingDate = date;
    notifyListeners();
  }

  void setBookingSlot(String slot) {
    _bookingSlot = slot;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void setDeliveryMode(String mode) {
    _deliveryMode = mode;
    notifyListeners();
  }

  void setAttachedPhotosCount(int count) {
    _attachedPhotosCount = count;
    notifyListeners();
  }

  // Cart operations
  void updateCartQuantity(String materialId, double qty) {
    if (qty <= 0) {
      _cartQuantities.remove(materialId);
    } else {
      _cartQuantities[materialId] = qty;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartQuantities.clear();
    _attachedPhotosCount = 0;
    notifyListeners();
  }

  double get cartEstimatedTotal {
    double total = 0.0;
    _cartQuantities.forEach((id, qty) {
      final material = _materials.firstWhere((m) => m.id == id);
      final rate = material.getRateFor(qty, _previewMode);
      total += (qty * rate);
    });
    return total;
  }

  double get cartEstimatedWeight {
    double totalWeight = 0.0;
    _cartQuantities.forEach((id, qty) {
      final material = _materials.firstWhere((m) => m.id == id);
      if (material.unit == 'kg') {
        totalWeight += qty;
      }
    });
    return totalWeight;
  }

  double get calculatedPickupFee {
    if (_deliveryMode == 'Self-Delivery to Hub') return 0.0;
    // Free pickup if weight >= 15kg or total value >= ₹200
    if (cartEstimatedWeight >= 15.0 || cartEstimatedTotal >= 200.0) {
      return 0.0;
    }
    return 30.0; // ₹30 nominal fee for small household pickups
  }

  // Submit new booking
  PickupRequest submitBooking({String? notes}) {
    final newItems = <PickupItem>[];
    _cartQuantities.forEach((id, qty) {
      final material = _materials.firstWhere((m) => m.id == id);
      final rate = material.getRateFor(qty, _previewMode);
      newItems.add(
        PickupItem(
          material: material,
          estimatedQty: qty,
          appliedRate: rate,
        ),
      );
    });

    final newOrder = PickupRequest(
      id: _previewMode == UserRole.vendor
          ? 'VND-${10000 + _orders.length * 379}'
          : 'KBD-${80000 + _orders.length * 412}',
      userRole: _previewMode,
      userName: _previewMode == UserRole.vendor ? _vendorProfile.businessName : _userName,
      userPhone: _phoneNumber,
      address: _selectedAddress,
      slotDate: _bookingDate,
      slotTime: _bookingSlot,
      items: newItems,
      status: PickupStatus.requested,
      paymentMethod: _paymentMethod,
      otp: '${1000 + (_orders.length * 791) % 9000}',
      notes: notes,
      photosAttached: _attachedPhotosCount,
      pickupCharge: calculatedPickupFee,
      deliveryMode: _deliveryMode,
      createdAt: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    clearCart();
    notifyListeners();
    return newOrder;
  }

  // Update order status (Interactive Lifecycle Demo)
  void advanceOrderStatus(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index == -1) return;

    final order = _orders[index];
    switch (order.status) {
      case PickupStatus.requested:
        order.status = PickupStatus.accepted;
        break;
      case PickupStatus.accepted:
        order.status = PickupStatus.riderAssigned;
        order.assignedRider ??= _riders.first;
        break;
      case PickupStatus.riderAssigned:
        order.status = PickupStatus.onTheWay;
        break;
      case PickupStatus.onTheWay:
        order.status = PickupStatus.reached;
        // set actual weights if null
        for (final it in order.items) {
          it.actualQty ??= it.estimatedQty + 1.5;
        }
        break;
      case PickupStatus.reached:
        order.status = PickupStatus.completed;
        order.hasDigitalSignature = true;
        order.paymentStatus = 'Paid (Ref: UPI/${DateTime.now().year}/SETTLE)';
        order.finalSettledAmount = order.actualTotal;
        break;
      case PickupStatus.completed:
      case PickupStatus.cancelled:
        break;
    }
    notifyListeners();
  }

  // Rider updates actual weighed quantity
  void riderUpdateItemWeight(String orderId, String materialId, double actualKg) {
    final order = _orders.firstWhere((o) => o.id == orderId);
    final item = order.items.firstWhere((it) => it.material.id == materialId);
    item.actualQty = actualKg;
    notifyListeners();
  }

  // Complete pickup with signature
  void riderCompletePickup(String orderId, {int rating = 5, String? feedback}) {
    final order = _orders.firstWhere((o) => o.id == orderId);
    order.status = PickupStatus.completed;
    order.hasDigitalSignature = true;
    order.paymentStatus = 'Paid Instant Cash/UPI';
    order.finalSettledAmount = order.actualTotal;
    order.rating = rating;
    order.feedback = feedback ?? 'Doorstep weighing verified accurately.';
    notifyListeners();
  }

  // Admin assigns rider
  void adminAssignRider(String orderId, RiderProfile rider) {
    final order = _orders.firstWhere((o) => o.id == orderId);
    order.assignedRider = rider;
    order.status = PickupStatus.riderAssigned;
    notifyListeners();
  }

  // Admin updates scrap rate
  void adminUpdateRate(String materialId, double newRetailRate) {
    final mat = _materials.firstWhere((m) => m.id == materialId);
    mat.retailRate = newRetailRate;
    notifyListeners();
  }
}

/// InheritedWidget scope for convenient access anywhere in the widget tree
class ScrapStateScope extends InheritedNotifier<ScrapState> {
  const ScrapStateScope({
    super.key,
    required ScrapState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static ScrapState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ScrapStateScope>();
    assert(scope != null, 'No ScrapStateScope found in context');
    return scope!.notifier!;
  }
}
