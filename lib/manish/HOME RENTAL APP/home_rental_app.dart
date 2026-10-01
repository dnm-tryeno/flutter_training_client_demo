import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const HomeRentalApp());
}

final ValueNotifier<ThemeMode> appThemeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class HomeRentalApp extends StatefulWidget {
  const HomeRentalApp({super.key});

  @override
  State<HomeRentalApp> createState() => _HomeRentalAppState();
}

class _HomeRentalAppState extends State<HomeRentalApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'RentEase - Monthly Rental Platform',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0F766E),
              brightness: Brightness.light,
              primary: const Color(0xFF0F766E),
              secondary: const Color(0xFF0284C7),
              surface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFFF1F5F9),
            cardColor: Colors.white,
            dialogTheme: const DialogThemeData(
              backgroundColor: Colors.white,
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0F172A),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF14B8A6),
              brightness: Brightness.dark,
              primary: const Color(0xFF14B8A6),
              secondary: const Color(0xFF38BDF8),
              surface: const Color(0xFF1E293B),
            ),
            scaffoldBackgroundColor: const Color(0xFF0B1120),
            cardColor: const Color(0xFF1E293B),
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF020617),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF0F172A),
              selectedItemColor: Color(0xFF14B8A6),
              unselectedItemColor: Color(0xFF94A3B8),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E293B),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              contentTextStyle: TextStyle(color: Color(0xFFE2E8F0)),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color(0xFF1E293B),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E293B),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF334155)),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF0F172A),
              labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
              hintStyle: const TextStyle(color: Color(0xFF64748B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.8),
              ),
            ),
          ),
          home: const MainPortalScreen(),
        );
      },
    );
  }
}

enum UserRole { customer, owner, admin }

class MainPortalScreen extends StatefulWidget {
  const MainPortalScreen({super.key});

  @override
  State<MainPortalScreen> createState() => _MainPortalScreenState();
}

class _MainPortalScreenState extends State<MainPortalScreen> {
  UserRole _currentRole = UserRole.customer;
  int _currentBottomNavIndex = 0;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _cardBg => _isDark ? const Color(0xFF1E293B) : Colors.white;
  Color get _subtleBg => _isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
  Color get _textPrimary => _isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  Color get _textSecondary => _isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  Color get _borderColor => _isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // Filter States for Customer
  String _selectedAreaType = 'all'; // 'all', 'urban', 'rural'
  String _selectedCity = '';
  String _selectedLocality = '';
  String _selectedPropertyType = '';
  final Set<String> _selectedSuitableFor = {};
  final Set<String> _selectedAmenities = {};
  String _selectedFurnishing = 'All';
  double _maxRentBudget = 50000;
  bool _onlyAvailable = true;
  String _searchQuery = '';
  final Set<String> _savedPropertyIds = {'prop_1_room_101'};
  List<String> _searchHistory = [
    'Varanasi 1 BHK',
    'Lanka Students Room',
    'Rural Godown Harahua',
    'Lucknow 2 BHK Family'
  ];

  // Authentication & Role Portal State
  bool _isAuthenticated = false;
  int _loginRoleIndex = 0; // 0: Customer, 1: Owner, 2: Admin
  final TextEditingController _loginPhoneOrEmailCtrl = TextEditingController(text: '9876543210');
  final TextEditingController _loginPasswordOrOtpCtrl = TextEditingController(text: '123456');
  final TextEditingController _adminEmailCtrl = TextEditingController(text: 'admin@rentease.com');
  final TextEditingController _adminKeyCtrl = TextEditingController(text: 'admin#2026');
  bool _obscurePassword = true;

  // Customer Profile State
  Map<String, dynamic> _currentCustomer = {
    'id': 'cust_1',
    'name': 'Amit Sharma',
    'phone': '9876543210',
    'email': 'amit.sharma@example.com',
    'city': 'Varanasi',
    'area': 'Lanka',
    'type': 'Working Professional',
    'kyc': true,
  };

  // Mock Database
  late List<Map<String, dynamic>> _properties;
  late List<Map<String, dynamic>> _rentalRequests;
  late List<Map<String, dynamic>> _activeRentals;
  late List<Map<String, dynamic>> _rentPayments;
  late List<Map<String, dynamic>> _notifications;
  late List<Map<String, dynamic>> _complaints;
  late List<Map<String, dynamic>> _customers;
  late List<Map<String, dynamic>> _owners;
  late List<Map<String, dynamic>> _adminUsers;
  late List<Map<String, dynamic>> _auditLogs;
  late List<Map<String, dynamic>> _pastRentals;
  String _ownerContactPrivacy = 'CALL_MSG_ON'; // CALL_MSG_ON, CALL_ON_MSG_OFF, CALL_OFF_MSG_ON, BOTH_OFF
  final Set<String> _expandedPropertyIds = {'prop_1'};
  String _ownerRoomFilter = 'ALL'; // ALL, AVAILABLE, RENTED
  String _adminCustomerFilter = 'ALL';
  final Set<String> _expandedCustomerIds = {'cust_1'};
  String _adminOwnerFilter = 'ALL';
  final Set<String> _expandedAdminOwnerIds = {'owner_1'};
  String _adminPropertyFilter = 'ALL'; // ALL, URBAN, RURAL, AVAILABLE
  final Set<String> _expandedAdminPropertyIds = {'prop_1'};

  @override
  void initState() {
    super.initState();
    _initMockDatabase();
  }

  void _initMockDatabase() {
    _properties = [
      {
        'id': 'prop_1',
        'ownerId': 'owner_1',
        'ownerName': 'Rajesh Pandey',
        'ownerPhone': '9450012345',
        'title': 'Ganga Heights Deluxe Complex',
        'propertyType': 'apartment',
        'areaType': 'urban',
        'city': 'Varanasi',
        'locality': 'Lanka',
        'address': 'Near BHU Main Gate, Lanka, Varanasi - 221005',
        'rating': 4.8,
        'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
        'images': [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
        ],
        'electricityInfo': 'Sub-meter installed. ₹7.50/unit as per reading.',
        'maintenanceInfo': '₹600/month includes water, lift and cleaning.',
        'amenities': ['Wi-Fi', '24/7 Water', 'Attached Bathroom', 'Kitchen', 'Power Backup', 'CCTV Security', 'Parking'],
        'rooms': [
          {
            'id': 'room_101',
            'roomNumber': 'Room 101',
            'roomType': '1 BHK',
            'size': '520 sq.ft',
            'furnishing': 'Semi-Furnished',
            'monthlyRent': 8500,
            'securityDeposit': 17000,
            'dueDay': 5,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Students', 'Working Professional', 'Boys', 'Single Person'],
          },
          {
            'id': 'room_102',
            'roomNumber': 'Room 102',
            'roomType': '2 BHK',
            'size': '950 sq.ft',
            'furnishing': 'Fully Furnished',
            'monthlyRent': 14000,
            'securityDeposit': 28000,
            'dueDay': 5,
            'status': 'Rented',
            'availableFrom': '1 Nov 2026',
            'tenantName': 'Amit Sharma',
            'suitableFor': ['Family', 'Couple', 'Working Professional'],
          },
          {
            'id': 'room_103',
            'roomNumber': 'Room 103',
            'roomType': '1 BHK',
            'size': '550 sq.ft',
            'furnishing': 'Furnished',
            'monthlyRent': 9000,
            'securityDeposit': 18000,
            'dueDay': 5,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Girls', 'Students', 'Working Professional'],
          },
          {
            'id': 'room_104',
            'roomNumber': 'Room 104',
            'roomType': 'Single Room',
            'size': '280 sq.ft',
            'furnishing': 'Furnished Single Room',
            'monthlyRent': 5500,
            'securityDeposit': 10000,
            'dueDay': 5,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Students', 'Boys', 'Single Person'],
          },
        ]
      },
      {
        'id': 'prop_2',
        'ownerId': 'owner_1',
        'ownerName': 'Rajesh Pandey',
        'ownerPhone': '9450012345',
        'title': 'Kashi Heritage Independent House',
        'propertyType': 'house',
        'areaType': 'urban',
        'city': 'Varanasi',
        'locality': 'Assi Ghat',
        'address': 'B-12/48, Near Assi Ghat Steps, Varanasi',
        'rating': 4.9,
        'image': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80',
        'images': [
          'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
        ],
        'electricityInfo': 'Direct UPPCL meter bill.',
        'maintenanceInfo': 'Self-maintained independent house.',
        'amenities': ['24/7 Water', 'Parking', 'Kitchen', 'Balcony', 'Power Backup'],
        'rooms': [
          {
            'id': 'room_201',
            'roomNumber': 'Entire 3 BHK House',
            'roomType': '3 BHK',
            'size': '1650 sq.ft',
            'furnishing': 'Semi-Furnished',
            'monthlyRent': 22000,
            'securityDeposit': 44000,
            'dueDay': 1,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Family', 'Couple'],
          }
        ]
      },
      {
        'id': 'prop_3',
        'ownerId': 'owner_2',
        'ownerName': 'Sunita Devi',
        'ownerPhone': '9415098765',
        'title': 'Gomti Greens Premium Residency',
        'propertyType': 'flat',
        'areaType': 'urban',
        'city': 'Lucknow',
        'locality': 'Gomti Nagar',
        'address': 'Tower 4, Gomti Nagar Extension, Lucknow',
        'rating': 4.9,
        'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
        'images': [
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
        ],
        'electricityInfo': 'Prepaid smart meter.',
        'maintenanceInfo': '₹1,500/month society maintenance included.',
        'amenities': ['Wi-Fi', '24/7 Water', 'CCTV Security', 'Lift', 'Gym', 'Parking'],
        'rooms': [
          {
            'id': 'room_301',
            'roomNumber': 'Flat 602 (2 BHK)',
            'roomType': '2 BHK',
            'size': '1180 sq.ft',
            'furnishing': 'Fully Furnished',
            'monthlyRent': 16000,
            'securityDeposit': 32000,
            'dueDay': 1,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Family', 'Couple', 'Working Professional'],
          }
        ]
      },
      {
        'id': 'prop_4',
        'ownerId': 'owner_4',
        'ownerName': 'Chaudhary Ramu Singh',
        'ownerPhone': '9919033445',
        'title': 'Harahua Logistics & Agro Godown',
        'propertyType': 'godown',
        'areaType': 'rural',
        'city': 'Varanasi Rural',
        'locality': 'Harahua Village',
        'address': 'Main Highway Link, Harahua Village, Varanasi Rural',
        'rating': 4.6,
        'image': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80',
        'images': [
          'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1553413077-190dd305871c?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1578575437130-527eed3abbec?auto=format&fit=crop&w=800&q=80',
        ],
        'electricityInfo': '3-Phase industrial 15KW power connection.',
        'maintenanceInfo': 'Boundary guard included.',
        'amenities': ['Truck Parking', '3-Phase Power', 'Security Guard', 'Water Supply'],
        'rooms': [
          {
            'id': 'room_801',
            'roomNumber': 'Godown Shed A',
            'roomType': 'Godown',
            'size': '2500 sq.ft',
            'furnishing': 'Industrial Warehouse with Office Cabin',
            'monthlyRent': 25000,
            'securityDeposit': 50000,
            'dueDay': 10,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Other', 'Working Professional'],
          }
        ]
      },
      {
        'id': 'prop_5',
        'ownerId': 'owner_4',
        'ownerName': 'Chaudhary Ramu Singh',
        'ownerPhone': '9919033445',
        'title': 'Bakshi Ka Talab Countryside Cottage',
        'propertyType': 'house',
        'areaType': 'rural',
        'city': 'Lucknow Rural',
        'locality': 'Bakshi Ka Talab',
        'address': 'Village Raitha Road, Bakshi Ka Talab, Lucknow Rural',
        'rating': 4.7,
        'image': 'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80',
        'images': [
          'https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80',
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
        ],
        'electricityInfo': 'Solar power backup + rural subsidized connection.',
        'maintenanceInfo': 'Gardener and tubewell maintained.',
        'amenities': ['Solar Power', 'Tubewell Water', 'Garden', 'Parking'],
        'rooms': [
          {
            'id': 'room_901',
            'roomNumber': 'Farmhouse 2 BHK',
            'roomType': '2 BHK',
            'size': '1200 sq.ft',
            'furnishing': 'Semi-Furnished',
            'monthlyRent': 11000,
            'securityDeposit': 20000,
            'dueDay': 5,
            'status': 'Available',
            'availableFrom': 'Immediate',
            'suitableFor': ['Family', 'Couple', 'Single Person', 'Working Professional'],
          }
        ]
      }
    ];

    _rentalRequests = [
      {
        'id': 'req_101',
        'customerId': 'cust_2',
        'customerName': 'Priya Verma',
        'customerPhone': '9812354321',
        'customerType': 'Students',
        'propertyId': 'prop_1',
        'roomId': 'room_103',
        'propertyTitle': 'Ganga Heights Deluxe Complex',
        'roomNumber': 'Room 103 (1 BHK)',
        'monthlyRent': 9000,
        'securityDeposit': 18000,
        'moveInDate': '2026-10-15',
        'durationMonths': 11,
        'status': 'Owner Accepted', // Request Sent, Owner Accepted, Rejected, Terms Confirmed, Agreement Completed
        'termsConfirmed': false,
        'notes': 'Preparing for civil services, looking for quiet study room.'
      }
    ];

    _activeRentals = [
      {
        'id': 'rent_1',
        'customerId': 'cust_1',
        'customerName': 'Amit Sharma',
        'propertyId': 'prop_1',
        'roomId': 'room_102',
        'propertyTitle': 'Ganga Heights Deluxe Complex',
        'roomNumber': 'Room 102 (2 BHK)',
        'address': 'Near BHU Main Gate, Lanka, Varanasi',
        'monthlyRent': 14000,
        'securityDeposit': 28000,
        'startDate': '2026-09-01',
        'dueDay': 5,
        'status': 'Active',
        'agreementStatus': 'Countersigned & Legally Binding',
        'isCurrentMonthPaid': false,
      }
    ];

    _rentPayments = [
      {
        'id': 'pay_1',
        'rentalId': 'rent_1',
        'month': 'September 2026',
        'amount': 14000,
        'dueDate': '2026-09-05',
        'paymentDate': '2026-09-05',
        'mode': 'UPI',
        'status': 'Paid',
        'txnRef': 'UPI-8823901429',
        'receiptNo': 'REC-2026-09-102',
      },
      {
        'id': 'pay_2',
        'rentalId': 'rent_1',
        'month': 'October 2026',
        'amount': 14000,
        'dueDate': '2026-10-05',
        'paymentDate': null,
        'mode': null,
        'status': 'Pending',
        'txnRef': null,
        'receiptNo': null,
      }
    ];

    _pastRentals = [
      {
        'propertyTitle': 'Assi Heritage Independent House',
        'roomNumber': 'Room 101 (1 BHK)',
        'address': 'Assi Ghat, Varanasi',
        'monthlyRent': 7500,
        'duration': 'Jan 2026 - Aug 2026',
        'status': 'Completed',
        'ownerName': 'Rajesh Pandey',
      }
    ];

    _notifications = [
      {
        'id': 'notif_1',
        'title': 'Monthly Rent Due in 4 Days',
        'message': 'Your monthly rent of ₹14,000 for Ganga Heights (Room 102) is due on 5 October.',
        'time': 'Today 8:00 AM',
        'isRead': false,
        'isReminder': true,
      },
      {
        'id': 'notif_2',
        'title': 'Rental Request Accepted',
        'message': 'Host Rajesh Pandey accepted your rental request for Room 103. Please confirm final terms.',
        'time': 'Yesterday 4:30 PM',
        'isRead': false,
        'isReminder': false,
      }
    ];

    _complaints = [
      {
        'id': 'comp_1',
        'user': 'Amit Sharma',
        'category': 'Property Issue',
        'subject': 'Bathroom tap low water pressure',
        'desc': 'Slow water flow in overhead geyser line in Room 102.',
        'status': 'In Progress',
        'adminReply': 'Plumber scheduled for inspection today at 4 PM.',
        'date': '2026-09-28',
      }
    ];

    _customers = [
      {
        'id': 'cust_1',
        'name': 'Amit Sharma',
        'phone': '9876543210',
        'email': 'amit.sharma@example.com',
        'type': 'Working Professional',
        'kyc': true,
        'status': 'Active',
        'assignedPropertyId': 'prop_1',
        'assignedRoomId': 'room_102',
        'assignedPropertyTitle': 'Ganga Heights Deluxe Complex',
        'assignedRoomNumber': 'Room 102 (2 BHK)',
        'monthlyRent': 14000,
        'securityDeposit': 28000,
        'moveInDate': '2026-09-01',
      },
      {'id': 'cust_2', 'name': 'Priya Verma', 'phone': '9812354321', 'email': 'priya.verma@example.com', 'type': 'Students', 'kyc': true, 'status': 'Active'},
      {'id': 'cust_3', 'name': 'Rahul & Anjali Gupta', 'phone': '9721098765', 'email': 'rahul.gupta@example.com', 'type': 'Family', 'kyc': true, 'status': 'Active'},
    ];

    _owners = [
      {'id': 'owner_1', 'name': 'Rajesh Pandey', 'phone': '9450012345', 'propertiesCount': 3, 'contactPrivacy': 'CALL_MSG_ON', 'status': 'Active'},
      {'id': 'owner_2', 'name': 'Sunita Devi', 'phone': '9415098765', 'propertiesCount': 2, 'contactPrivacy': 'CALL_ON_MSG_OFF', 'status': 'Active'},
      {'id': 'owner_4', 'name': 'Chaudhary Ramu Singh', 'phone': '9919033445', 'propertiesCount': 2, 'contactPrivacy': 'CALL_MSG_ON', 'status': 'Active'},
    ];

    _adminUsers = [
      {'name': 'Super Administrator', 'email': 'admin@rentease.in', 'role': 'Super Admin', 'status': 'Active'},
      {'name': 'Vikas Verma', 'email': 'vikas.verma@rentease.in', 'role': 'Finance Admin', 'status': 'Active'},
      {'name': 'Ananya Roy', 'email': 'ananya.roy@rentease.in', 'role': 'Support Admin', 'status': 'Active'},
    ];

    _auditLogs = [
      {'action': 'PROPERTY_APPROVED', 'module': 'Properties', 'recordId': 'prop_1', 'newValue': 'Approved', 'timestamp': '2026-10-01 10:15', 'ip': '192.168.1.24'},
      {'action': 'RENT_RECORDED', 'module': 'Payments', 'recordId': 'pay_1', 'newValue': 'Paid (UPI - ₹14,000)', 'timestamp': '2026-09-05 14:46', 'ip': '192.168.1.24'},
      {'action': 'COMPLAINT_RESOLVED', 'module': 'Complaints', 'recordId': 'comp_1', 'newValue': 'Resolved', 'timestamp': '2026-09-25 11:45', 'ip': '192.168.1.18'},
    ];
  }

  // Filtered Properties for Customer Search
  List<Map<String, dynamic>> _getFilteredProperties() {
    List<Map<String, dynamic>> results = [];

    for (var prop in _properties) {
      if (_selectedAreaType != 'all' && prop['areaType'].toString().toLowerCase() != _selectedAreaType.toLowerCase()) {
        continue;
      }
      if (_selectedCity.isNotEmpty && prop['city'].toString().toLowerCase() != _selectedCity.toLowerCase()) {
        continue;
      }
      if (_selectedPropertyType.isNotEmpty && prop['propertyType'].toString().toLowerCase() != _selectedPropertyType.toLowerCase()) {
        continue;
      }

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = prop['title'].toString().toLowerCase().contains(q) ||
            prop['locality'].toString().toLowerCase().contains(q) ||
            prop['city'].toString().toLowerCase().contains(q) ||
            prop['address'].toString().toLowerCase().contains(q) ||
            prop['propertyType'].toString().toLowerCase().contains(q);
        if (!matches) continue;
      }

      if (_selectedLocality.isNotEmpty && prop['locality'].toString().toLowerCase() != _selectedLocality.toLowerCase()) {
        continue;
      }
      if (_selectedAmenities.isNotEmpty) {
        final amenities = List<String>.from(prop['amenities'] ?? []).map((a) => a.toString().toLowerCase()).toList();
        final matchesAmenities = _selectedAmenities.every((a) => amenities.contains(a.toLowerCase()));
        if (!matchesAmenities) continue;
      }

      // Filter rooms
      for (var room in (prop['rooms'] as List)) {
        if (_onlyAvailable && room['status'] != 'Available') {
          continue;
        }
        if (room['monthlyRent'] > _maxRentBudget) {
          continue;
        }

        // Furnishing filter
        if (_selectedFurnishing != 'All') {
          if (!room['furnishing'].toString().toLowerCase().contains(_selectedFurnishing.toLowerCase())) {
            continue;
          }
        }

        // Suitable For match
        if (_selectedSuitableFor.isNotEmpty) {
          final roomSuitable = List<String>.from(room['suitableFor'] ?? []).map((s) => s.toString().toLowerCase()).toList();
          final hasMatch = _selectedSuitableFor.any((s) => roomSuitable.contains(s.toString().toLowerCase()));
          if (!hasMatch) continue;
        }

        results.add({
          'property': prop,
          'room': room,
        });
      }
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return _buildLoginScaffold();
    }
    return _buildAuthenticatedPanelScaffold();
  }

  // ===================================================================
  // 0. MULTI-ROLE AUTHENTICATION & LOGIN PORTAL
  // ===================================================================
  Widget _buildLoginScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Theme Mode Switcher in Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<ThemeMode>(
                        valueListenable: appThemeModeNotifier,
                        builder: (ctx, mode, _) {
                          final isDark = mode == ThemeMode.dark;
                          return InkWell(
                            onTap: () {
                              appThemeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                                    size: 14,
                                    color: isDark ? Colors.amber : Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isDark ? 'Light' : 'Dark',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // App Brand Banner
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F766E), Color(0xFF14B8A6), Color(0xFFF59E0B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF0F766E).withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.home_work_rounded, size: 36, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'RentEase',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      'MONTHLY RENTAL PLATFORM',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF38BDF8),
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Rooms • Flats • 1/2/3 BHK • Hostels • PGs • Godowns',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // 3-Role Tab Switcher
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Row(
                      children: [
                        _buildLoginRoleTab(Icons.person_rounded, 'Customer', 0),
                        _buildLoginRoleTab(Icons.business_rounded, 'Owner', 1),
                        _buildLoginRoleTab(Icons.admin_panel_settings_rounded, 'Admin', 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Active Role Form Card
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: _buildLoginFormContent(),
                  ),

                  const SizedBox(height: 16),
                  // Footer note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock_outline_rounded, size: 13, color: Colors.white60),
                      SizedBox(width: 5),
                      Text(
                        'Aadhaar e-KYC Verified & 256-bit Encrypted Session',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginRoleTab(IconData icon, String label, int index) {
    final isSelected = _loginRoleIndex == index;
    Color activeColor = const Color(0xFF0F766E);
    if (index == 1) activeColor = const Color(0xFFD97706);
    if (index == 2) activeColor = const Color(0xFF0284C7);

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _loginRoleIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: isSelected ? Colors.white : Colors.white60),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginFormContent() {
    if (_loginRoleIndex == 0) {
      return _buildCustomerLoginForm();
    } else if (_loginRoleIndex == 1) {
      return _buildOwnerLoginForm();
    } else {
      return _buildAdminLoginForm();
    }
  }

  // --- 1. Customer Login Form ---
  Widget _buildCustomerLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person_rounded, color: Color(0xFF0F766E), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer / Tenant Portal', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const Text('Search rooms, e-KYC agreements & pay rent', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _loginPhoneOrEmailCtrl,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile Number (+91) *',
            hintText: '9876543210',
            prefixIcon: Icon(Icons.phone_android_rounded, size: 20),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _loginPasswordOrOtpCtrl,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'OTP / Password *',
            hintText: '123456',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.login_rounded, size: 18),
            label: const Text('Login to Customer Panel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () => _loginAsCustomer(_customers[0]),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF0F766E),
              side: const BorderSide(color: Color(0xFF0F766E)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.person_add_rounded, size: 16),
            label: const Text('Register as New Customer / Tenant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: _openCustomerSignupDialog,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('OR 1-TAP DEMO LOGIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        _buildDemoUserCard(
          name: 'Amit Sharma',
          role: 'Working Professional • Varanasi',
          phone: '+91 9876543210',
          color: const Color(0xFF0F766E),
          onTap: () => _loginAsCustomer(_customers[0]),
        ),
        const SizedBox(height: 8),
        _buildDemoUserCard(
          name: 'Priya Singh',
          role: 'Student / Bachelor • Lanka Area',
          phone: '+91 9812345678',
          color: const Color(0xFF0284C7),
          onTap: () => _loginAsCustomer(_customers[1]),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildFeatureChip('Search & Filters'),
            _buildFeatureChip('Only Available Rooms'),
            _buildFeatureChip('Aadhaar e-KYC'),
            _buildFeatureChip('Monthly Rent History'),
            _buildFeatureChip('Support Desk'),
          ],
        ),
      ],
    );
  }

  // --- 2. Owner Login Form ---
  Widget _buildOwnerLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.business_rounded, color: Color(0xFFD97706), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Property Owner / Landlord Portal', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const Text('Manage units, review requests & collect rent', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _loginPhoneOrEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Host Mobile or Email *',
            hintText: 'rajesh.pandey@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 20),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _loginPasswordOrOtpCtrl,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Host Password *',
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD97706),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.business_center_rounded, size: 18),
            label: const Text('Login to Owner Panel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: () => _loginAsOwner(_owners[0]),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFD97706),
              side: const BorderSide(color: Color(0xFFD97706)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.person_add_alt_1_rounded, size: 16),
            label: const Text('Register as New Landlord / Owner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            onPressed: _openOwnerSignupDialog,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('OR 1-TAP DEMO LOGIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        _buildDemoUserCard(
          name: 'Rajesh Pandey',
          role: 'Host of 2 Properties • 3 Units Managed',
          phone: '+91 9450012345',
          color: const Color(0xFFD97706),
          onTap: () => _loginAsOwner(_owners[0]),
        ),
        const SizedBox(height: 8),
        _buildDemoUserCard(
          name: 'Anil Verma',
          role: 'Host • Godown & Rural Harahua',
          phone: '+91 9839012345',
          color: const Color(0xFF4338CA),
          onTap: () => _loginAsOwner(_owners[1]),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildFeatureChip('11-KPI Dashboard'),
            _buildFeatureChip('Multi-Room Management'),
            _buildFeatureChip('Instant Tenant Review'),
            _buildFeatureChip('Rent Recording & Alerts'),
            _buildFeatureChip('Host Privacy Settings'),
          ],
        ),
      ],
    );
  }

  // --- 3. Admin Login Form ---
  Widget _buildAdminLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF0284C7), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform Admin Console', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                  const Text('Platform governance, audits & approval suite', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _adminEmailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Admin Email *',
            hintText: 'admin@rentease.com',
            prefixIcon: Icon(Icons.shield_outlined, size: 20),
            border: OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _adminKeyCtrl,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Admin Security Passkey *',
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.key_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 18),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.admin_panel_settings_rounded, size: 18),
            label: const Text('Access Admin Control Center', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            onPressed: _loginAsAdmin,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('OR 1-TAP DEMO LOGIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 12),
        _buildDemoUserCard(
          name: 'Super Admin',
          role: 'Vikram Malhotra • Full 27-Module Governance',
          phone: 'admin@rentease.com',
          color: const Color(0xFF0284C7),
          onTap: _loginAsAdmin,
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildFeatureChip('27-Section Governance'),
            _buildFeatureChip('Property Approvals'),
            _buildFeatureChip('Full Customer/Owner CRUD'),
            _buildFeatureChip('Audit Trail & Financials'),
            _buildFeatureChip('CSV Export & Reports'),
          ],
        ),
      ],
    );
  }

  Widget _buildDemoUserCard({
    required String name,
    required String role,
    required String phone,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.2),
              child: Icon(Icons.bolt_rounded, size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                  Text(role, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 11, color: Color(0xFF0F766E)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }

  void _loginAsCustomer(Map<String, dynamic> customer) {
    setState(() {
      _currentCustomer = Map<String, dynamic>.from(customer);
      _currentRole = UserRole.customer;
      _currentBottomNavIndex = 0;
      _isAuthenticated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged in as Customer: ${customer['name']}'),
        backgroundColor: const Color(0xFF0F766E),
      ),
    );
  }

  void _loginAsOwner(Map<String, dynamic> owner) {
    setState(() {
      _currentRole = UserRole.owner;
      _isAuthenticated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Logged in as Property Owner: ${owner['name']}'),
        backgroundColor: const Color(0xFFD97706),
      ),
    );
  }

  void _loginAsAdmin() {
    setState(() {
      _currentRole = UserRole.admin;
      _isAuthenticated = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged in to Admin Control Center!'),
        backgroundColor: Color(0xFF0284C7),
      ),
    );
  }

  // Self-Registration for New Customer
  void _openCustomerSignupDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Varanasi');
    String type = 'Working Professional';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: const [
              Icon(Icons.person_add_rounded, color: Color(0xFF0F766E)),
              SizedBox(width: 8),
              Text('Customer Signup'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number (+91) *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Tenant Category', border: OutlineInputBorder(), isDense: true),
                  items: const [
                    DropdownMenuItem(value: 'Working Professional', child: Text('Working Professional')),
                    DropdownMenuItem(value: 'Students', child: Text('Student / Bachelor')),
                    DropdownMenuItem(value: 'Family', child: Text('Family')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged: (val) => setDialogState(() => type = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields!')));
                  return;
                }
                final newCust = {
                  'id': 'cust_${DateTime.now().millisecondsSinceEpoch}',
                  'name': nameCtrl.text.trim(),
                  'phone': phoneCtrl.text.trim(),
                  'email': emailCtrl.text.trim().isEmpty ? '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@example.com' : emailCtrl.text.trim(),
                  'city': cityCtrl.text.trim(),
                  'area': 'Urban/Rural',
                  'type': type,
                  'kyc': false,
                };
                setState(() {
                  _customers.insert(0, newCust);
                });
                Navigator.pop(ctx);
                _loginAsCustomer(newCust);
              },
              child: const Text('Register & Enter Portal'),
            ),
          ],
        ),
      ),
    );
  }

  // Self-Registration for New Landlord / Owner
  void _openOwnerSignupDialog() {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final cityCtrl = TextEditingController(text: 'Varanasi');
    final propCountCtrl = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.business_rounded, color: Color(0xFFD97706)),
            SizedBox(width: 8),
            Text('Owner / Landlord Signup'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name *', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number (+91) *', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City / Region *', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: propCountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Number of Properties *', border: OutlineInputBorder(), isDense: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty || phoneCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields!')));
                return;
              }
              final newOwner = {
                'id': 'owner_${DateTime.now().millisecondsSinceEpoch}',
                'name': nameCtrl.text.trim(),
                'phone': phoneCtrl.text.trim(),
                'email': emailCtrl.text.trim().isEmpty ? '${nameCtrl.text.toLowerCase().replaceAll(' ', '.')}@example.com' : emailCtrl.text.trim(),
                'propertiesCount': int.tryParse(propCountCtrl.text) ?? 1,
                'contactPrivacy': 'CALL_MSG_ON',
                'status': 'Active',
              };
              setState(() {
                _owners.insert(0, newOwner);
              });
              Navigator.pop(ctx);
              _loginAsOwner(newOwner);
            },
            child: const Text('Register & Enter Portal'),
          ),
        ],
      ),
    );
  }

  void _confirmLogoutDialog() {
    final roleName = _currentRole == UserRole.customer
        ? 'Customer Portal'
        : _currentRole == UserRole.owner
            ? 'Property Owner Portal'
            : 'Admin Control Center';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            SizedBox(width: 8),
            Text('Logout / Switch Role'),
          ],
        ),
        content: Text('Are you sure you want to log out from $roleName and return to the login screen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _isAuthenticated = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out. Please select a role to sign in.'),
                ),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // AUTHENTICATED PANEL SHELL
  // ===================================================================
  Widget _buildAuthenticatedPanelScaffold() {
    final unreadNotifs = _notifications.where((n) => n['isRead'] == false).length;

    String panelTitle = 'Customer Portal';
    String userSubtitle = 'Hi, ${_currentCustomer['name']}';
    IconData roleIcon = Icons.person_rounded;

    if (_currentRole == UserRole.owner) {
      panelTitle = 'Owner Portal';
      userSubtitle = 'Host: Rajesh Pandey';
      roleIcon = Icons.business_rounded;
    } else if (_currentRole == UserRole.admin) {
      panelTitle = 'Admin Control Center';
      userSubtitle = 'Super Admin (Vikram)';
      roleIcon = Icons.admin_panel_settings_rounded;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFFF59E0B)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(roleIcon, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    panelTitle,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userSubtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Theme Mode Switcher Button (Light / Dark Mode)
          ValueListenableBuilder<ThemeMode>(
            valueListenable: appThemeModeNotifier,
            builder: (ctx, mode, _) {
              final isDark = mode == ThemeMode.dark;
              return IconButton(
                tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                icon: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.amber.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? Colors.amber : Colors.white38),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: isDark ? Colors.amber : Colors.white,
                    size: 16,
                  ),
                ),
                onPressed: () {
                  appThemeModeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isDark ? 'Switched to Light Mode' : 'Switched to Dark Mode'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: const Color(0xFF0F766E),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
                if (unreadNotifs > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadNotifs',
                        style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showNotificationsSheet,
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFFCA5A5)),
            label: const Text('Logout', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFFCA5A5))),
            onPressed: _confirmLogoutDialog,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _buildCurrentRoleBody(),
      bottomNavigationBar: _currentRole == UserRole.customer
          ? NavigationBar(
              selectedIndex: _currentBottomNavIndex,
              onDestinationSelected: (idx) => setState(() => _currentBottomNavIndex = idx),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
                NavigationDestination(icon: Icon(Icons.search_rounded), label: 'Search'),
                NavigationDestination(icon: Icon(Icons.favorite_rounded), label: 'Saved'),
                NavigationDestination(icon: Icon(Icons.receipt_long_rounded), label: 'Rentals'),
                NavigationDestination(icon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
            )
          : null,
    );
  }

  Widget _buildCurrentRoleBody() {
    switch (_currentRole) {
      case UserRole.customer:
        return _buildCustomerView();
      case UserRole.owner:
        return _buildOwnerView();
      case UserRole.admin:
        return _buildAdminView();
    }
  }

  // ===================================================================
  // 1. CUSTOMER PORTAL VIEW
  // ===================================================================
  Widget _buildCustomerView() {
    switch (_currentBottomNavIndex) {
      case 0:
        return _buildCustomerHomeTab();
      case 1:
        return _buildCustomerSearchTab();
      case 2:
        return _buildCustomerSavedTab();
      case 3:
        return _buildCustomerRentalsTab();
      case 4:
        return _buildCustomerProfileTab();
      default:
        return _buildCustomerHomeTab();
    }
  }

  Widget _buildCustomerHomeTab() {
    final filtered = _getFilteredProperties();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // 1. Top Section: Hero Welcome & Search Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF115E59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find your perfect monthly rental',
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Rooms, 1/2/3 BHK, PGs & Godowns',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.verified, size: 12, color: Color(0xFF34D399)),
                        SizedBox(width: 4),
                        Text('Verified', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Urban vs Rural Area Selector
              Row(
                children: [
                  _buildAreaSegment('All Locations', 'all'),
                  const SizedBox(width: 6),
                  _buildAreaSegment('Urban Cities', 'urban'),
                  const SizedBox(width: 6),
                  _buildAreaSegment('Rural / Villages', 'rural'),
                ],
              ),
              const SizedBox(height: 10),

              // Search Bar
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search city, town, village, area or property...',
                  hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0F766E), size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 3. Search History Pills
        if (_searchHistory.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.history_rounded, size: 16, color: Color(0xFF64748B)),
                  SizedBox(width: 4),
                  Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF475569))),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _searchHistory.clear()),
                child: const Text('Clear', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _searchHistory.map((q) => Container(
                margin: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(q, style: const TextStyle(fontSize: 11)),
                  avatar: const Icon(Icons.search, size: 12, color: Color(0xFF0F766E)),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onPressed: () => setState(() => _searchQuery = q.split(' ')[0]),
                ),
              )).toList(),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // 4. Quick Property Categories Wrap
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Property Categories', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
            const Text('8 Types', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTypeChip('All Types', ''),
              _buildTypeChip('Room', 'room'),
              _buildTypeChip('1 BHK', '1bhk'),
              _buildTypeChip('2 BHK', '2bhk'),
              _buildTypeChip('3 BHK', '3bhk'),
              _buildTypeChip('Apartment', 'apartment'),
              _buildTypeChip('Flat', 'flat'),
              _buildTypeChip('House', 'house'),
              _buildTypeChip('Hostel & PG', 'hostel'),
              _buildTypeChip('Godown', 'godown'),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 5. Dedicated "Suitable For" Filter Bar (Section 6)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Suitable For / Eligibility Match',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                  if (_selectedSuitableFor.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() => _selectedSuitableFor.clear()),
                      child: const Text('Clear All', style: TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  'Students',
                  'Working Professional',
                  'Family',
                  'Couple',
                  'Boys',
                  'Girls',
                  'Single Person',
                  'Boys Hostel',
                  'Girls Hostel',
                  'PG',
                  'Other',
                ].map((tag) {
                  final isSelected = _selectedSuitableFor.contains(tag);
                  return FilterChip(
                    label: Text(tag, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : const Color(0xFF92400E))),
                    selected: isSelected,
                    selectedColor: const Color(0xFFB45309),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedSuitableFor.add(tag);
                        } else {
                          _selectedSuitableFor.remove(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 6. Section Title & Available Feed
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Available Near You (${filtered.length})',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
              child: const Text('Only Available', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),

        const SizedBox(height: 10),

        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(30),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.home_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: 8),
                const Text('No available rentals match your criteria', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Try resetting filters or adjusting budget', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedAreaType = 'all';
                      _selectedCity = '';
                      _selectedPropertyType = '';
                      _selectedSuitableFor.clear();
                      _searchQuery = '';
                      _maxRentBudget = 50000;
                    });
                  },
                  child: const Text('Reset All Filters'),
                ),
              ],
            ),
          )
        else
          ...filtered.map((item) => _buildPropertyCard(item['property'], item['room'])),
      ],
    );
  }

  Widget _buildAreaSegment(String label, String value) {
    final isSelected = _selectedAreaType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedAreaType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF0F766E) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, String value) {
    final isSelected = _selectedPropertyType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPropertyType = value),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFCCFBF1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF0F766E) : const Color(0xFFE2E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF334155),
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // PROPERTY CARD RENDERER
  // ===================================================================
  Widget _buildPropertyCard(Map<String, dynamic> property, Map<String, dynamic> room) {
    final propRoomKey = '${property['id']}_${room['id']}';
    final isSaved = _savedPropertyIds.contains(propRoomKey);
    final isRented = room['status'] == 'Rented';
    final suitableTags = List<String>.from(room['suitableFor'] ?? []);
    final imagesList = (property['images'] is List && (property['images'] as List).isNotEmpty)
        ? List<String>.from(property['images'])
        : [property['image']?.toString() ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: _isDark ? 0.35 : 0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Banner
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: Image.network(
                  imagesList.first,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: _subtleBg,
                    child: const Center(
                      child: Icon(Icons.apartment_rounded, size: 36, color: Color(0xFF0F766E)),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isRented ? const Color(0xFFDC2626) : const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isRented ? 'CURRENTLY RENTED' : 'AVAILABLE',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                ),
              ),
              if (imagesList.length > 1)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo_library_rounded, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${imagesList.length} Photos',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSaved) {
                        _savedPropertyIds.remove(propRoomKey);
                      } else {
                        _savedPropertyIds.add(propRoomKey);
                      }
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    radius: 16,
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isSaved ? Colors.red : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: _textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${property['locality']}, ${property['city']} · ${property['areaType'].toString().toUpperCase()}',
                        style: TextStyle(fontSize: 12, color: _textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(' ${property['rating']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _textPrimary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  property['title'],
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: _textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _buildPill('${room['roomNumber']}'),
                    _buildPill('${room['size']}'),
                    _buildPill('${room['furnishing']}'),
                  ],
                ),
                const SizedBox(height: 10),

                // Suitable for highlight
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _subtleBg,
                    borderRadius: BorderRadius.circular(8),
                    border: const Border(left: BorderSide(color: Color(0xFFF59E0B), width: 3)),
                  ),
                  child: Row(
                    children: [
                      const Text('Suitable For: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B))),
                      Expanded(
                        child: Text(
                          suitableTags.join(' · '),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Pricing and CTA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '₹${room['monthlyRent']} / mo',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: _isDark ? const Color(0xFF14B8A6) : const Color(0xFF0F766E),
                            ),
                          ),
                          Text(
                            'Deposit: ₹${room['securityDeposit']}',
                            style: TextStyle(fontSize: 10, color: _textSecondary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F766E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () => _openPropertyDetails(property, room),
                      child: const Text('View Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _subtleBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _borderColor),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _textSecondary)),
    );
  }

  // ===================================================================
  // 2. ADVANCED SEARCH & FILTERS TAB
  // ===================================================================
  Widget _buildCustomerSearchTab() {
    final filtered = _getFilteredProperties();

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Advanced Search & Filters', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17)),
            GestureDetector(
              onTap: () {
                setState(() {
                  _maxRentBudget = 50000;
                  _selectedFurnishing = 'All';
                  _selectedPropertyType = '';
                  _selectedAreaType = 'all';
                  _selectedSuitableFor.clear();
                  _onlyAvailable = true;
                });
              },
              child: const Text('Reset All', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Filter Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Max Monthly Rent Budget', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('₹${_maxRentBudget.toInt()}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15, color: const Color(0xFF0F766E))),
                ],
              ),
              Slider(
                value: _maxRentBudget,
                min: 3000,
                max: 60000,
                divisions: 57,
                activeColor: const Color(0xFF0F766E),
                onChanged: (val) => setState(() => _maxRentBudget = val),
              ),
              const Divider(),

              // Furnishing Dropdown
              const Text('Furnishing Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedFurnishing,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                items: const [
                  DropdownMenuItem(value: 'All', child: Text('Any Furnishing')),
                  DropdownMenuItem(value: 'Furnished', child: Text('Fully Furnished')),
                  DropdownMenuItem(value: 'Semi', child: Text('Semi-Furnished')),
                  DropdownMenuItem(value: 'Unfurnished', child: Text('Unfurnished')),
                ],
                onChanged: (val) => setState(() => _selectedFurnishing = val!),
              ),

              const SizedBox(height: 12),

              // Only Available Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Show Only Available Units', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Hide rented or reserved listings', style: TextStyle(fontSize: 10, color: Colors.grey)),
                value: _onlyAvailable,
                activeThumbColor: const Color(0xFF0F766E),
                onChanged: (val) => setState(() => _onlyAvailable = val),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        Text('Matching Results (${filtered.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 10),

        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text('No properties match current filters.'),
          )
        else
          ...filtered.map((item) => _buildPropertyCard(item['property'], item['room'])),
      ],
    );
  }

  // ===================================================================
  // 3. SAVED / WISHLIST TAB
  // ===================================================================
  Widget _buildCustomerSavedTab() {
    List<Map<String, dynamic>> savedList = [];
    for (var prop in _properties) {
      for (var room in prop['rooms']) {
        final key = '${prop['id']}_${room['id']}';
        if (_savedPropertyIds.contains(key)) {
          savedList.add({'property': prop, 'room': room});
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saved Properties (${savedList.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
            if (savedList.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _savedPropertyIds.clear()),
                child: const Text('Clear All', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 10),

        if (savedList.isEmpty)
          Container(
            padding: const EdgeInsets.all(40),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const Icon(Icons.favorite_border, size: 48, color: Colors.grey),
                const SizedBox(height: 10),
                const Text('No saved properties yet', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('Tap heart icon on any property to bookmark it', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => setState(() => _currentBottomNavIndex = 0),
                  child: const Text('Explore Available Properties'),
                ),
              ],
            ),
          )
        else
          ...savedList.map((item) => _buildPropertyCard(item['property'], item['room'])),
      ],
    );
  }

  // ===================================================================
  // 4. CUSTOMER RENTALS & MONTHLY RENT TAB (Section 13, 17, 18, 19, 20, 21, 22)
  // ===================================================================
  Widget _buildCustomerRentalsTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Active Rental Hero Section
        Text('Active Monthly Rental', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),

        if (_activeRentals.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: const Text('No active rental agreement found.'),
          )
        else
          ..._activeRentals.map((rental) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          rental['propertyTitle'],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFF59E0B), borderRadius: BorderRadius.circular(12)),
                        child: Text('Due on ${rental['dueDay']}th', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                    ],
                  ),
                  Text('${rental['roomNumber']} · ${rental['address']}', style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: _buildWhiteStat('Monthly Rent', '₹${rental['monthlyRent']}')),
                      Expanded(child: _buildWhiteStat('Security Deposit', '₹${rental['securityDeposit']}')),
                      Expanded(child: _buildWhiteStat('Status', 'Active Lease')),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                          onPressed: () => _openPayRentDialog(rental),
                          child: Text('Pay Rent (₹${rental['monthlyRent']})'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
                        onPressed: () => _openRecordCashDialog(rental),
                        child: const Text('Cash Record'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 20),

        // Rental Requests Status & Pipeline Tracker (Section 13)
        Text('Rental Requests & Pipeline Tracker', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        if (_rentalRequests.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text('No pending rental requests.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          )
        else
          ..._rentalRequests.map((req) {
            final isAccepted = req['status'] == 'Owner Accepted';
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${req['propertyTitle']} (${req['roomNumber']})',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isAccepted ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          req['status'],
                          style: TextStyle(color: isAccepted ? const Color(0xFF059669) : const Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Move-in Date: ${req['moveInDate']} · Tenure: ${req['durationMonths']} Months', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  const SizedBox(height: 8),

                  // Visual Progress Pipeline (Request Sent -> Owner Accepted -> Terms Confirmed -> Verification -> Agreement Completed)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildStepIndicator('1. Request Sent', true),
                          const Icon(Icons.arrow_forward, size: 10, color: Colors.grey),
                          _buildStepIndicator('2. Owner Accepted', isAccepted),
                          const Icon(Icons.arrow_forward, size: 10, color: Colors.grey),
                          _buildStepIndicator('3. Terms Confirmed', req['termsConfirmed'] == true),
                          const Icon(Icons.arrow_forward, size: 10, color: Colors.grey),
                          _buildStepIndicator('4. Aadhaar KYC & Agreement', false),
                        ],
                      ),
                    ),
                  ),

                  if (isAccepted && req['termsConfirmed'] != true) ...[
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                      onPressed: () => _openFinalTermsConfirmationDialog(req),
                      child: const Text('Review Final Terms & Sign Agreement'),
                    ),
                  ],
                ],
              ),
            );
          }),

        const SizedBox(height: 20),

        // Month-Wise Payment History (Section 21 & 22)
        Text('Month-Wise Rent History', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),

        ..._rentPayments.map((p) {
          final isPaid = p['status'] == 'Paid';
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['month'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        isPaid ? 'Paid via ${p['mode']} (${p['paymentDate']})' : 'Due on ${p['dueDate']}',
                        style: TextStyle(fontSize: 11, color: isPaid ? Colors.green : Colors.orange),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹${p['amount']}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(width: 8),
                    if (isPaid)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE0F2FE),
                          foregroundColor: const Color(0xFF0284C7),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                        ),
                        onPressed: () => _openReceiptDialog(p),
                        child: const Text('Receipt', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ],
            ),
          );
        }),

        const SizedBox(height: 20),

        // Past Rental History (Section 26)
        Text('My Rental History', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ..._pastRentals.map((past) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(past['propertyTitle'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${past['roomNumber']} · ${past['duration']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                child: const Text('Completed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildStepIndicator(String title, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(active ? Icons.check_circle : Icons.radio_button_unchecked, size: 12, color: active ? const Color(0xFF059669) : Colors.grey),
          const SizedBox(width: 4),
          Text(title, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.bold : FontWeight.normal, color: active ? const Color(0xFF059669) : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildWhiteStat(String label, String val) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
      ],
    );
  }

  // ===================================================================
  // 5. CUSTOMER PROFILE TAB (Section 25 & 28)
  // ===================================================================
  Widget _buildCustomerProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Profile Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Row(
            children: [
              const CircleAvatar(radius: 28, backgroundColor: Color(0xFF0F766E), child: Icon(Icons.person, size: 30, color: Colors.white)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_currentCustomer['name'], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17)),
                    Text('+91 ${_currentCustomer['phone']} · ${_currentCustomer['email']}', style: const TextStyle(fontSize: 11, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(4)),
                          child: const Text('Aadhaar KYC Verified', style: TextStyle(fontSize: 9, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                        ),
                        Text(_currentCustomer['city'], style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF0284C7)),
                onPressed: _openEditProfileDialog,
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Helpdesk & Complaints (Section 28)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Complaints & Support Desk', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
                  ElevatedButton.icon(
                    onPressed: _openRaiseComplaintDialog,
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Raise Ticket', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C), foregroundColor: Colors.white, minimumSize: const Size(80, 30)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._complaints.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(c['subject'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: c['status'] == 'Resolved' ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
                          child: Text(c['status'], style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: c['status'] == 'Resolved' ? const Color(0xFF059669) : const Color(0xFFD97706))),
                        ),
                      ],
                    ),
                    Text('Category: ${c['category']} · Date: ${c['date'] ?? 'Recent'}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    if (c['adminReply'] != null) ...[
                      const SizedBox(height: 4),
                      Text('Admin Reply: ${c['adminReply']}', style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                    ],
                  ],
                ),
              )),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Profile Menu Items
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFF0F766E)),
                title: const Text('Rent Reminders & Alerts', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showNotificationsSheet,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.security_outlined, color: Color(0xFF0284C7)),
                title: const Text('Privacy & Access Controls', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Secure Customer role-based access active.')));
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout / Switch Role', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.red)),
                onTap: _confirmLogoutDialog,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===================================================================
  // PROPERTY DETAILS MODAL (Sections 9 & 10)
  // ===================================================================
  void _openPropertyDetails(Map<String, dynamic> property, Map<String, dynamic> room) {
    final isRented = room['status'] == 'Rented';
    final imagesList = (property['images'] is List && (property['images'] as List).isNotEmpty)
        ? List<String>.from(property['images'])
        : [property['image']?.toString() ?? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'];
    int activePhotoIdx = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setGalleryState) => Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      property['title'],
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                ],
              ),
              const SizedBox(height: 10),

              // Interactive Gallery Carousel
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imagesList[activePhotoIdx],
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                          child: Icon(Icons.apartment_rounded, size: 44, color: Color(0xFF0F766E)),
                        ),
                      ),
                    ),
                  ),
                  // Photo counter badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo_camera_rounded, size: 12, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            'Photo ${activePhotoIdx + 1} of ${imagesList.length}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Room & status badge
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F766E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        '${room['roomNumber']} (${room['roomType']})',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ),
                  // Navigation arrows
                  if (imagesList.length > 1) ...[
                    Positioned(
                      left: 8,
                      top: 88,
                      child: GestureDetector(
                        onTap: () {
                          setGalleryState(() {
                            activePhotoIdx = (activePhotoIdx - 1 + imagesList.length) % imagesList.length;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F766E), size: 22),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 88,
                      child: GestureDetector(
                        onTap: () {
                          setGalleryState(() {
                            activePhotoIdx = (activePhotoIdx + 1) % imagesList.length;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          radius: 16,
                          child: const Icon(Icons.chevron_right_rounded, color: Color(0xFF0F766E), size: 22),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Thumbnail strip
              if (imagesList.length > 1) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 54,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagesList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, idx) {
                      final isCurrent = idx == activePhotoIdx;
                      return GestureDetector(
                        onTap: () => setGalleryState(() => activePhotoIdx = idx),
                        child: Container(
                          width: 70,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isCurrent ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1),
                              width: isCurrent ? 2.5 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imagesList[idx],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFF1F5F9),
                                child: const Icon(Icons.broken_image, size: 16, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),

            // Rent & Deposit Highlight
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Monthly Rent', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('₹${room['monthlyRent']} / month', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F766E))),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Security Deposit', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('₹${room['securityDeposit']}', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),
            Text('Location & Address', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${property['address']} (${property['areaType'].toString().toUpperCase()})', style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 14),
            Text('Electricity & Maintenance', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
            Text('${property['electricityInfo']}', style: const TextStyle(fontSize: 12)),
            Text('${property['maintenanceInfo']}', style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 14),
            // Suitable For Checklist
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Eligible Customer Types (Suitable For):', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: (room['suitableFor'] as List).map<Widget>((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Text('$s', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                    )).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Owner Contact Buttons (Obeying Host Privacy Rules - Section 10)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Host: ${property['ownerName']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text('Privacy Protected', style: TextStyle(color: Color(0xFF0284C7), fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (_ownerContactPrivacy.contains('CALL_ON') || _ownerContactPrivacy == 'CALL_MSG_ON')
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                            icon: const Icon(Icons.phone, size: 16),
                            label: const Text('Call Host', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling host ${property['ownerPhone']}...')));
                            },
                          ),
                        )
                      else
                        const Expanded(
                          child: Text('Calls disabled by host', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ),
                      const SizedBox(width: 8),
                      if (_ownerContactPrivacy.contains('MSG_ON') || _ownerContactPrivacy == 'CALL_MSG_ON')
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                            icon: const Icon(Icons.message, size: 16),
                            label: const Text('Message Host', style: TextStyle(fontSize: 12)),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chat window opened with host.')));
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Main Request for Rent CTA
            if (isRented)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: null,
                child: const Text('Currently Rented (Unavailable)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F766E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _openRentalRequestDialog(property, room);
                },
                child: const Text('Request for Monthly Rent', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    ),
  );
}

  // ===================================================================
  // RENTAL REQUEST MODAL (Section 12)
  // ===================================================================
  void _openRentalRequestDialog(Map<String, dynamic> property, Map<String, dynamic> room) {
    final moveInCtrl = TextEditingController(text: '2026-10-15');
    final durationCtrl = TextEditingController(text: '11');
    final notesCtrl = TextEditingController(text: 'Looking for a peaceful stay.');
    String customerType = _currentCustomer['type'] ?? 'Working Professional';
    String durationType = 'month'; // 'month' | 'day' | 'hour'
    final baseMonthly = int.tryParse(room['monthlyRent'].toString()) ?? 9000;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final durVal = int.tryParse(durationCtrl.text) ?? 1;
          final calcTotal = durationType == 'hour'
              ? (((baseMonthly / (30 * 6)).round()).clamp(50, 500) * durVal)
              : (durationType == 'day' ? ((baseMonthly / 30).round() * durVal) : (baseMonthly * durVal));
          final calcDeposit = durationType == 'hour'
              ? 0
              : (durationType == 'day' ? (baseMonthly / 30).round() : (baseMonthly * 2));

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text('Book Room / Send Rental Request', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${property['title']} (${room['roomNumber']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                    Text('Base Monthly Rate: ₹$baseMonthly/mo', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 12),

                    // Booking Duration Type (Month / Day / Hour)
                    const Text('Select Duration Type *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setDialogState(() {
                              durationType = 'month';
                              durationCtrl.text = '11';
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: durationType == 'month' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: durationType == 'month' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month_rounded, size: 14, color: durationType == 'month' ? Colors.white : const Color(0xFF0F766E)),
                                  const SizedBox(width: 4),
                                  Text('Month', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: durationType == 'month' ? Colors.white : const Color(0xFF334155))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: InkWell(
                            onTap: () => setDialogState(() {
                              durationType = 'day';
                              durationCtrl.text = '3';
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: durationType == 'day' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: durationType == 'day' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wb_sunny_rounded, size: 14, color: durationType == 'day' ? Colors.white : const Color(0xFFF59E0B)),
                                  const SizedBox(width: 4),
                                  Text('Day', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: durationType == 'day' ? Colors.white : const Color(0xFF334155))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: InkWell(
                            onTap: () => setDialogState(() {
                              durationType = 'hour';
                              durationCtrl.text = '4';
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: durationType == 'hour' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: durationType == 'hour' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.access_time_rounded, size: 14, color: durationType == 'hour' ? Colors.white : const Color(0xFF0284C7)),
                                  const SizedBox(width: 4),
                                  Text('Hour', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: durationType == 'hour' ? Colors.white : const Color(0xFF334155))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Quick Chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (durationType == 'month')
                          for (int m in [1, 2, 3, 6, 11, 12])
                            InkWell(
                              onTap: () => setDialogState(() => durationCtrl.text = m.toString()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (int.tryParse(durationCtrl.text) == m) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: (int.tryParse(durationCtrl.text) == m) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Text('$m Mo', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: (int.tryParse(durationCtrl.text) == m) ? Colors.white : const Color(0xFF334155))),
                              ),
                            ),
                        if (durationType == 'day')
                          for (int d in [1, 2, 3, 5, 7, 15, 30])
                            InkWell(
                              onTap: () => setDialogState(() => durationCtrl.text = d.toString()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (int.tryParse(durationCtrl.text) == d) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: (int.tryParse(durationCtrl.text) == d) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Text('$d Days', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: (int.tryParse(durationCtrl.text) == d) ? Colors.white : const Color(0xFF334155))),
                              ),
                            ),
                        if (durationType == 'hour')
                          for (int h in [1, 2, 3, 4, 6, 8, 12, 24])
                            InkWell(
                              onTap: () => setDialogState(() => durationCtrl.text = h.toString()),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (int.tryParse(durationCtrl.text) == h) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: (int.tryParse(durationCtrl.text) == h) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Text('$h Hrs', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: (int.tryParse(durationCtrl.text) == h) ? Colors.white : const Color(0xFF334155))),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: durationCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: durationType == 'month' ? 'Months' : (durationType == 'day' ? 'Days' : 'Hours'), border: const OutlineInputBorder(), isDense: true),
                            onChanged: (val) => setDialogState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: moveInCtrl,
                            decoration: InputDecoration(labelText: durationType == 'hour' ? 'Booking Date' : 'Move-in Date', border: const OutlineInputBorder(), isDense: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesCtrl,
                      decoration: const InputDecoration(labelText: 'Requirements / Notes for Host', border: OutlineInputBorder(), isDense: true),
                    ),
                    const SizedBox(height: 10),

                    // Price summary calculation
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF99F6E4)),
                      ),
                      child: Row(
                        children: [
                          Icon(durationType == 'hour' ? Icons.timer_rounded : (durationType == 'day' ? Icons.wb_sunny_rounded : Icons.calendar_month_rounded), size: 16, color: const Color(0xFF0F766E)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Total Amount: ₹$calcTotal · Deposit: ₹$calcDeposit',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.pop(ctx);
                  final finalDur = int.tryParse(durationCtrl.text) ?? 1;
                  final newReq = {
                    'id': 'req_${DateTime.now().millisecondsSinceEpoch}',
                    'customerId': _currentCustomer['id'],
                    'customerName': _currentCustomer['name'],
                    'customerPhone': _currentCustomer['phone'],
                    'customerType': customerType,
                    'propertyId': property['id'],
                    'roomId': room['id'],
                    'propertyTitle': property['title'],
                    'roomNumber': room['roomNumber'],
                    'bookingDurationType': durationType,
                    'bookingDurationValue': finalDur,
                    'monthlyRent': calcTotal,
                    'securityDeposit': calcDeposit,
                    'moveInDate': moveInCtrl.text.trim(),
                    'durationMonths': durationType == 'month' ? finalDur : 1,
                    'status': 'Owner Accepted',
                    'termsConfirmed': false,
                    'notes': notesCtrl.text.trim(),
                  };
                  setState(() {
                    _rentalRequests.insert(0, newReq);
                    _notifications.insert(0, {
                      'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
                      'title': 'Rental Request Sent',
                      'message': 'Rental request for ${property['title']} (${durationType == 'hour' ? '$finalDur Hours' : (durationType == 'day' ? '$finalDur Days' : '$finalDur Months')}) sent to host.',
                      'time': 'Just now',
                      'isRead': false,
                      'isReminder': false,
                    });
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Rental request submitted for ${durationType == 'hour' ? '$finalDur Hours' : (durationType == 'day' ? '$finalDur Days' : '$finalDur Months')}!')),
                  );
                  setState(() => _currentBottomNavIndex = 3);
                },
                child: const Text('Send Rental Request'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===================================================================
  // FINAL TERMS CONFIRMATION (Section 15)
  // ===================================================================
  void _openFinalTermsConfirmationDialog(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Final Rental Terms Confirmation', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property: ${request['propertyTitle']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Unit: ${request['roomNumber']}'),
              const Divider(),
              Text('Monthly Rent: ₹${request['monthlyRent']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              Text('Security Deposit: ₹${request['securityDeposit']}'),
              Text('Move-in Date: ${request['moveInDate']}'),
              Text('Tenure: ${request['durationMonths']} Months'),
              Text('Tenant Category: ${request['customerType']}'),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: const Text('Standard 11-month lock-in period with 1 month notice for termination.', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Request Changes')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => request['termsConfirmed'] = true);
              _openAadhaarKYCDialog(request);
            },
            child: const Text('Confirm Terms & Proceed to KYC'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // AADHAAR E-KYC & AGREEMENT EXECUTION (Section 16)
  // ===================================================================
  void _openAadhaarKYCDialog(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Aadhaar e-KYC & Agreement', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('UIDAI Digital Tenancy Agreement Signing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E))),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                labelText: '12-Digit Aadhaar Number',
                hintText: '5482 9102 4512',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: 'UIDAI OTP (Test OTP: 123456)',
                hintText: '123456',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            const Text('I consent to UIDAI e-KYC and digital signing of tenancy contract.', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              // Transition status to Rented
              for (var prop in _properties) {
                if (prop['id'] == request['propertyId']) {
                  for (var r in prop['rooms']) {
                    if (r['id'] == request['roomId']) {
                      r['status'] = 'Rented';
                    }
                  }
                }
              }

              setState(() {
                request['status'] = 'Agreement Completed';
                _activeRentals.insert(0, {
                  'id': 'rent_${DateTime.now().millisecondsSinceEpoch}',
                  'customerId': _currentCustomer['id'],
                  'customerName': _currentCustomer['name'],
                  'propertyId': request['propertyId'],
                  'roomId': request['roomId'],
                  'propertyTitle': request['propertyTitle'],
                  'roomNumber': request['roomNumber'],
                  'address': 'Verified City Address',
                  'monthlyRent': request['monthlyRent'],
                  'securityDeposit': request['securityDeposit'],
                  'startDate': '2026-10-01',
                  'dueDay': 5,
                  'status': 'Active',
                  'agreementStatus': 'Countersigned & Legally Binding',
                  'isCurrentMonthPaid': false,
                });
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agreement Signed & Property Rented! Welcome to your new home.')),
              );
            },
            child: const Text('Sign & Activate'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // MONTHLY RENT PAYMENT MODAL (Sections 19 & 20)
  // ===================================================================
  void _openPayRentDialog(Map<String, dynamic> rental) {
    String paymentMode = 'UPI';
    final refCtrl = TextEditingController(text: 'UPI-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Pay Monthly Rent', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Property: ${rental['propertyTitle']} (${rental['roomNumber']})', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text('Monthly Rent: ₹${rental['monthlyRent']}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: paymentMode,
                  decoration: const InputDecoration(labelText: 'Payment Mode', border: OutlineInputBorder(), isDense: true),
                  items: const [
                    DropdownMenuItem(value: 'UPI', child: Text('UPI (GPay / PhonePe / Paytm)')),
                    DropdownMenuItem(value: 'Online', child: Text('Online (Debit / Credit Card)')),
                    DropdownMenuItem(value: 'Bank Transfer', child: Text('Bank Transfer (NEFT / IMPS)')),
                    DropdownMenuItem(value: 'Cash', child: Text('Cash Handover')),
                  ],
                  onChanged: (val) {
                    setModalState(() {
                      paymentMode = val!;
                      if (paymentMode == 'UPI') {
                        refCtrl.text = 'UPI-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
                      } else if (paymentMode == 'Bank Transfer') {
                        refCtrl.text = 'NEFT-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}';
                      } else if (paymentMode == 'Cash') {
                        refCtrl.text = 'CASH-REC-${DateTime.now().millisecond}';
                      } else {
                        refCtrl.text = 'TXN-CARD-${DateTime.now().millisecond}';
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: refCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Transaction / Reference Number',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
              onPressed: () {
                final refVal = refCtrl.text.trim();
                setState(() {
                  _rentPayments.insert(0, {
                    'id': 'pay_${DateTime.now().millisecondsSinceEpoch}',
                    'rentalId': rental['id'],
                    'month': 'October 2026',
                    'amount': rental['monthlyRent'],
                    'dueDate': '2026-10-05',
                    'paymentDate': '2026-10-01',
                    'mode': paymentMode,
                    'status': 'Paid',
                    'txnRef': refVal.isEmpty ? 'TXN-AUTO' : refVal,
                    'receiptNo': 'REC-2026-10-${DateTime.now().millisecond}',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Rent Paid via $paymentMode! Digital Receipt #REC-2026-10 Generated.'),
                ));
              },
              child: const Text('Confirm & Record'),
            ),
          ],
        ),
      ),
    );
  }

  void _openRecordCashDialog(Map<String, dynamic> rental) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Record Cash Payment', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Text('Record ₹${rental['monthlyRent']} handed over in cash to host.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                _rentPayments.insert(0, {
                  'id': 'pay_${DateTime.now().millisecondsSinceEpoch}',
                  'rentalId': rental['id'],
                  'month': 'October 2026',
                  'amount': rental['monthlyRent'],
                  'dueDate': '2026-10-05',
                  'paymentDate': '2026-10-01',
                  'mode': 'Cash',
                  'status': 'Paid',
                  'txnRef': 'CASH-REC-${DateTime.now().millisecond}',
                  'receiptNo': 'REC-2026-10-${DateTime.now().millisecond}',
                });
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cash payment recorded!')));
            },
            child: const Text('Confirm Cash'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // DIGITAL RENT RECEIPT (Section 22)
  // ===================================================================
  void _openReceiptDialog(Map<String, dynamic> payment) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Rent Payment Receipt', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Receipt No: ${payment['receiptNo'] ?? 'REC-2026-10-101'}', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Rent Month: ${payment['month']}', style: const TextStyle(fontSize: 13)),
            Text('Amount Paid: ₹${payment['amount']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
            Text('Mode: ${payment['mode']} · Ref: ${payment['txnRef']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(8)),
              child: const Text('UIDAI Verified & Ledger Recorded', style: TextStyle(color: Color(0xFF065F46), fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rent Receipt downloaded / printed.')));
            },
            child: const Text('Download / Print PDF'),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  // ===================================================================
  // COMPLAINTS & HELPDESK (Section 28)
  // ===================================================================
  void _openRaiseComplaintDialog() {
    String category = 'Property Issue';
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text('Raise Maintenance / Support Ticket', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category *', border: OutlineInputBorder(), isDense: true),
                  items: const [
                    DropdownMenuItem(value: 'Property Issue', child: Text('Property / Repair Issue')),
                    DropdownMenuItem(value: 'Owner Issue', child: Text('Host / Owner Dispute')),
                    DropdownMenuItem(value: 'Payment Issue', child: Text('Payment / Ledger Dispute')),
                    DropdownMenuItem(value: 'Agreement Issue', child: Text('Agreement / Terms Issue')),
                    DropdownMenuItem(value: 'Rent Issue', child: Text('Rent Overcharge Issue')),
                    DropdownMenuItem(value: 'App Issue', child: Text('Application Technical Issue')),
                    DropdownMenuItem(value: 'Other', child: Text('Other Support Query')),
                  ],
                  onChanged: (val) => setModalState(() => category = val!),
                ),
                const SizedBox(height: 10),
                TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Subject *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Describe the issue...', border: OutlineInputBorder(), isDense: true)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEA580C), foregroundColor: Colors.white),
              onPressed: () {
                if (subjectCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                setState(() {
                  _complaints.insert(0, {
                    'id': 'comp_${DateTime.now().millisecondsSinceEpoch}',
                    'user': _currentCustomer['name'],
                    'category': category,
                    'subject': subjectCtrl.text.trim(),
                    'desc': descCtrl.text.trim(),
                    'status': 'In Review',
                    'adminReply': 'Admin is evaluating your ticket.',
                    'date': '2026-10-01',
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support ticket submitted. Admin notified!')),
                );
              },
              child: const Text('Submit Ticket'),
            ),
          ],
        ),
      ),
    );
  }

  // Edit Profile Dialog
  void _openEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _currentCustomer['name']);
    final phoneCtrl = TextEditingController(text: _currentCustomer['phone']);
    final emailCtrl = TextEditingController(text: _currentCustomer['email']);
    final cityCtrl = TextEditingController(text: _currentCustomer['city']);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Customer Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(), isDense: true)),
              const SizedBox(height: 10),
              TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City / Area', border: OutlineInputBorder(), isDense: true)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentCustomer['name'] = nameCtrl.text.trim();
                _currentCustomer['phone'] = phoneCtrl.text.trim();
                _currentCustomer['email'] = emailCtrl.text.trim();
                _currentCustomer['city'] = cityCtrl.text.trim();
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }





  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.alarm_on_rounded, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('Rent Reminders & Alerts', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      for (var n in _notifications) {
                        n['isRead'] = true;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Mark All Read', style: TextStyle(fontSize: 11, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._notifications.map((n) => ListTile(
              leading: Icon(n['isReminder'] == true ? Icons.alarm : Icons.notifications, color: Colors.orange),
              title: Text(n['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: Text(n['message'], style: const TextStyle(fontSize: 11)),
            )),
          ],
        ),
      ),
    ),
  );
}

  // ===================================================================
  // 2. PROPERTY OWNER VIEW (Complete 33-Section Suite)
  // ===================================================================
  Widget _buildOwnerView() {
    int totalRooms = 0;
    int availableRooms = 0;
    int rentedRooms = 0;
    int expectedMonthlyRent = 0;
    int collectedRent = 0;

    for (var prop in _properties) {
      for (var r in prop['rooms']) {
        totalRooms++;
        expectedMonthlyRent += (r['monthlyRent'] as num).toInt();
        if (r['status'] == 'Available') {
          availableRooms++;
        } else if (r['status'] == 'Rented') {
          rentedRooms++;
        }
      }
    }

    for (var p in _rentPayments) {
      if (p['status'] == 'Paid') {
        collectedRent += (p['amount'] as num).toInt();
      }
    }

    final pendingRent = expectedMonthlyRent > collectedRent ? (expectedMonthlyRent - collectedRent) : 0;
    final collectionPercent = expectedMonthlyRent > 0 ? (collectedRent / expectedMonthlyRent).clamp(0.0, 1.0) : 0.0;
    final occupancyPercent = totalRooms > 0 ? (rentedRooms / totalRooms).clamp(0.0, 1.0) : 0.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // 1. Executive Host Profile & Welcome Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.verified_user, color: Color(0xFF10B981), size: 14),
                            SizedBox(width: 4),
                            Text('Verified Landlord & Host', style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rajesh Pandey',
                          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '4.8 Rating · ${_properties.length} Properties Managed ($totalRooms Units)',
                          style: const TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF0F766E), borderRadius: BorderRadius.circular(12)),
                    child: Text('Privacy: $_ownerContactPrivacy', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Quick action buttons row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      icon: const Icon(Icons.add_home_work_rounded, size: 14),
                      label: const Text('Add Property', style: TextStyle(fontSize: 11)),
                      onPressed: () => _openPropertyFormDialog(),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      icon: const Icon(Icons.payment_rounded, size: 14),
                      label: const Text('Record Rent', style: TextStyle(fontSize: 11)),
                      onPressed: () {
                        if (_activeRentals.isNotEmpty) {
                          _openPayRentDialog(_activeRentals[0]);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active lease to record payment.')));
                        }
                      },
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
                      icon: const Icon(Icons.assessment_rounded, size: 14),
                      label: const Text('Reports', style: TextStyle(fontSize: 11)),
                      onPressed: _openOwnerReportsDialog,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // 2. 11-KPI Metrics Dashboard Grid (All 8 Cards Clickable & Interactive)
        Row(
          children: [
            Expanded(
              child: _buildOwnerKpiCard(
                'Total Props',
                '${_properties.length}',
                Icons.apartment_rounded,
                const Color(0xFF0F766E),
                onTap: () => _showOwnerPropertiesSheet(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Total Units',
                '$totalRooms',
                Icons.meeting_room_rounded,
                const Color(0xFF0284C7),
                onTap: () => _showOwnerUnitsSheet(totalRooms, availableRooms, rentedRooms),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Available',
                '$availableRooms',
                Icons.check_circle_outline,
                const Color(0xFF059669),
                onTap: () {
                  setState(() {
                    _ownerRoomFilter = 'AVAILABLE';
                    _expandedPropertyIds.addAll(_properties.map((e) => e['id'].toString()));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filtered to $availableRooms Available Units!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFF059669),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Rented',
                '$rentedRooms',
                Icons.vpn_key_rounded,
                const Color(0xFFD97706),
                onTap: () {
                  setState(() {
                    _ownerRoomFilter = 'RENTED';
                    _expandedPropertyIds.addAll(_properties.map((e) => e['id'].toString()));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Filtered to $rentedRooms Rented Units!'),
                      duration: const Duration(seconds: 2),
                      backgroundColor: const Color(0xFFD97706),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildOwnerKpiCard(
                'Inquiries',
                '${_rentalRequests.length}',
                Icons.inbox_rounded,
                const Color(0xFF7C3AED),
                onTap: () => _showOwnerInquiriesSheet(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Expected Rent',
                '₹${(expectedMonthlyRent / 1000).toStringAsFixed(1)}k',
                Icons.currency_rupee,
                const Color(0xFF0F172A),
                onTap: () => _showExpectedRentSheet(expectedMonthlyRent),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Collected',
                '₹${(collectedRent / 1000).toStringAsFixed(1)}k',
                Icons.account_balance_wallet,
                const Color(0xFF10B981),
                onTap: () => _showCollectedRentSheet(collectedRent),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildOwnerKpiCard(
                'Pending',
                '₹${(pendingRent / 1000).toStringAsFixed(1)}k',
                Icons.hourglass_bottom,
                const Color(0xFFEA580C),
                onTap: () => _showPendingRentSheet(pendingRent),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        // 3. Collection & Occupancy Visual Progress Meters
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Monthly Rent Collection Progress', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('₹$collectedRent / ₹$expectedMonthlyRent (${(collectionPercent * 100).toInt()}%)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: collectionPercent, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)), minHeight: 6),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Property Occupancy Ratio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('$rentedRooms / $totalRooms Units Rented (${(occupancyPercent * 100).toInt()}%)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: occupancyPercent, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0284C7)), minHeight: 6),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 4. Tenant Inquiries & Suitability Checker Section (Section 11, 12, 13)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.inbox_rounded, color: Color(0xFF7C3AED), size: 18),
                const SizedBox(width: 6),
                Text('Tenant Rental Inquiries (${_rentalRequests.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)),
              child: const Text('Auto Suitability Check', style: TextStyle(fontSize: 9, color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_rentalRequests.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text('No pending inquiries from customers.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          )
        else
          ..._rentalRequests.map((req) {
            // Find property and room to verify customer eligibility
            bool isEligible = true;
            for (var p in _properties) {
              if (p['id'] == req['propertyId']) {
                for (var r in p['rooms']) {
                  if (r['id'] == req['roomId']) {
                    final suitableList = List<String>.from(r['suitableFor'] ?? []);
                    isEligible = suitableList.contains(req['customerType']);
                  }
                }
              }
            }

            final isAccepted = req['status'] == 'Owner Accepted' || req['status'] == 'Agreement Completed';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isAccepted ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(req['customerName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('+91 ${req['customerPhone']} · Category: ${req['customerType']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isAccepted ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          req['status'],
                          style: TextStyle(color: isAccepted ? const Color(0xFF059669) : const Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Property: ${req['propertyTitle']} (${req['roomNumber']})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Move-in: ${req['moveInDate']} · Duration: ${req['durationMonths']} Months · Rent: ₹${req['monthlyRent']}/mo', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                  if (req['notes'] != null && req['notes'].toString().isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
                      child: Text('Tenant Note: "${req['notes']}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Customer Suitability Check Badge (Section 12)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isEligible ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: isEligible ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(isEligible ? Icons.check_circle : Icons.info, size: 12, color: isEligible ? const Color(0xFF059669) : const Color(0xFFD97706)),
                        const SizedBox(width: 4),
                        Text(
                          isEligible ? 'Eligible Customer Type (${req['customerType']})' : 'Category Review Advised (${req['customerType']})',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isEligible ? const Color(0xFF059669) : const Color(0xFFD97706)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Row(
                    children: [
                      if (!isAccepted) ...[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white, minimumSize: const Size(0, 32)),
                            onPressed: () {
                              setState(() {
                                req['status'] = 'Owner Accepted';
                                _notifications.insert(0, {
                                  'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
                                  'title': 'Rental Request Accepted',
                                  'message': 'You accepted ${req['customerName']}\'s rental request for ${req['roomNumber']}.',
                                  'time': 'Just now',
                                  'isRead': false,
                                  'isReminder': false,
                                });
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request Accepted! Tenant notified to confirm final terms.')));
                            },
                            child: const Text('Accept Request', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626), minimumSize: const Size(0, 32)),
                            onPressed: () => _openRejectRequestDialog(req),
                            child: const Text('Reject', style: TextStyle(fontSize: 11)),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      IconButton(
                        icon: const Icon(Icons.phone, size: 18, color: Color(0xFF0284C7)),
                        tooltip: 'Call Tenant',
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling tenant ${req['customerPhone']}...'))),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 18),

        // 5. Active Rentals & Rent Dashboard (Section 16, 17, 18, 21)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.vpn_key_rounded, color: Color(0xFF0F766E), size: 18),
                const SizedBox(width: 6),
                Text('Active Tenancies & Rent Ledger (${_activeRentals.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        if (_activeRentals.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Text('No active rentals currently.', style: TextStyle(fontSize: 12, color: Colors.grey)),
          )
        else
          ..._activeRentals.map((rental) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${rental['propertyTitle']} - ${rental['roomNumber']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(12)),
                        child: Text('Due: ${rental['dueDay']}th of month', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Tenant: ${rental['customerName']} · Rent: ₹${rental['monthlyRent']}/mo · Deposit: ₹${rental['securityDeposit']}', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                  Text('Agreement: ${rental['agreementStatus']}', style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white, minimumSize: const Size(0, 32)),
                          icon: const Icon(Icons.payment, size: 14),
                          label: const Text('Record Payment', style: TextStyle(fontSize: 11)),
                          onPressed: () => _openPayRentDialog(rental),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: ElevatedButton.styleFrom(foregroundColor: const Color(0xFF0284C7), minimumSize: const Size(0, 32)),
                          icon: const Icon(Icons.notifications_active, size: 14),
                          label: const Text('Send Reminder', style: TextStyle(fontSize: 11)),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rent reminder sent to ${rental['customerName']}!')));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 18),

        // 6. Master Multi-Property & Multi-Room Portfolio (Section 3, 5, 29)
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.home_work_rounded, color: Color(0xFF0284C7), size: 18),
                const SizedBox(width: 6),
                Text('Managed Properties & Units (${_properties.length})',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      if (_expandedPropertyIds.length == _properties.length) {
                        _expandedPropertyIds.clear();
                      } else {
                        _expandedPropertyIds.addAll(_properties.map((e) => e['id'].toString()));
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF5EEAD4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _expandedPropertyIds.length == _properties.length ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: const Color(0xFF0F766E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _expandedPropertyIds.length == _properties.length ? 'Collapse' : 'Expand',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 28),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  ),
                  icon: const Icon(Icons.add, size: 12),
                  label: const Text('New Property', style: TextStyle(fontSize: 10.5)),
                  onPressed: () => _openPropertyFormDialog(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Filter Bar for Room Units Status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.filter_list_rounded, size: 14, color: Color(0xFF475569)),
                  SizedBox(width: 6),
                  Text('Filter Units:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _ownerRoomFilter,
                    isDense: true,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Units')),
                      DropdownMenuItem(value: 'AVAILABLE', child: Text('Available Only')),
                      DropdownMenuItem(value: 'RENTED', child: Text('Rented Only')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _ownerRoomFilter = val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        ..._properties.map((p) {
          final allRooms = List<Map<String, dynamic>>.from(p['rooms'] ?? []);
          final isExpanded = _expandedPropertyIds.contains(p['id']);
          
          final filteredRooms = allRooms.where((r) {
            if (_ownerRoomFilter == 'AVAILABLE') return r['status'] == 'Available';
            if (_ownerRoomFilter == 'RENTED') return r['status'] == 'Rented';
            return true;
          }).toList();

          final availableCount = allRooms.where((r) => r['status'] == 'Available').length;
          final rentedCount = allRooms.where((r) => r['status'] == 'Rented').length;

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isExpanded ? const Color(0xFF99F6E4) : const Color(0xFFE2E8F0), width: isExpanded ? 1.5 : 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Thumbnail
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            p['image'] ?? (p['images'] != null && (p['images'] as List).isNotEmpty ? p['images'][0] : ''),
                            width: 44,
                            height: 44,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFCCFBF1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.apartment_rounded, color: Color(0xFF0F766E), size: 22),
                            ),
                          ),
                        ),
                        if (p['images'] != null && (p['images'] as List).length > 1)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.75),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${(p['images'] as List).length}',
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text('${p['locality']}, ${p['city']} · ${p['propertyType'].toString().toUpperCase()} (${p['areaType'].toString().toUpperCase()})', style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          icon: const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF059669)),
                          tooltip: 'Add Room to this Building',
                          onPressed: () => _openAddRoomDialog(p),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0284C7)),
                          tooltip: 'Edit Property',
                          onPressed: () => _openPropertyFormDialog(existingProp: p),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                          tooltip: 'Delete Property',
                          onPressed: () => _confirmDeleteProperty(p),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 10),

                // Dropdown Header Accordion Bar for Independent Rooms & Units
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedPropertyIds.remove(p['id']);
                      } else {
                        _expandedPropertyIds.add(p['id']);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isExpanded ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isExpanded ? const Color(0xFF5EEAD4) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.apartment_rounded, size: 16, color: isExpanded ? const Color(0xFF0F766E) : const Color(0xFF64748B)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 2,
                            children: [
                              Text(
                                'Units (${allRooms.length})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isExpanded ? const Color(0xFF0F766E) : const Color(0xFF334155),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: Text(
                                  '$availableCount Avail · $rentedCount Rented',
                                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isExpanded ? 'Hide' : 'Show',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isExpanded ? const Color(0xFF0F766E) : const Color(0xFF64748B),
                              ),
                            ),
                            Icon(
                              isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: isExpanded ? const Color(0xFF0F766E) : const Color(0xFF64748B),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Dropdown Content (Expanded list of Room Units)
                if (isExpanded) ...[
                  const SizedBox(height: 8),
                  if (filteredRooms.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: Text(
                          _ownerRoomFilter == 'ALL' ? 'No rooms added yet. Tap "Add Unit" above to add a unit.' : 'No rooms match "$_ownerRoomFilter" status.',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ),
                    )
                  else
                    ...filteredRooms.map((r) {
                      final currentStatus = r['status'] ?? 'Available';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFEEF2F6)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 6,
                                    runSpacing: 2,
                                    children: [
                                      Text('${r['roomNumber']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                        decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(4)),
                                        child: Text('${r['roomType']}', style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                                      ),
                                      Text('₹${r['monthlyRent']}/mo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F766E))),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Deposit: ₹${r['securityDeposit']} · ${r['furnishing']} · Suitable: ${(r['suitableFor'] as List).join(', ')}',
                                    style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Interactive Status Popup Menu Selector for Each Room (No emoji glyphs, zero subpixel overflow)
                            PopupMenuButton<String>(
                              tooltip: 'Change Room Status',
                              onSelected: (newStatus) {
                                setState(() {
                                  r['status'] = newStatus;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${r['roomNumber']} status set to $newStatus!'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Available',
                                  child: Row(
                                    children: [
                                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                                      const SizedBox(width: 8),
                                      const Text('Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Rented',
                                  child: Row(
                                    children: [
                                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                                      const SizedBox(width: 8),
                                      const Text('Rented', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'Maintenance',
                                  child: Row(
                                    children: [
                                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                                      const SizedBox(width: 8),
                                      const Text('Maintenance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                decoration: BoxDecoration(
                                  color: currentStatus == 'Available'
                                      ? const Color(0xFFD1FAE5)
                                      : currentStatus == 'Rented'
                                          ? const Color(0xFFFEE2E2)
                                          : const Color(0xFFFEF3C7),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: currentStatus == 'Available'
                                        ? const Color(0xFF10B981)
                                        : currentStatus == 'Rented'
                                            ? const Color(0xFFEF4444)
                                            : const Color(0xFFF59E0B),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: currentStatus == 'Available'
                                            ? const Color(0xFF059669)
                                            : currentStatus == 'Rented'
                                                ? const Color(0xFFDC2626)
                                                : const Color(0xFFD97706),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      currentStatus,
                                      style: TextStyle(
                                        color: currentStatus == 'Available'
                                            ? const Color(0xFF065F46)
                                            : currentStatus == 'Rented'
                                                ? const Color(0xFF991B1B)
                                                : const Color(0xFF92400E),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 1),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 14,
                                      color: currentStatus == 'Available'
                                          ? const Color(0xFF065F46)
                                          : currentStatus == 'Rented'
                                              ? const Color(0xFF991B1B)
                                              : const Color(0xFF92400E),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 18),

        // 7. Property-Wise Rent Collection Report (Section 23)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Property-Wise Rent Collection', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
                  const Text('October 2026', style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 10),
              ..._properties.map((prop) {
                int propRent = 0;
                for (var r in prop['rooms']) {
                  propRent += (r['monthlyRent'] as num).toInt();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(prop['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                      Text('₹$propRent / mo', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // 8. Host Contact & Privacy Settings (Section 27)
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Host Contact Privacy Controls', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              const Text('Control how prospective tenants reach you on property listings:', style: TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _ownerContactPrivacy,
                decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                items: const [
                  DropdownMenuItem(value: 'CALL_MSG_ON', child: Text('Calls & Messages ON')),
                  DropdownMenuItem(value: 'CALL_ON_MSG_OFF', child: Text('Calls ON, Messages OFF')),
                  DropdownMenuItem(value: 'CALL_OFF_MSG_ON', child: Text('Calls OFF, Messages ON')),
                  DropdownMenuItem(value: 'BOTH_OFF', child: Text('Both OFF (Masked Privacy Mode)')),
                ],
                onChanged: (val) {
                  setState(() => _ownerContactPrivacy = val!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contact privacy updated to $_ownerContactPrivacy')));
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildOwnerKpiCard(String label, String value, IconData icon, Color color, {VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 16, color: color),
                  Icon(Icons.arrow_outward_rounded, size: 10, color: Colors.grey.withValues(alpha: 0.6)),
                ],
              ),
              const SizedBox(height: 4),
              Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13.5, color: const Color(0xFF0F172A)), overflow: TextOverflow.ellipsis),
              Text(label, style: const TextStyle(fontSize: 8.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  void _showOwnerPropertiesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.apartment_rounded, color: Color(0xFF0F766E)),
                    const SizedBox(width: 8),
                    Text('Managed Properties (${_properties.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white, minimumSize: const Size(0, 28), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                  icon: const Icon(Icons.add, size: 12),
                  label: const Text('Add New', style: TextStyle(fontSize: 10.5)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _openPropertyFormDialog();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, idx) {
                  final p = _properties[idx];
                  final rooms = List<Map<String, dynamic>>.from(p['rooms'] ?? []);
                  int buildingRent = 0;
                  for (var r in rooms) {
                    buildingRent += (r['monthlyRent'] as num).toInt();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('${p['locality']}, ${p['city']} · ${p['propertyType']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              const SizedBox(height: 2),
                              Text('${rooms.length} Units · ₹$buildingRent/mo total', style: const TextStyle(fontSize: 10.5, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 18, color: Color(0xFF059669)),
                          tooltip: 'Add Unit',
                          onPressed: () {
                            Navigator.pop(ctx);
                            _openAddRoomDialog(p);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0284C7)),
                          tooltip: 'Edit',
                          onPressed: () {
                            Navigator.pop(ctx);
                            _openPropertyFormDialog(existingProp: p);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOwnerUnitsSheet(int total, int avail, int rented) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.meeting_room_rounded, color: Color(0xFF0284C7)),
                    const SizedBox(width: 8),
                    Text('All Units & Rooms ($total)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                  child: Text('$avail Avail · $rented Rented', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: _properties.expand((p) {
                  final rooms = List<Map<String, dynamic>>.from(p['rooms'] ?? []);
                  return rooms.map((r) {
                    final isAvail = r['status'] == 'Available';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFEEF2F6))),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${r['roomNumber']} · ${p['title']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                                Text('₹${r['monthlyRent']}/mo · ${r['roomType']} · ${r['furnishing']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAvail ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              r['status'],
                              style: TextStyle(color: isAvail ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOwnerInquiriesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inbox_rounded, color: Color(0xFF7C3AED)),
                      const SizedBox(width: 8),
                      Text('Tenant Rental Inquiries (${_rentalRequests.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_rentalRequests.isEmpty)
                const Expanded(child: Center(child: Text('No pending inquiries from customers.', style: TextStyle(color: Colors.grey))))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _rentalRequests.length,
                    itemBuilder: (context, idx) {
                      final req = _rentalRequests[idx];
                      final isAccepted = req['status'] == 'Owner Accepted' || req['status'] == 'Agreement Completed';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(req['customerName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: isAccepted ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                                  child: Text(req['status'], style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isAccepted ? Colors.green : const Color(0xFFD97706))),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${req['propertyTitle']} · Unit ${req['roomNumber']} (Rent: ₹${req['offeredRent']}/mo)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            Text('Tenant Category: ${req['customerType']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF0F766E), fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            if (!isAccepted)
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669), foregroundColor: Colors.white, minimumSize: const Size(0, 30)),
                                      onPressed: () {
                                        setState(() {
                                          req['status'] = 'Owner Accepted';
                                        });
                                        setSheetState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request for ${req['customerName']} accepted!')));
                                      },
                                      child: const Text('Accept Request', style: TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red, minimumSize: const Size(0, 30)),
                                      onPressed: () {
                                        setState(() {
                                          _rentalRequests.remove(req);
                                        });
                                        setSheetState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected.')));
                                      },
                                      child: const Text('Reject', style: TextStyle(fontSize: 11)),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExpectedRentSheet(int expectedRent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.currency_rupee, color: Color(0xFF0F172A)),
                const SizedBox(width: 8),
                Text('Expected Monthly Rent Breakdown', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Total Portfolio Value: ₹$expectedRent / month', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: _properties.length,
                itemBuilder: (context, idx) {
                  final p = _properties[idx];
                  final rooms = List<Map<String, dynamic>>.from(p['rooms'] ?? []);
                  int bRent = 0;
                  for (var r in rooms) {
                    bRent += (r['monthlyRent'] as num).toInt();
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('${rooms.length} units listed · ${p['locality']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Text('₹$bRent / mo', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E))),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCollectedRentSheet(int collectedRent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance_wallet, color: Color(0xFF10B981)),
                const SizedBox(width: 8),
                Text('Rent Collected & Payments', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Total Collected This Month: ₹$collectedRent', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: _rentPayments.length,
                itemBuilder: (context, idx) {
                  final pay = _rentPayments[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${pay['customerName']} · ₹${pay['amount']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('${pay['monthYear']} · Paid via ${pay['method']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              Text('Receipt: ${pay['receiptNo']}', style: const TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(6)),
                          child: const Text('Paid', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPendingRentSheet(int pendingRent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hourglass_bottom, color: Color(0xFFEA580C)),
                const SizedBox(width: 8),
                Text('Pending Rent & Overdue Dues', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 6),
            Text('Total Outstanding: ₹$pendingRent', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFEA580C))),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.builder(
                itemCount: _activeRentals.length,
                itemBuilder: (context, idx) {
                  final ren = _activeRentals[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ren['customerName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text('${ren['propertyTitle']} · Unit ${ren['roomNumber']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                              Text('Due Rent: ₹${ren['monthlyRent']} (Due 5th Oct)', style: const TextStyle(fontSize: 11, color: Color(0xFFEA580C), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white, minimumSize: const Size(0, 28), padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2)),
                          icon: const Icon(Icons.send_rounded, size: 12),
                          label: const Text('Remind', style: TextStyle(fontSize: 10.5)),
                          onPressed: () {
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment reminder sent to ${ren['customerName']}!')));
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddRoomDialog(Map<String, dynamic> property) {
    final roomNoCtrl = TextEditingController(text: 'Room ${((property['rooms'] as List).length + 1) * 101}');
    final rentCtrl = TextEditingController(text: '8000');
    final depositCtrl = TextEditingController(text: '16000');
    final sizeCtrl = TextEditingController(text: '450 sq.ft');
    String furnishing = 'Furnished';
    String roomType = '1 BHK';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Add Room to ${property['title']}', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: roomNoCtrl, decoration: const InputDecoration(labelText: 'Room / Unit Number *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: roomType,
                        decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder(), isDense: true),
                        items: const [
                          DropdownMenuItem(value: 'Single Room', child: Text('Single Room')),
                          DropdownMenuItem(value: '1 BHK', child: Text('1 BHK')),
                          DropdownMenuItem(value: '2 BHK', child: Text('2 BHK')),
                          DropdownMenuItem(value: '3 BHK', child: Text('3 BHK')),
                          DropdownMenuItem(value: 'Godown', child: Text('Godown')),
                        ],
                        onChanged: (val) => setDialogState(() => roomType = val!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: furnishing,
                        decoration: const InputDecoration(labelText: 'Furnishing', border: OutlineInputBorder(), isDense: true),
                        items: const [
                          DropdownMenuItem(value: 'Furnished', child: Text('Furnished')),
                          DropdownMenuItem(value: 'Semi-Furnished', child: Text('Semi')),
                          DropdownMenuItem(value: 'Unfurnished', child: Text('Unfurn')),
                        ],
                        onChanged: (val) => setDialogState(() => furnishing = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: TextField(controller: rentCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rent (₹) *', border: OutlineInputBorder(), isDense: true))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: depositCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Deposit (₹)', border: OutlineInputBorder(), isDense: true))),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(controller: sizeCtrl, decoration: const InputDecoration(labelText: 'Room Dimensions (e.g. 520 sq.ft)', border: OutlineInputBorder(), isDense: true)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
              onPressed: () {
                if (roomNoCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final rVal = int.tryParse(rentCtrl.text) ?? 8000;
                final dVal = int.tryParse(depositCtrl.text) ?? (rVal * 2);
                setState(() {
                  (property['rooms'] as List).add({
                    'id': 'room_${DateTime.now().millisecondsSinceEpoch}',
                    'roomNumber': roomNoCtrl.text.trim(),
                    'roomType': roomType,
                    'size': sizeCtrl.text.trim().isEmpty ? '450 sq.ft' : sizeCtrl.text.trim(),
                    'furnishing': furnishing,
                    'monthlyRent': rVal,
                    'securityDeposit': dVal,
                    'dueDay': 5,
                    'status': 'Available',
                    'availableFrom': 'Immediate',
                    'suitableFor': ['Students', 'Working Professional', 'Bachelor', 'Family'],
                  });
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${roomNoCtrl.text} added to ${property['title']}!')));
              },
              child: const Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }

  void _openRejectRequestDialog(Map<String, dynamic> req) {
    final reasonCtrl = TextEditingController(text: 'Property occupied or criteria mismatch.');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Rental Request', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reject inquiry from ${req['customerName']} for ${req['roomNumber']}?'),
            const SizedBox(height: 10),
            TextField(controller: reasonCtrl, decoration: const InputDecoration(labelText: 'Reason for Rejection', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                req['status'] = 'Rejected';
                _notifications.insert(0, {
                  'id': 'notif_${DateTime.now().millisecondsSinceEpoch}',
                  'title': 'Rental Request Rejected',
                  'message': 'You rejected inquiry from ${req['customerName']} (${reasonCtrl.text.trim()}).',
                  'time': 'Just now',
                  'isRead': false,
                  'isReminder': false,
                });
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inquiry rejected and tenant notified.')));
            },
            child: const Text('Confirm Reject'),
          ),
        ],
      ),
    );
  }

  void _openOwnerReportsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Row(
              children: [
                const Icon(Icons.assessment_rounded, color: Color(0xFF0F766E)),
                const SizedBox(width: 8),
                Text('Owner Portfolio & Financial Reports', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Color(0xFF059669)),
              title: const Text('Monthly Rent Ledger Statement'),
              subtitle: const Text('Download month-wise statement of all tenants'),
              trailing: const Icon(Icons.download),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rent ledger CSV report exported!')));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF0284C7)),
              title: const Text('Property Occupancy Summary'),
              subtitle: const Text('Active leases, vacant rooms, and turnover'),
              trailing: const Icon(Icons.download),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Occupancy report exported!')));
              },
            ),
          ],
        ),
      ),
    );
  }

  static const List<Map<String, String>> _kPropertyPhotoCatalog = [
    {
      'name': 'Living Room (Spacious)',
      'category': 'Living / Hall',
      'url': 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Master Bedroom (Cozy)',
      'category': 'Bedroom',
      'url': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Modern Modular Kitchen',
      'category': 'Kitchen',
      'url': 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Building Exterior Front',
      'category': 'Exterior',
      'url': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Scenic Balcony & View',
      'category': 'Balcony',
      'url': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Luxury Clean Bathroom',
      'category': 'Washroom',
      'url': 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Dining Area & Table',
      'category': 'Dining',
      'url': 'https://images.unsplash.com/photo-1617806118233-18e1de247200?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Furnished Studio Room',
      'category': 'Studio',
      'url': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Rooftop Terrace View',
      'category': 'Terrace',
      'url': 'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80',
    },
    {
      'name': 'Covered Parking Area',
      'category': 'Parking',
      'url': 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?auto=format&fit=crop&w=800&q=80',
    },
  ];

  void _showPhotoPickerSheet({
    required BuildContext context,
    required Function(String) onPhotoAdded,
  }) {
    final customUrlController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bCtx) => Container(
        height: MediaQuery.of(bCtx).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                const Icon(Icons.photo_library_rounded, color: Color(0xFF0F766E), size: 22),
                const SizedBox(width: 8),
                Text(
                  'Choose Property Photo',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF64748B), size: 20),
                  onPressed: () => Navigator.pop(bCtx),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap any photo below to attach it instantly, or enter a custom image link.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: customUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Custom Photo URL (https://...)',
                      hintText: 'https://example.com/room.jpg',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  onPressed: () {
                    final url = customUrlController.text.trim();
                    if (url.isNotEmpty) {
                      onPhotoAdded(url);
                      Navigator.pop(bCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Custom photo attached successfully!'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color(0xFF0F766E),
                        ),
                      );
                    }
                  },
                  child: const Text('Attach', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              'Popular Room & Property Presets',
              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemCount: _kPropertyPhotoCatalog.length,
                itemBuilder: (ctx, i) {
                  final photo = _kPropertyPhotoCatalog[i];
                  final url = photo['url']!;
                  final name = photo['name']!;
                  final cat = photo['category']!;
                  return InkWell(
                    onTap: () {
                      onPhotoAdded(url);
                      Navigator.pop(bCtx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$name photo attached!'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: const Color(0xFF0F766E),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        color: const Color(0xFFF8FAFC),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE2E8F0),
                              child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.85),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cat,
                                    style: const TextStyle(
                                      color: Color(0xFF5EEAD4),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0F766E),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSamplePhotoChip({
    required String label,
    required IconData icon,
    required String url,
    required Function(String) onAdd,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: const Color(0xFF0F766E)),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0F766E))),
      backgroundColor: const Color(0xFFF0FDFA),
      side: const BorderSide(color: Color(0xFF99F6E4)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      onPressed: () => onAdd(url),
    );
  }

  // ===================================================================
  // FULL CRUD MODALS: PROPERTIES, CUSTOMERS & OWNERS
  // ===================================================================
  void _openPropertyFormDialog({Map<String, dynamic>? existingProp}) {
    final isEditing = existingProp != null;
    final titleCtrl = TextEditingController(text: isEditing ? existingProp['title'] : '');
    final cityCtrl = TextEditingController(text: isEditing ? existingProp['city'] : 'Varanasi');
    final localityCtrl = TextEditingController(text: isEditing ? existingProp['locality'] : '');
    final addressCtrl = TextEditingController(text: isEditing ? existingProp['address'] : '');
    final photoUrlCtrl = TextEditingController();
    String areaType = isEditing ? existingProp['areaType'] : 'urban';
    String propertyType = isEditing ? existingProp['propertyType'] : 'room';

    final room = isEditing && (existingProp['rooms'] as List).isNotEmpty ? existingProp['rooms'][0] : null;
    final rentCtrl = TextEditingController(text: room != null ? '${room['monthlyRent']}' : '8500');
    final depositCtrl = TextEditingController(text: room != null ? '${room['securityDeposit']}' : '17000');
    String furnishing = room != null ? room['furnishing'] : 'Furnished';

    final List<String> uploadedPhotos = isEditing && existingProp['images'] is List && (existingProp['images'] as List).isNotEmpty
        ? List<String>.from(existingProp['images'])
        : (isEditing && existingProp['image'] != null
            ? [existingProp['image'].toString()]
            : [
                'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
                'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
                'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
              ]);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Property' : 'Add New Property', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Property Title *', border: OutlineInputBorder(), isDense: true)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: areaType,
                          decoration: const InputDecoration(labelText: 'Area', border: OutlineInputBorder(), isDense: true),
                          items: const [
                            DropdownMenuItem(value: 'urban', child: Text('Urban')),
                            DropdownMenuItem(value: 'rural', child: Text('Rural')),
                          ],
                          onChanged: (val) => setDialogState(() => areaType = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: propertyType,
                          decoration: const InputDecoration(labelText: 'Type', border: OutlineInputBorder(), isDense: true),
                          items: const [
                            DropdownMenuItem(value: 'room', child: Text('Room')),
                            DropdownMenuItem(value: 'flat', child: Text('Flat/2BHK')),
                            DropdownMenuItem(value: 'apartment', child: Text('Apartment')),
                            DropdownMenuItem(value: 'house', child: Text('House')),
                            DropdownMenuItem(value: 'hostel', child: Text('Hostel/PG')),
                            DropdownMenuItem(value: 'godown', child: Text('Godown')),
                          ],
                          onChanged: (val) => setDialogState(() => propertyType = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'City *', border: OutlineInputBorder(), isDense: true))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: localityCtrl, decoration: const InputDecoration(labelText: 'Locality *', border: OutlineInputBorder(), isDense: true))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Full Address', border: OutlineInputBorder(), isDense: true)),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 4),

                  // Furnishing, Rent & Deposit per Room
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: furnishing,
                          decoration: const InputDecoration(labelText: 'Furnishing', border: OutlineInputBorder(), isDense: true),
                          items: const [
                            DropdownMenuItem(value: 'Furnished', child: Text('Furnished')),
                            DropdownMenuItem(value: 'Semi-Furnished', child: Text('Semi-Furnished')),
                            DropdownMenuItem(value: 'Unfurnished', child: Text('Unfurnished')),
                          ],
                          onChanged: (val) => setDialogState(() => furnishing = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: rentCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rent/Room (₹/mo) *', border: OutlineInputBorder(), isDense: true))),
                      const SizedBox(width: 8),
                      Expanded(child: TextField(controller: depositCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Deposit/Room (₹)', border: OutlineInputBorder(), isDense: true))),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(),

                  // =======================================================
                  // MULTIPLE PROPERTY PHOTOS ATTACHMENT SECTION
                  // =======================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.photo_library_rounded, size: 16, color: Color(0xFF0F766E)),
                          const SizedBox(width: 6),
                          Text(
                            'Property Photos (Multiple)',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF0F766E)),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCCFBF1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${uploadedPhotos.length} Attached',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Quick-pick sample photos or enter custom photo URLs:',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),

                  // Quick preset photo pickers in Wrap
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildSamplePhotoChip(
                        label: 'Living Room',
                        icon: Icons.chair_rounded,
                        url: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Living Room photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                      _buildSamplePhotoChip(
                        label: 'Bedroom',
                        icon: Icons.bed_rounded,
                        url: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Bedroom photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                      _buildSamplePhotoChip(
                        label: 'Kitchen',
                        icon: Icons.kitchen_rounded,
                        url: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Kitchen photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                      _buildSamplePhotoChip(
                        label: 'Exterior',
                        icon: Icons.apartment_rounded,
                        url: 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Exterior photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                      _buildSamplePhotoChip(
                        label: 'Balcony',
                        icon: Icons.balcony_rounded,
                        url: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Balcony photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                      _buildSamplePhotoChip(
                        label: 'Washroom',
                        icon: Icons.bathtub_rounded,
                        url: 'https://images.unsplash.com/photo-1584622650111-993a426fbf0a?auto=format&fit=crop&w=800&q=80',
                        onAdd: (url) {
                          setDialogState(() {
                            if (!uploadedPhotos.contains(url)) {
                              uploadedPhotos.add(url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Washroom photo added!'), duration: Duration(seconds: 1), backgroundColor: Color(0xFF0F766E)),
                              );
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Custom URL Input Row with Smart Add Button
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: photoUrlCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Paste Photo URL (https://...)',
                            hintText: 'https://example.com/photo.jpg',
                            border: OutlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                        onPressed: () {
                          final url = photoUrlCtrl.text.trim();
                          if (url.isNotEmpty) {
                            setDialogState(() {
                              if (!uploadedPhotos.contains(url)) {
                                uploadedPhotos.add(url);
                              }
                              photoUrlCtrl.clear();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Photo attached successfully!'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Color(0xFF0F766E),
                              ),
                            );
                          } else {
                            // If empty, open the visual photo picker gallery!
                            _showPhotoPickerSheet(
                              context: context,
                              onPhotoAdded: (pickedUrl) {
                                setDialogState(() {
                                  if (!uploadedPhotos.contains(pickedUrl)) {
                                    uploadedPhotos.add(pickedUrl);
                                  }
                                });
                              },
                            );
                          }
                        },
                        icon: const Icon(Icons.add_photo_alternate_rounded, size: 16),
                        label: const Text('Add', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Visual thumbnail gallery list with delete options + Add tile
                  if (uploadedPhotos.isEmpty)
                    InkWell(
                      onTap: () {
                        _showPhotoPickerSheet(
                          context: context,
                          onPhotoAdded: (pickedUrl) {
                            setDialogState(() {
                              if (!uploadedPhotos.contains(pickedUrl)) {
                                uploadedPhotos.add(pickedUrl);
                              }
                            });
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, color: Colors.grey[400], size: 28),
                            const SizedBox(height: 4),
                            const Text(
                              'No photos attached yet. Tap here or Add button to browse photos.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (int idx = 0; idx < uploadedPhotos.length; idx++)
                          Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: idx == 0 ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1),
                                    width: idx == 0 ? 2 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    uploadedPhotos[idx],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: const Color(0xFFF1F5F9),
                                      child: const Center(
                                        child: Icon(Icons.broken_image_rounded, size: 20, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Cover / Index badge
                              Positioned(
                                top: 3,
                                left: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: idx == 0 ? const Color(0xFF0F766E) : Colors.black.withValues(alpha: 0.65),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    idx == 0 ? 'Cover' : '#${idx + 1}',
                                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Delete button
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    setDialogState(() {
                                      uploadedPhotos.removeAt(idx);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDC2626),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),

                        // Add More Photos Tile in Gallery Wrap
                        InkWell(
                          onTap: () {
                            _showPhotoPickerSheet(
                              context: context,
                              onPhotoAdded: (pickedUrl) {
                                setDialogState(() {
                                  if (!uploadedPhotos.contains(pickedUrl)) {
                                    uploadedPhotos.add(pickedUrl);
                                  }
                                });
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 80,
                            height: 68,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDFA),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF0F766E), width: 1.5),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, color: Color(0xFF0F766E), size: 20),
                                SizedBox(height: 2),
                                Text(
                                  '+ Add Photo',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                final rentVal = int.tryParse(rentCtrl.text) ?? 8500;
                final depVal = int.tryParse(depositCtrl.text) ?? (rentVal * 2);
                final finalPhotos = uploadedPhotos.isNotEmpty
                    ? List<String>.from(uploadedPhotos)
                    : ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80'];

                final createdRooms = isEditing && (existingProp['rooms'] is List) && (existingProp['rooms'] as List).isNotEmpty
                    ? List<Map<String, dynamic>>.from(existingProp['rooms'])
                    : [
                        {
                          'id': 'room_${DateTime.now().millisecondsSinceEpoch}_1',
                          'roomNumber': 'Room 101',
                          'roomType': propertyType == 'flat' ? '2 BHK' : (propertyType == 'apartment' ? 'Apartment Unit' : '1 Room'),
                          'size': '450 sq.ft',
                          'furnishing': furnishing,
                          'monthlyRent': rentVal,
                          'securityDeposit': depVal,
                          'dueDay': 1,
                          'status': 'Available',
                          'featuredImage': finalPhotos.first,
                          'suitableFor': ['student', 'bachelor', 'family', 'working_professional'],
                        }
                      ];

                setState(() {
                  if (isEditing) {
                    existingProp['title'] = titleCtrl.text.trim();
                    existingProp['city'] = cityCtrl.text.trim();
                    existingProp['locality'] = localityCtrl.text.trim();
                    existingProp['address'] = addressCtrl.text.trim();
                    existingProp['areaType'] = areaType;
                    existingProp['propertyType'] = propertyType;
                    existingProp['images'] = finalPhotos;
                    existingProp['image'] = finalPhotos.first;
                    existingProp['rooms'] = createdRooms;
                  } else {
                    _properties.insert(0, {
                      'id': 'prop_${DateTime.now().millisecondsSinceEpoch}',
                      'ownerId': 'owner_1',
                      'ownerName': 'Rajesh Pandey',
                      'ownerPhone': '9450012345',
                      'title': titleCtrl.text.trim(),
                      'propertyType': propertyType,
                      'areaType': areaType,
                      'city': cityCtrl.text.trim(),
                      'locality': localityCtrl.text.trim(),
                      'address': addressCtrl.text.trim().isEmpty ? '${localityCtrl.text.trim()}, ${cityCtrl.text.trim()}' : addressCtrl.text.trim(),
                      'rating': 5.0,
                      'images': finalPhotos,
                      'image': finalPhotos.first,
                      'electricityInfo': 'Direct submeter bill.',
                      'maintenanceInfo': 'Standard maintenance included.',
                      'amenities': ['Wi-Fi', '24/7 Water', 'Parking'],
                      'rooms': createdRooms,
                    });
                    _expandedPropertyIds.add(_properties.first['id'].toString());
                    _expandedAdminPropertyIds.add(_properties.first['id'].toString());
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isEditing
                      ? 'Property updated with ${createdRooms.length} rooms & ${finalPhotos.length} photos!'
                      : 'Property published with ${createdRooms.length} rooms (Room 1, 2, 3...) & live for customers!'),
                  backgroundColor: const Color(0xFF0F766E),
                ));
              },
              child: Text(isEditing ? 'Save Changes' : 'Publish Property'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteProperty(Map<String, dynamic> prop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Property'),
        content: Text('Are you sure you want to delete "${prop['title']}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _properties.remove(prop);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Property "${prop['title']}" deleted.'),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openCustomerFormDialog({Map<String, dynamic>? existingCustomer}) {
    final isEditing = existingCustomer != null;
    final nameCtrl = TextEditingController(text: isEditing ? existingCustomer['name'] : '');
    final phoneCtrl = TextEditingController(text: isEditing ? existingCustomer['phone'] : '');
    final emailCtrl = TextEditingController(text: isEditing ? existingCustomer['email'] : '');
    String type = isEditing ? existingCustomer['type'] : 'Working Professional';
    bool kyc = isEditing ? (existingCustomer['kyc'] ?? true) : true;

    // Booking Duration Unit & Value (Month / Day / Hour)
    String bookingDurationType = isEditing && existingCustomer['bookingDurationType'] != null
        ? existingCustomer['bookingDurationType']
        : 'month'; // 'month' | 'day' | 'hour'
    int bookingDurationValue = isEditing && existingCustomer['bookingDurationValue'] != null
        ? (existingCustomer['bookingDurationValue'] is int ? existingCustomer['bookingDurationValue'] : int.tryParse(existingCustomer['bookingDurationValue'].toString()) ?? 1)
        : (bookingDurationType == 'hour' ? 4 : (bookingDurationType == 'day' ? 3 : 1));

    final durationCtrl = TextEditingController(text: bookingDurationValue.toString());
    final checkInTimeCtrl = TextEditingController(
      text: isEditing && existingCustomer['bookingStartTime'] != null ? existingCustomer['bookingStartTime'].toString() : '10:00 AM',
    );
    final checkOutTimeCtrl = TextEditingController(
      text: isEditing && existingCustomer['bookingEndTime'] != null ? existingCustomer['bookingEndTime'].toString() : '04:00 PM',
    );

    // Property & Room Assignment
    String selectedPropId = isEditing ? (existingCustomer['assignedPropertyId'] ?? 'NONE') : 'NONE';
    String selectedRoomId = isEditing ? (existingCustomer['assignedRoomId'] ?? 'NONE') : 'NONE';

    final rentCtrl = TextEditingController(
      text: isEditing && existingCustomer['monthlyRent'] != null ? existingCustomer['monthlyRent'].toString() : '',
    );
    final depCtrl = TextEditingController(
      text: isEditing && existingCustomer['securityDeposit'] != null ? existingCustomer['securityDeposit'].toString() : '',
    );
    final moveInCtrl = TextEditingController(
      text: isEditing && existingCustomer['moveInDate'] != null ? existingCustomer['moveInDate'].toString() : '2026-10-01',
    );

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Find selected property object
          Map<String, dynamic>? currentSelectedProp;
          if (selectedPropId != 'NONE') {
            for (var p in _properties) {
              if (p['id'] == selectedPropId) {
                currentSelectedProp = p;
                break;
              }
            }
          }

          final availableRooms = currentSelectedProp != null ? (currentSelectedProp['rooms'] as List) : [];

          int getSelectedRoomRent() {
            if (currentSelectedProp != null && currentSelectedProp['rooms'] is List) {
              final rms = currentSelectedProp['rooms'] as List;
              for (var r in rms) {
                if (r is Map && r['id'].toString() == selectedRoomId.toString()) {
                  return int.tryParse(r['monthlyRent'].toString()) ?? 9000;
                }
              }
              if (rms.isNotEmpty && rms.first is Map) {
                return int.tryParse((rms.first as Map)['monthlyRent'].toString()) ?? 9000;
              }
            }
            return 9000;
          }

          // Helper to recalculate financials based on duration
          void recalculateFinancials(int baseMonthly) {
            final val = int.tryParse(durationCtrl.text) ?? 1;
            if (bookingDurationType == 'hour') {
              final hrRate = ((baseMonthly / (30 * 6)).round()).clamp(50, 500);
              rentCtrl.text = (hrRate * val).toString();
              depCtrl.text = '0';
            } else if (bookingDurationType == 'day') {
              final dayRate = (baseMonthly / 30).round();
              rentCtrl.text = (dayRate * val).toString();
              depCtrl.text = (dayRate * 1).toString();
            } else {
              rentCtrl.text = (baseMonthly * val).toString();
              depCtrl.text = (baseMonthly * 2).toString();
            }
          }

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              isEditing ? 'Edit Customer & Rental' : 'Add New Customer',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Customer Profile Details
                    const Text('Customer Profile Information', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full Name *', hintText: 'e.g. Amit Sharma', border: OutlineInputBorder(), isDense: true),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Phone (+91) *', hintText: '9876543210', border: OutlineInputBorder(), isDense: true),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(labelText: 'Email Address', hintText: 'amit@example.com', border: OutlineInputBorder(), isDense: true),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: type,
                      decoration: const InputDecoration(labelText: 'Tenant Category', border: OutlineInputBorder(), isDense: true),
                      items: const [
                        DropdownMenuItem(value: 'Working Professional', child: Text('Working Professional')),
                        DropdownMenuItem(value: 'Students', child: Text('Student / Bachelor')),
                        DropdownMenuItem(value: 'Family', child: Text('Family')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => type = val);
                      },
                    ),
                    const SizedBox(height: 6),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Aadhaar KYC Verified', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                      subtitle: const Text('UIDAI Identity & Address Verification', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      value: kyc,
                      activeThumbColor: const Color(0xFF0F766E),
                      activeTrackColor: const Color(0xFFCCFBF1),
                      onChanged: (val) => setDialogState(() => kyc = val),
                    ),
                    const Divider(height: 18, color: Color(0xFFCBD5E1)),

                    // Section 2: Property & Rental Assignment (Kon se property ko rent de rhe hai)
                    Row(
                      children: const [
                        Icon(Icons.vpn_key_rounded, size: 14, color: Color(0xFF0F766E)),
                        SizedBox(width: 4),
                        Text('Rental Property Assignment', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Select which property & unit is being rented:', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    const SizedBox(height: 8),

                    // Property Selector Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: selectedPropId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Property to Rent',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: 'NONE',
                          child: Text('None (Not Renting Yet / Prospect)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ),
                        ..._properties.map<DropdownMenuItem<String>>((p) => DropdownMenuItem<String>(
                          value: p['id'].toString(),
                          child: Text(p['title'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                        )),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedPropId = val;
                            if (val == 'NONE') {
                              selectedRoomId = 'NONE';
                              rentCtrl.text = '';
                              depCtrl.text = '';
                            } else {
                              Map<String, dynamic>? prop;
                              for (final p in _properties) {
                                if (p['id'] == val) {
                                  prop = p;
                                  break;
                                }
                              }
                              final rms = (prop != null && prop['rooms'] is List) ? List<Map<String, dynamic>>.from(prop['rooms']) : <Map<String, dynamic>>[];
                              if (rms.isNotEmpty) {
                                Map<String, dynamic> firstAvail = rms.first;
                                for (final r in rms) {
                                  if (r['status'] == 'Available') {
                                    firstAvail = r;
                                    break;
                                  }
                                }
                                selectedRoomId = firstAvail['id'].toString();
                                recalculateFinancials(getSelectedRoomRent());
                              } else {
                                selectedRoomId = 'NONE';
                              }
                            }
                          });
                        }
                      },
                    ),

                    // If Property is Selected, Show Room Selector, Duration (Month/Day/Hour), Financials
                    if (selectedPropId != 'NONE' && availableRooms.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRoomId != 'NONE' ? selectedRoomId : (availableRooms.isNotEmpty ? availableRooms[0]['id'].toString() : 'NONE'),
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Unit / Room Number *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: availableRooms.map<DropdownMenuItem<String>>((r) {
                          final isAvail = r['status'] == 'Available';
                          return DropdownMenuItem<String>(
                            value: r['id'].toString(),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: isAvail ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${r['roomNumber']} - ₹${r['monthlyRent']}/mo (${r['status']})',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isAvail ? FontWeight.bold : FontWeight.normal,
                                      color: isAvail ? const Color(0xFF0F766E) : const Color(0xFF64748B),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedRoomId = val;
                              recalculateFinancials(getSelectedRoomRent());
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // =======================================================
                      // BOOKING DURATION TYPE: MONTH / DAY / HOUR
                      // =======================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.schedule_rounded, size: 14, color: Color(0xFF0F766E)),
                              SizedBox(width: 4),
                              Text('Booking Duration Type *', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFCCFBF1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  bookingDurationType == 'hour'
                                      ? Icons.access_time_rounded
                                      : (bookingDurationType == 'day' ? Icons.wb_sunny_rounded : Icons.calendar_month_rounded),
                                  size: 11,
                                  color: const Color(0xFF0F766E),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  bookingDurationType == 'hour' ? 'Hourly' : (bookingDurationType == 'day' ? 'Daily' : 'Monthly'),
                                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // 3 Segmented Buttons for Month, Day, Hour
                      Row(
                        children: [
                          // Month Button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setDialogState(() {
                                  bookingDurationType = 'month';
                                  bookingDurationValue = 1;
                                  durationCtrl.text = '1';
                                  recalculateFinancials(getSelectedRoomRent());
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: bookingDurationType == 'month' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: bookingDurationType == 'month' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month_rounded, size: 14, color: bookingDurationType == 'month' ? Colors.white : const Color(0xFF0F766E)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Month',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: bookingDurationType == 'month' ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Day Button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setDialogState(() {
                                  bookingDurationType = 'day';
                                  bookingDurationValue = 3;
                                  durationCtrl.text = '3';
                                  recalculateFinancials(getSelectedRoomRent());
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: bookingDurationType == 'day' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: bookingDurationType == 'day' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.wb_sunny_rounded, size: 14, color: bookingDurationType == 'day' ? Colors.white : const Color(0xFFF59E0B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Day',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: bookingDurationType == 'day' ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),

                          // Hour Button
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setDialogState(() {
                                  bookingDurationType = 'hour';
                                  bookingDurationValue = 4;
                                  durationCtrl.text = '4';
                                  recalculateFinancials(getSelectedRoomRent());
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: bookingDurationType == 'hour' ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: bookingDurationType == 'hour' ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 14, color: bookingDurationType == 'hour' ? Colors.white : const Color(0xFF0284C7)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Hour',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: bookingDurationType == 'hour' ? Colors.white : const Color(0xFF334155),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Kitne Din / Time Ka Booking Hai (Duration Presets)
                      Text(
                        bookingDurationType == 'month'
                            ? 'Kitne Month Ka Booking Hai? (Duration in Months):'
                            : bookingDurationType == 'day'
                                ? 'Kitne Din Ka Booking Hai? (Duration in Days):'
                                : 'Kitne Ghante Ka Booking Hai? (Duration in Hours):',
                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),

                      // Quick Chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (bookingDurationType == 'month')
                            for (int m in [1, 2, 3, 6, 11, 12])
                              InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    bookingDurationValue = m;
                                    durationCtrl.text = m.toString();
                                    recalculateFinancials(getSelectedRoomRent());
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (int.tryParse(durationCtrl.text) == m) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: (int.tryParse(durationCtrl.text) == m) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                  ),
                                  child: Text(
                                    '$m ${m == 1 ? 'Month' : 'Months'}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: (int.tryParse(durationCtrl.text) == m) ? Colors.white : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ),

                          if (bookingDurationType == 'day')
                            for (int d in [1, 2, 3, 5, 7, 15, 30])
                              InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    bookingDurationValue = d;
                                    durationCtrl.text = d.toString();
                                    recalculateFinancials(getSelectedRoomRent());
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (int.tryParse(durationCtrl.text) == d) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: (int.tryParse(durationCtrl.text) == d) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                  ),
                                  child: Text(
                                    '$d ${d == 1 ? 'Day' : 'Days'}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: (int.tryParse(durationCtrl.text) == d) ? Colors.white : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ),

                          if (bookingDurationType == 'hour')
                            for (int h in [1, 2, 3, 4, 6, 8, 12, 24])
                              InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    bookingDurationValue = h;
                                    durationCtrl.text = h.toString();
                                    recalculateFinancials(getSelectedRoomRent());
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (int.tryParse(durationCtrl.text) == h) ? const Color(0xFF0F766E) : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: (int.tryParse(durationCtrl.text) == h) ? const Color(0xFF0F766E) : const Color(0xFFCBD5E1)),
                                  ),
                                  child: Text(
                                    '$h ${h == 1 ? 'Hour' : 'Hours'}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.bold,
                                      color: (int.tryParse(durationCtrl.text) == h) ? Colors.white : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Duration input & Move-in Date
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: durationCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: bookingDurationType == 'month' ? 'Months' : (bookingDurationType == 'day' ? 'Days' : 'Hours'),
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (val) {
                                setDialogState(() {
                                  recalculateFinancials(getSelectedRoomRent());
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: moveInCtrl,
                              decoration: InputDecoration(
                                labelText: bookingDurationType == 'hour' ? 'Booking Date' : 'Move-in / Start Date',
                                hintText: 'YYYY-MM-DD',
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // If Hourly, Show Check-in / Check-out time fields
                      if (bookingDurationType == 'hour') ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: checkInTimeCtrl,
                                decoration: const InputDecoration(labelText: 'Check-in Time', hintText: '10:00 AM', border: OutlineInputBorder(), isDense: true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: checkOutTimeCtrl,
                                decoration: const InputDecoration(labelText: 'Check-out Time', hintText: '04:00 PM', border: OutlineInputBorder(), isDense: true),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 10),

                      // Agreed Rent & Security Deposit
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: rentCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: bookingDurationType == 'month'
                                    ? 'Agreed Rent (₹/mo) *'
                                    : (bookingDurationType == 'day' ? 'Total Day Rent (₹) *' : 'Total Hour Rent (₹) *'),
                                border: const OutlineInputBorder(),
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: depCtrl,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Deposit (₹)', border: OutlineInputBorder(), isDense: true),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Live Summary Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF99F6E4)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              bookingDurationType == 'hour'
                                  ? Icons.timelapse_rounded
                                  : (bookingDurationType == 'day' ? Icons.wb_sunny_rounded : Icons.calendar_month_rounded),
                              size: 16,
                              color: const Color(0xFF0F766E),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bookingDurationType == 'hour'
                                    ? 'Stay: ${durationCtrl.text} Hours (${checkInTimeCtrl.text} to ${checkOutTimeCtrl.text}) · Total ₹${rentCtrl.text}'
                                    : bookingDurationType == 'day'
                                        ? 'Stay: ${durationCtrl.text} Days · Total ₹${rentCtrl.text} (Deposit: ₹${depCtrl.text})'
                                        : 'Lease: ${durationCtrl.text} Months · ₹${rentCtrl.text}/mo (Deposit: ₹${depCtrl.text})',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter customer full name.')));
                    return;
                  }
                  final phone = phoneCtrl.text.trim();
                  final email = emailCtrl.text.trim().isEmpty ? '${name.toLowerCase().replaceAll(' ', '')}@example.com' : emailCtrl.text.trim();

                  final rentNum = int.tryParse(rentCtrl.text) ?? 0;
                  final depNum = int.tryParse(depCtrl.text) ?? (rentNum * 2);
                  final custId = isEditing ? existingCustomer['id'] : 'cust_${DateTime.now().millisecondsSinceEpoch}';
                  final durVal = int.tryParse(durationCtrl.text) ?? 1;

                  // Find property & room metadata
                  Map<String, dynamic>? assignedProp;
                  Map<String, dynamic>? assignedRoom;
                  if (selectedPropId != 'NONE') {
                    for (var p in _properties) {
                      if (p['id'] == selectedPropId) {
                        assignedProp = p;
                        for (var r in p['rooms']) {
                          if (r['id'] == selectedRoomId) {
                            assignedRoom = r;
                            r['status'] = 'Rented';
                          }
                        }
                      }
                    }
                  }

                  setState(() {
                    if (isEditing) {
                      existingCustomer['name'] = name;
                      existingCustomer['phone'] = phone;
                      existingCustomer['email'] = email;
                      existingCustomer['type'] = type;
                      existingCustomer['kyc'] = kyc;
                      existingCustomer['bookingDurationType'] = bookingDurationType;
                      existingCustomer['bookingDurationValue'] = durVal;
                      existingCustomer['bookingStartTime'] = checkInTimeCtrl.text.trim();
                      existingCustomer['bookingEndTime'] = checkOutTimeCtrl.text.trim();
                      existingCustomer['assignedPropertyId'] = selectedPropId != 'NONE' ? selectedPropId : null;
                      existingCustomer['assignedRoomId'] = selectedRoomId != 'NONE' ? selectedRoomId : null;
                      existingCustomer['assignedPropertyTitle'] = assignedProp != null ? assignedProp['title'] : null;
                      existingCustomer['assignedRoomNumber'] = assignedRoom != null ? assignedRoom['roomNumber'] : null;
                      existingCustomer['monthlyRent'] = rentNum > 0 ? rentNum : null;
                      existingCustomer['securityDeposit'] = depNum > 0 ? depNum : null;
                      existingCustomer['moveInDate'] = moveInCtrl.text.trim();
                    } else {
                      _customers.insert(0, {
                        'id': custId,
                        'name': name,
                        'phone': phone,
                        'email': email,
                        'type': type,
                        'kyc': kyc,
                        'status': 'Active',
                        'bookingDurationType': bookingDurationType,
                        'bookingDurationValue': durVal,
                        'bookingStartTime': checkInTimeCtrl.text.trim(),
                        'bookingEndTime': checkOutTimeCtrl.text.trim(),
                        'assignedPropertyId': selectedPropId != 'NONE' ? selectedPropId : null,
                        'assignedRoomId': selectedRoomId != 'NONE' ? selectedRoomId : null,
                        'assignedPropertyTitle': assignedProp != null ? assignedProp['title'] : null,
                        'assignedRoomNumber': assignedRoom != null ? assignedRoom['roomNumber'] : null,
                        'monthlyRent': rentNum > 0 ? rentNum : null,
                        'securityDeposit': depNum > 0 ? depNum : null,
                        'moveInDate': moveInCtrl.text.trim(),
                      });
                    }

                    // Create / Update Active Rental lease
                    if (selectedPropId != 'NONE' && assignedProp != null && assignedRoom != null) {
                      final existingRentalIdx = _activeRentals.indexWhere((r) => r['customerId'] == custId);
                      final rentalData = {
                        'id': existingRentalIdx >= 0 ? _activeRentals[existingRentalIdx]['id'] : 'rent_${DateTime.now().millisecondsSinceEpoch}',
                        'customerId': custId,
                        'customerName': name,
                        'propertyId': selectedPropId,
                        'roomId': selectedRoomId,
                        'propertyTitle': assignedProp['title'],
                        'roomNumber': assignedRoom['roomNumber'],
                        'address': assignedProp['address'],
                        'bookingDurationType': bookingDurationType,
                        'bookingDurationValue': durVal,
                        'bookingStartTime': checkInTimeCtrl.text.trim(),
                        'bookingEndTime': checkOutTimeCtrl.text.trim(),
                        'monthlyRent': rentNum > 0 ? rentNum : assignedRoom['monthlyRent'],
                        'securityDeposit': depNum > 0 ? depNum : assignedRoom['securityDeposit'],
                        'startDate': moveInCtrl.text.trim().isEmpty ? '2026-10-01' : moveInCtrl.text.trim(),
                        'dueDay': 5,
                        'status': 'Active',
                        'agreementStatus': 'Countersigned & Legally Binding',
                        'isCurrentMonthPaid': false,
                      };

                      if (existingRentalIdx >= 0) {
                        _activeRentals[existingRentalIdx] = rentalData;
                      } else {
                        _activeRentals.insert(0, rentalData);
                      }
                    } else {
                      _activeRentals.removeWhere((r) => r['customerId'] == custId);
                    }
                  });

                  Navigator.pop(ctx);
                  final durationDesc = bookingDurationType == 'hour'
                      ? '$durVal Hours'
                      : (bookingDurationType == 'day' ? '$durVal Days' : '$durVal Months');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      selectedPropId != 'NONE' && assignedProp != null
                          ? '$name assigned to ${assignedProp['title']} (${assignedRoom?['roomNumber']}) for $durationDesc!'
                          : (isEditing ? 'Customer details updated!' : 'Customer added to directory!'),
                    ),
                  ));
                },
                child: Text(isEditing ? 'Save Changes' : 'Add Customer & Assign'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _confirmDeleteCustomer(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Customer'),
        content: Text('Are you sure you want to delete customer "${customer['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _customers.remove(customer);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Customer "${customer['name']}" removed.'),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _openOwnerFormDialog({Map<String, dynamic>? existingOwner}) {
    final isEditing = existingOwner != null;
    final nameCtrl = TextEditingController(text: isEditing ? existingOwner['name'] : '');
    final phoneCtrl = TextEditingController(text: isEditing ? existingOwner['phone'] : '');
    final countCtrl = TextEditingController(text: isEditing ? '${existingOwner['propertiesCount']}' : '1');
    String privacy = isEditing ? existingOwner['contactPrivacy'] : 'CALL_MSG_ON';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Landlord / Host' : 'Add Landlord / Host', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Host Name *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone (+91) *', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                TextField(controller: countCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Properties Count', border: OutlineInputBorder(), isDense: true)),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: privacy,
                  decoration: const InputDecoration(labelText: 'Contact Privacy', border: OutlineInputBorder(), isDense: true),
                  items: const [
                    DropdownMenuItem(value: 'CALL_MSG_ON', child: Text('Calls & SMS On')),
                    DropdownMenuItem(value: 'CALL_ON_MSG_OFF', child: Text('Calls On, SMS Off')),
                    DropdownMenuItem(value: 'CALL_OFF_MSG_ON', child: Text('Calls Off, SMS On')),
                    DropdownMenuItem(value: 'BOTH_OFF', child: Text('Masked / Privacy Mode')),
                  ],
                  onChanged: (val) => setDialogState(() => privacy = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
              onPressed: () {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                setState(() {
                  if (isEditing) {
                    existingOwner['name'] = nameCtrl.text.trim();
                    existingOwner['phone'] = phoneCtrl.text.trim();
                    existingOwner['propertiesCount'] = int.tryParse(countCtrl.text) ?? 1;
                    existingOwner['contactPrivacy'] = privacy;
                  } else {
                    _owners.insert(0, {
                      'id': 'owner_${DateTime.now().millisecondsSinceEpoch}',
                      'name': nameCtrl.text.trim(),
                      'phone': phoneCtrl.text.trim(),
                      'propertiesCount': int.tryParse(countCtrl.text) ?? 1,
                      'contactPrivacy': privacy,
                      'status': 'Active',
                    });
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(isEditing ? 'Landlord details updated!' : 'Landlord added to directory!'),
                ));
              },
              child: Text(isEditing ? 'Save' : 'Add Landlord'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteOwner(Map<String, dynamic> owner) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Landlord'),
        content: Text('Are you sure you want to delete landlord "${owner['name']}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _owners.remove(owner);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Landlord "${owner['name']}" removed.'),
              ));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // 3. MASTER ADMIN VIEW (Unified Single-Page Layout - All Sections)
  // ===================================================================
  Widget _buildAdminView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      children: [
        // Executive Status Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF115E59)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: const Color(0xFF0F766E).withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Control Center',
                      style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Text(
                      'Platform governance, KYC & live rental monitoring',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Live Sync', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 1. Pending Approvals Queue
        _buildAdminApprovalsTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 2. Rental Requests Queue
        _buildAdminRentalRequestsSection(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 3. Tenancy Agreements
        _buildAdminAgreementsSection(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 4. Customers Directory
        _buildAdminCustomersTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 5. Property Landlords & Hosts
        _buildAdminOwnersTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 6. Master Property Inventory
        _buildAdminPropertiesTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 7. Master Rent Ledger
        _buildAdminLedgerTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 8. Automated Rent Reminders
        _buildAdminRemindersTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 9. Complaints & Maintenance Tickets
        _buildAdminComplaintsTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 10. Security & Audit Logs
        _buildAdminAuditTab(),

        const SizedBox(height: 20),
        const Divider(color: Color(0xFFE2E8F0)),
        const SizedBox(height: 14),

        // 11. Governance Settings & Admin Team
        _buildAdminSettingsTab(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAdminRentalRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.inbox_rounded, color: Color(0xFF16A34A), size: 20),
            const SizedBox(width: 8),
            Text('Rental Requests Queue (${_rentalRequests.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ..._rentalRequests.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r['customerName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
                    child: Text(r['status'], style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Property: ${r['propertyTitle']} (${r['roomNumber']})', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              Text('Move-in: ${r['moveInDate']} · Tenure: ${r['durationMonths']} Months', style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAdminAgreementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.receipt_long_rounded, color: Color(0xFF4338CA), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Finalized Tenancy Agreements (${_activeRentals.length})',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._activeRentals.map((a) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${a['propertyTitle']} - ${a['roomNumber']}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('₹${a['monthlyRent']}/mo', style: const TextStyle(fontSize: 12, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              Text('Tenant: ${a['customerName']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.verified, size: 12, color: Color(0xFF059669)),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'UIDAI KYC Verified & Digitally Countersigned',
                      style: TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAdminCustomersTab() {
    final filteredCustomers = _customers.where((c) {
      if (_adminCustomerFilter == 'KYC_VERIFIED') return c['kyc'] == true;
      if (_adminCustomerFilter == 'KYC_PENDING') return c['kyc'] == false;
      if (_adminCustomerFilter == 'Working Professional') return c['type'] == 'Working Professional';
      if (_adminCustomerFilter == 'Students') return c['type'] == 'Students';
      if (_adminCustomerFilter == 'Family') return c['type'] == 'Family';
      return true;
    }).toList();

    final verifiedCount = _customers.where((c) => c['kyc'] == true).length;
    final pendingCount = _customers.where((c) => c['kyc'] == false).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people_alt_rounded, color: Color(0xFF0284C7), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Customers Directory (${_customers.length})',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expand / Collapse All Toggle
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      if (_expandedCustomerIds.length == _customers.length) {
                        _expandedCustomerIds.clear();
                      } else {
                        _expandedCustomerIds.addAll(_customers.map((c) => c['id'].toString()));
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFBAE6FD)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _expandedCustomerIds.length == _customers.length ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: const Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _expandedCustomerIds.length == _customers.length ? 'Collapse' : 'Expand',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () => _openCustomerFormDialog(),
                  icon: const Icon(Icons.person_add, size: 14),
                  label: const Text('Add Customer', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Filter Bar for Customer Directory
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_list_rounded, size: 14, color: Color(0xFF475569)),
                  const SizedBox(width: 6),
                  const Text('Filter Customers:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                    child: Text('$verifiedCount KYC · $pendingCount Pending', style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _adminCustomerFilter,
                    isDense: true,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Customers')),
                      DropdownMenuItem(value: 'KYC_VERIFIED', child: Text('Verified KYC')),
                      DropdownMenuItem(value: 'KYC_PENDING', child: Text('Pending KYC')),
                      DropdownMenuItem(value: 'Working Professional', child: Text('Professionals')),
                      DropdownMenuItem(value: 'Students', child: Text('Students')),
                      DropdownMenuItem(value: 'Family', child: Text('Family')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _adminCustomerFilter = val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of Customers with Expandable Accordions
        if (filteredCustomers.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('No customers match the selected filter.', style: TextStyle(color: Colors.grey, fontSize: 12))),
          )
        else
          ...filteredCustomers.map((c) {
            final isExpanded = _expandedCustomerIds.contains(c['id'].toString());

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isExpanded ? const Color(0xFFBAE6FD) : const Color(0xFFE2E8F0), width: isExpanded ? 1.5 : 1),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  // Clickable Header Accordion Bar
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedCustomerIds.remove(c['id'].toString());
                        } else {
                          _expandedCustomerIds.add(c['id'].toString());
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isExpanded ? const Color(0xFFBAE6FD) : const Color(0xFFE0F2FE),
                            child: const Icon(Icons.person, color: Color(0xFF0284C7), size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c['name'],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Icon(
                                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                      size: 18,
                                      color: const Color(0xFF0284C7),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text('+91 ${c['phone']} · ${c['email']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: c['kyc'] ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        c['kyc'] ? 'UIDAI KYC Verified' : 'KYC Pending',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: c['kyc'] ? const Color(0xFF059669) : const Color(0xFFD97706),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text('${c['type']}', style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Rented Property Badge with Duration (Month / Day / Hour)
                                if (c['assignedPropertyTitle'] != null) ...[
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF0FDF4),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFFA7F3D0)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.home_work_rounded, size: 11, color: Color(0xFF16A34A)),
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Text(
                                                '${c['assignedPropertyTitle']} (${c['assignedRoomNumber'] ?? 'Unit'}) · ₹${c['monthlyRent'] ?? 0}',
                                                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCCFBF1),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: const Color(0xFF99F6E4)),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              c['bookingDurationType'] == 'hour'
                                                  ? Icons.access_time_rounded
                                                  : (c['bookingDurationType'] == 'day' ? Icons.wb_sunny_rounded : Icons.calendar_month_rounded),
                                              size: 11,
                                              color: const Color(0xFF0F766E),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              c['bookingDurationType'] == 'hour'
                                                  ? '${c['bookingDurationValue'] ?? 4} Hrs Stay'
                                                  : (c['bookingDurationType'] == 'day'
                                                      ? '${c['bookingDurationValue'] ?? 3} Days Stay'
                                                      : '${c['bookingDurationValue'] ?? 11} Mo Lease'),
                                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ] else ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: const Text(
                                      'No Property Assigned (Prospect / Inquiry)',
                                      style: TextStyle(fontSize: 9, color: Color(0xFF64748B), fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0284C7)),
                                tooltip: 'Edit Customer & Property',
                                onPressed: () => _openCustomerFormDialog(existingCustomer: c),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                                tooltip: 'Delete Customer',
                                onPressed: () => _confirmDeleteCustomer(c),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded Details Dropdown
                  if (isExpanded) ...[
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Customer Profile & Verification Details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    c['kyc'] = !(c['kyc'] ?? false);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('KYC status updated to ${c['kyc'] ? 'Verified' : 'Pending'} for ${c['name']}!')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c['kyc'] ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c['kyc'] ? 'Revoke KYC' : 'Verify UIDAI KYC',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c['kyc'] ? Colors.red : const Color(0xFF059669)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('• Preferred City: ${c['city'] ?? 'Varanasi'}, Area: ${c['area'] ?? 'Lanka'}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                          Text('• Customer Category: ${c['type']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                          Text('• UIDAI Aadhaar Verification: ${c['kyc'] ? 'Verified via OTP (Aadhaar Seeded)' : 'Pending Customer Upload'}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),

                          // Assigned Rental Information Card
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: c['assignedPropertyTitle'] != null ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.vpn_key_rounded, size: 14, color: c['assignedPropertyTitle'] != null ? const Color(0xFF059669) : Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Assigned Property & Rental Agreement',
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c['assignedPropertyTitle'] != null ? const Color(0xFF059669) : const Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () => _openCustomerFormDialog(existingCustomer: c),
                                      child: const Text('Change', style: TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (c['assignedPropertyTitle'] != null) ...[
                                  Text('• Property: ${c['assignedPropertyTitle']}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                                  Text('• Unit / Room: ${c['assignedRoomNumber'] ?? 'Assigned Room'}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                                  Text(
                                    '• Duration: ${c['bookingDurationType'] == 'hour' ? '${c['bookingDurationValue'] ?? 4} Hours Stay (${c['bookingStartTime'] ?? '10:00 AM'} to ${c['bookingEndTime'] ?? '04:00 PM'})' : (c['bookingDurationType'] == 'day' ? '${c['bookingDurationValue'] ?? 3} Days Stay' : '${c['bookingDurationValue'] ?? 11} Months Lease')}',
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                                  ),
                                  Text('• Total Rent: ₹${c['monthlyRent'] ?? 0} · Security Deposit: ₹${c['securityDeposit'] ?? 0}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                                  Text('• Check-in / Move-in: ${c['moveInDate'] ?? '2026-10-01'} · Status: Active Tenancy', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                                ] else ...[
                                  const Text('No property currently rented to this customer.', style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 2),
                                  const Text('Tap "Change" or "Edit" to assign a property & room.', style: TextStyle(fontSize: 9.5, color: Color(0xFF0284C7))),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAdminOwnersTab() {
    final filteredOwners = _owners.where((o) {
      if (_adminOwnerFilter == 'CALL_MSG_ON') return o['contactPrivacy'] == 'CALL_MSG_ON';
      if (_adminOwnerFilter == 'BOTH_OFF') return o['contactPrivacy'] == 'BOTH_OFF';
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.business_rounded, color: Color(0xFFD97706), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Landlords & Hosts (${_owners.length})',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expand / Collapse All Toggle
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      if (_expandedAdminOwnerIds.length == _owners.length) {
                        _expandedAdminOwnerIds.clear();
                      } else {
                        _expandedAdminOwnerIds.addAll(_owners.map((o) => o['id'].toString()));
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _expandedAdminOwnerIds.length == _owners.length ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _expandedAdminOwnerIds.length == _owners.length ? 'Collapse' : 'Expand',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton.icon(
                  onPressed: () => _openOwnerFormDialog(),
                  icon: const Icon(Icons.add_business, size: 14),
                  label: const Text('Add Landlord', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD97706),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: const Size(0, 30),
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Filter Bar for Landlords Directory
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.filter_list_rounded, size: 14, color: Color(0xFF475569)),
                  SizedBox(width: 6),
                  Text('Filter Hosts:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _adminOwnerFilter,
                    isDense: true,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Hosts')),
                      DropdownMenuItem(value: 'CALL_MSG_ON', child: Text('Calls ON')),
                      DropdownMenuItem(value: 'BOTH_OFF', child: Text('Masked Privacy')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _adminOwnerFilter = val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // List of Landlords with Expandable Accordions
        ...filteredOwners.map((o) {
          final isExpanded = _expandedAdminOwnerIds.contains(o['id'].toString());

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isExpanded ? const Color(0xFFFDE68A) : const Color(0xFFE2E8F0), width: isExpanded ? 1.5 : 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedAdminOwnerIds.remove(o['id'].toString());
                      } else {
                        _expandedAdminOwnerIds.add(o['id'].toString());
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFEF3C7),
                          child: const Icon(Icons.business_center, color: Color(0xFFD97706), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      o['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: const Color(0xFFD97706),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text('+91 ${o['phone']} · ${o['propertiesCount']} Properties Listed', style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                              Text('Privacy: ${o['contactPrivacy']}', style: const TextStyle(fontSize: 10, color: Color(0xFF0284C7), fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              icon: const Icon(Icons.edit, size: 18, color: Color(0xFF0284C7)),
                              tooltip: 'Edit Landlord',
                              onPressed: () => _openOwnerFormDialog(existingOwner: o),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                              icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Landlord',
                              onPressed: () => _confirmDeleteOwner(o),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded) ...[
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• Total Managed Buildings: ${o['propertiesCount']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                        Text('• Landlord Phone: +91 ${o['phone']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                        Text('• Privacy Routing Status: ${o['contactPrivacy']}', style: const TextStyle(fontSize: 10.5, color: Color(0xFF475569))),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAdminPropertiesTab() {
    final filteredProps = _properties.where((p) {
      if (_adminPropertyFilter == 'URBAN') return p['areaType'] == 'urban';
      if (_adminPropertyFilter == 'RURAL') return p['areaType'] == 'rural';
      if (_adminPropertyFilter == 'AVAILABLE') {
        return (p['rooms'] as List).any((r) => r['status'] == 'Available');
      }
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  const Icon(Icons.home_work_rounded, color: Color(0xFF0F766E), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Property Inventory (${filteredProps.length}/${_properties.length})',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            ElevatedButton.icon(
              onPressed: () => _openPropertyFormDialog(),
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add Property', style: TextStyle(fontSize: 11)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: const Size(90, 32),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Filter Bar & Expand/Collapse All
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filter Dropdown
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Filter: ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                  DropdownButton<String>(
                    value: _adminPropertyFilter,
                    isDense: true,
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                    icon: const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF0F766E)),
                    onChanged: (val) {
                      if (val != null) setState(() => _adminPropertyFilter = val);
                    },
                    items: const [
                      DropdownMenuItem(value: 'ALL', child: Text('All Properties')),
                      DropdownMenuItem(value: 'URBAN', child: Text('Urban Cities')),
                      DropdownMenuItem(value: 'RURAL', child: Text('Rural / Villages')),
                      DropdownMenuItem(value: 'AVAILABLE', child: Text('With Available Units')),
                    ],
                  ),
                ],
              ),
              // Expand / Collapse All Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_expandedAdminPropertyIds.length == filteredProps.length) {
                      _expandedAdminPropertyIds.clear();
                    } else {
                      _expandedAdminPropertyIds.addAll(filteredProps.map((e) => e['id'].toString()));
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _expandedAdminPropertyIds.length == filteredProps.length
                            ? Icons.unfold_less_rounded
                            : Icons.unfold_more_rounded,
                        size: 14,
                        color: const Color(0xFF0F766E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _expandedAdminPropertyIds.length == filteredProps.length ? 'Collapse All' : 'Expand All',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF0F766E)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // List of Property Accordions
        ...filteredProps.map((p) {
          final isExpanded = _expandedAdminPropertyIds.contains(p['id']);
          final rooms = p['rooms'] as List;
          final availableCount = rooms.where((r) => r['status'] == 'Available').length;
          final rentedCount = rooms.where((r) => r['status'] == 'Rented').length;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isExpanded ? const Color(0xFF0F766E).withValues(alpha: 0.5) : const Color(0xFFE2E8F0),
                width: isExpanded ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isExpanded ? 0.06 : 0.02),
                  blurRadius: isExpanded ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Accordion Header (Clickable to Expand / Collapse)
                InkWell(
                  borderRadius: BorderRadius.vertical(
                    top: const Radius.circular(14),
                    bottom: Radius.circular(isExpanded ? 0 : 14),
                  ),
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedAdminPropertyIds.remove(p['id']);
                      } else {
                        _expandedAdminPropertyIds.add(p['id']);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Thumbnail
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                p['image'] ?? (p['images'] != null && (p['images'] as List).isNotEmpty ? p['images'][0] : ''),
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCCFBF1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.apartment_rounded, color: Color(0xFF0F766E), size: 22),
                                ),
                              ),
                            ),
                            if (p['images'] != null && (p['images'] as List).length > 1)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${(p['images'] as List).length}',
                                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        // Property Title & Metadata
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      p['title'],
                                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13.5, color: const Color(0xFF0F172A)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFECFDF5),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFFA7F3D0)),
                                    ),
                                    child: const Text('Approved', style: TextStyle(fontSize: 8.5, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${p['address']}',
                                style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              // Badges row: Urban/Rural + Units count + Toggle Chevron
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: p['areaType'] == 'urban' ? const Color(0xFFE0F2FE) : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      p['areaType'].toString().toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                        color: p['areaType'] == 'urban' ? const Color(0xFF0369A1) : const Color(0xFFB45309),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${rooms.length} Units ($availableCount Avail · $rentedCount Rented)',
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Actions & Accordion Arrow
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                              icon: const Icon(Icons.edit, size: 17, color: Color(0xFF0284C7)),
                              tooltip: 'Edit Property',
                              onPressed: () => _openPropertyFormDialog(existingProp: p),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                              icon: const Icon(Icons.delete_outline, size: 17, color: Color(0xFFDC2626)),
                              tooltip: 'Delete Property',
                              onPressed: () => _confirmDeleteProperty(p),
                            ),
                            const SizedBox(width: 2),
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: isExpanded ? const Color(0xFFCCFBF1) : const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: const Color(0xFF0F766E),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Collapsible Dropdown Content
                if (isExpanded) ...[
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Metadata Summary
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.person_pin_rounded, size: 15, color: Color(0xFF0F766E)),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Owner: ${p['ownerName']} (+91 ${p['ownerPhone']})',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.amber),
                                      const SizedBox(width: 2),
                                      Text('${p['rating']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Type: ${p['propertyType'].toString().toUpperCase()} · City: ${p['city']} · Locality: ${p['locality']}',
                                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Units Section Header & Add Unit Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Managed Units / Rooms (${rooms.length})',
                              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12.5, color: const Color(0xFF0F172A)),
                            ),
                            GestureDetector(
                              onTap: () => _openUnitFormDialog(p),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F766E),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(Icons.add, size: 12, color: Colors.white),
                                    SizedBox(width: 2),
                                    Text('Add Unit', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Unit Cards with Status Dropdown
                        ...rooms.map<Widget>((r) {
                          final currentStatus = r['status'].toString();
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            r['roomNumber'],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A)),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '₹${r['monthlyRent']}/mo',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F766E)),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '(${r['roomType']})',
                                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Deposit: ₹${r['securityDeposit']} · ${r['furnishing']} · Floor ${r['floor']}',
                                        style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B)),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),

                                // Room Status Selector Dropdown (Available / Rented / Maintenance)
                                PopupMenuButton<String>(
                                  tooltip: 'Change Unit Status',
                                  onSelected: (newStatus) {
                                    setState(() {
                                      r['status'] = newStatus;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${r['roomNumber']} status set to $newStatus!'),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Available',
                                      child: Row(
                                        children: [
                                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
                                          const SizedBox(width: 8),
                                          const Text('Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Rented',
                                      child: Row(
                                        children: [
                                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
                                          const SizedBox(width: 8),
                                          const Text('Rented', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Maintenance',
                                      child: Row(
                                        children: [
                                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
                                          const SizedBox(width: 8),
                                          const Text('Maintenance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: currentStatus == 'Available'
                                          ? const Color(0xFFD1FAE5)
                                          : currentStatus == 'Rented'
                                              ? const Color(0xFFFEE2E2)
                                              : const Color(0xFFFEF3C7),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: currentStatus == 'Available'
                                            ? const Color(0xFF10B981)
                                            : currentStatus == 'Rented'
                                                ? const Color(0xFFEF4444)
                                                : const Color(0xFFF59E0B),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: currentStatus == 'Available'
                                                ? const Color(0xFF059669)
                                                : currentStatus == 'Rented'
                                                    ? const Color(0xFFDC2626)
                                                    : const Color(0xFFD97706),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          currentStatus,
                                          style: TextStyle(
                                            color: currentStatus == 'Available'
                                                ? const Color(0xFF065F46)
                                                : currentStatus == 'Rented'
                                                    ? const Color(0xFF991B1B)
                                                    : const Color(0xFF92400E),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 9.5,
                                          ),
                                        ),
                                        const SizedBox(width: 1),
                                        Icon(
                                          Icons.arrow_drop_down,
                                          size: 14,
                                          color: currentStatus == 'Available'
                                              ? const Color(0xFF065F46)
                                              : currentStatus == 'Rented'
                                                  ? const Color(0xFF991B1B)
                                                  : const Color(0xFF92400E),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  void _openUnitFormDialog(Map<String, dynamic> property, {Map<String, dynamic>? existingRoom}) {
    final roomNumCtrl = TextEditingController(text: existingRoom?['roomNumber'] ?? 'Room ${((property['rooms'] as List).length + 1) * 100 + 1}');
    final rentCtrl = TextEditingController(text: existingRoom != null ? existingRoom['monthlyRent'].toString() : '8000');
    final depCtrl = TextEditingController(text: existingRoom != null ? existingRoom['securityDeposit'].toString() : '16000');
    String roomType = existingRoom?['roomType'] ?? 'Single Room';
    String furnishing = existingRoom?['furnishing'] ?? 'Furnished';
    String status = existingRoom?['status'] ?? 'Available';
    int floor = existingRoom?['floor'] ?? 1;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            existingRoom == null ? 'Add Unit to ${property['title']}' : 'Edit ${existingRoom['roomNumber']}',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: roomNumCtrl,
                  decoration: const InputDecoration(labelText: 'Unit / Room Number', hintText: 'e.g. Room 105 or Flat 302'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: roomType,
                  decoration: const InputDecoration(labelText: 'Room Type'),
                  items: const [
                    DropdownMenuItem(value: 'Single Room', child: Text('Single Room')),
                    DropdownMenuItem(value: 'Shared Room', child: Text('Shared Room')),
                    DropdownMenuItem(value: '1 BHK Flat', child: Text('1 BHK Flat')),
                    DropdownMenuItem(value: '2 BHK Flat', child: Text('2 BHK Flat')),
                    DropdownMenuItem(value: '3 BHK Flat', child: Text('3 BHK Flat')),
                    DropdownMenuItem(value: 'PG Bed', child: Text('PG Bed')),
                    DropdownMenuItem(value: 'Godown Shed', child: Text('Godown Shed')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => roomType = val);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: rentCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monthly Rent (₹)'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: depCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Security Deposit (₹)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: furnishing,
                  decoration: const InputDecoration(labelText: 'Furnishing'),
                  items: const [
                    DropdownMenuItem(value: 'Furnished', child: Text('Furnished')),
                    DropdownMenuItem(value: 'Semi-Furnished', child: Text('Semi-Furnished')),
                    DropdownMenuItem(value: 'Unfurnished', child: Text('Unfurnished')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => furnishing = val);
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(value: 'Available', child: Text('Available')),
                    DropdownMenuItem(value: 'Rented', child: Text('Rented')),
                    DropdownMenuItem(value: 'Maintenance', child: Text('Maintenance')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => status = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E), foregroundColor: Colors.white),
              onPressed: () {
                final rent = int.tryParse(rentCtrl.text) ?? 8000;
                final dep = int.tryParse(depCtrl.text) ?? (rent * 2);
                setState(() {
                  if (existingRoom != null) {
                    existingRoom['roomNumber'] = roomNumCtrl.text;
                    existingRoom['roomType'] = roomType;
                    existingRoom['monthlyRent'] = rent;
                    existingRoom['securityDeposit'] = dep;
                    existingRoom['furnishing'] = furnishing;
                    existingRoom['status'] = status;
                  } else {
                    (property['rooms'] as List).add({
                      'id': 'room_${DateTime.now().millisecondsSinceEpoch}',
                      'roomNumber': roomNumCtrl.text,
                      'roomType': roomType,
                      'monthlyRent': rent,
                      'securityDeposit': dep,
                      'furnishing': furnishing,
                      'floor': floor,
                      'status': status,
                      'suitableFor': ['student', 'bachelor', 'family'],
                    });
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unit ${roomNumCtrl.text} saved successfully!')),
                );
              },
              child: Text(existingRoom == null ? 'Add Unit' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminApprovalsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.hourglass_top_rounded, color: Color(0xFFB45309), size: 20),
            const SizedBox(width: 8),
            Text('Pending Property Approvals (1)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Royal Heritage Villa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Pending Review', style: TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Host: Rajesh Pandey (+91 9450012345)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const Text('Location: Gomti Nagar, Lucknow (Urban)', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const Text('Monthly Rent: ₹35,000 · Security Deposit: ₹70,000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Royal Heritage Villa Approved & Published Live!')));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                      child: const Text('Approve Listing', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing rejected and host notified.')));
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFDC2626)),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminLedgerTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF059669), size: 20),
            const SizedBox(width: 8),
            Text('Master Monthly Rent Ledger', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ..._rentPayments.map((p) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${p['amount']} (${p['month']})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E))),
                    Text('Due: ${p['dueDate']} · Mode: ${p['mode'] ?? 'Pending'}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (p['status'] == 'Pending') {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Container(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.payment_rounded, color: Color(0xFF059669)),
                                const SizedBox(width: 8),
                                Text('Record Rent Payment', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Amount: ₹${p['amount']} · Month: ${p['month']}'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                setState(() {
                                  p['status'] = 'Paid';
                                  p['mode'] = 'UPI';
                                  p['paymentDate'] = '2026-10-01';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rent marked as Paid via UPI!')));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                              child: const Text('Mark as Paid via UPI', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Receipt already generated for this payment.')));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: p['status'] == 'Paid' ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: p['status'] == 'Paid' ? const Color(0xFFA7F3D0) : const Color(0xFFFDE68A)),
                  ),
                  child: Text(
                    p['status'] == 'Paid' ? 'Paid' : 'Record Paid',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: p['status'] == 'Paid' ? const Color(0xFF059669) : const Color(0xFFD97706)),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAdminRemindersTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.notifications_active_rounded, color: Color(0xFF0284C7), size: 20),
                const SizedBox(width: 8),
                Text('Automated Rent Reminders', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rent Reminder dispatched to tenant Amit Sharma!')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(80, 30),
              ),
              child: const Text('+ Send', style: TextStyle(fontSize: 11, color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Amit Sharma (Ganga Heights)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Delivered', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              const Text('Due: 5 Oct 2026 · Amount: ₹14,000 · Channel: In-App + SMS', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminComplaintsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.build_circle_rounded, color: Color(0xFFB91C1C), size: 20),
            const SizedBox(width: 8),
            Text('Complaints & Maintenance Tickets', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ..._complaints.map((c) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(c['subject'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis)),
                  Text(c['status'], style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 10)),
                ],
              ),
              Text('Filed by: ${c['user']} · Category: ${c['category']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(6)),
                child: Text('"${c['desc']}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
              ),
              if (c['adminReply'] != null) ...[
                const SizedBox(height: 6),
                Text('Admin Reply: ${c['adminReply']}', style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
              ],
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    c['status'] = 'Resolved';
                    c['adminReply'] = 'Issue verified and repaired by maintenance staff.';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complaint resolved and tenant notified!')));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF059669),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: const Size(100, 30),
                ),
                child: const Text('Resolve Ticket', style: TextStyle(fontSize: 11, color: Colors.white)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAdminAuditTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.security_rounded, color: Color(0xFF4F46E5), size: 20),
            const SizedBox(width: 8),
            Text('Security & Audit Logs (${_auditLogs.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ..._auditLogs.map((l) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l['action'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0284C7))),
                    Text('${l['module']} · ${l['newValue']} · IP: ${l['ip']}', style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Text(l['timestamp'], style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildAdminSettingsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.admin_panel_settings_rounded, color: Color(0xFF0F766E), size: 20),
            const SizedBox(width: 8),
            Text('Governance Settings', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Column(
            children: const [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Require Property Approval', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('New listings must be approved by admin', style: TextStyle(fontSize: 11)),
                trailing: Icon(Icons.check_circle, color: Color(0xFF059669)),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Aadhaar e-KYC Verification', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('Required for digital tenancy agreements', style: TextStyle(fontSize: 11)),
                trailing: Icon(Icons.check_circle, color: Color(0xFF059669)),
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Automated Rent Reminders', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: Text('4 days advance notice via In-App + SMS', style: TextStyle(fontSize: 11)),
                trailing: Icon(Icons.check_circle, color: Color(0xFF059669)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(Icons.group_rounded, color: Color(0xFF0F766E), size: 18),
            const SizedBox(width: 8),
            Text('Admin Team & Role-Based Access (${_adminUsers.length})', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 10),
        ..._adminUsers.map((u) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFF1F5F9),
                child: Text(u['name'][0], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(u['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text('${u['email']} · Role: ${u['role']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(6)),
                child: Text(u['status'], style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
