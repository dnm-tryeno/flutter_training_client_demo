import 'package:flutter/material.dart';
import 'models/scrap_model.dart';
import 'state/scrap_state.dart';
import 'theme/app_theme.dart';
import 'widgets/demo_mode_banner.dart';
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/customer_home_page.dart';
import 'pages/vendor_home_page.dart';
import 'pages/request_booking_page.dart';
import 'pages/order_tracking_page.dart';
import 'pages/rate_card_page.dart';
import 'pages/rewards_page.dart';
import 'pages/order_history_page.dart';
import 'pages/profile_page.dart';
import 'pages/rider_agent_page.dart';
import 'pages/admin_panel_page.dart';

class ScrapRecyclingApp extends StatefulWidget {
  const ScrapRecyclingApp({super.key});

  @override
  State<ScrapRecyclingApp> createState() => _ScrapRecyclingAppState();
}

class _ScrapRecyclingAppState extends State<ScrapRecyclingApp> {
  late final ScrapState _state;
  bool _hasSeenSplash = false;

  @override
  void initState() {
    super.initState();
    _state = ScrapState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrapStateScope(
      notifier: _state,
      child: ListenableBuilder(
        listenable: _state,
        builder: (context, _) {
          return MaterialApp(
            title: 'KABADA - Smart Scrap Recycling',
            debugShowCheckedModeBanner: false,
            theme: ScrapAppTheme.lightTheme(),
            darkTheme: ScrapAppTheme.darkTheme(),
            themeMode: _state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: !_hasSeenSplash
                ? ScrapSplashScreen(
                    onFinish: () {
                      setState(() {
                        _hasSeenSplash = true;
                      });
                    },
                  )
                : !_state.isLoggedIn
                    ? ScrapLoginPage(
                        onLoginSuccess: () {
                          // Logged in
                        },
                      )
                    : const _MainScrapShell(),
          );
        },
      ),
    );
  }
}

class _MainScrapShell extends StatefulWidget {
  const _MainScrapShell();

  @override
  State<_MainScrapShell> createState() => _MainScrapShellState();
}

class _MainScrapShellState extends State<_MainScrapShell> {
  int _currentIndex = 0;

  void _openBookingWizard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RequestBookingPage(
          onBookingCompleted: (order) {
            Navigator.of(ctx).pushReplacement(
              MaterialPageRoute(
                builder: (_) => OrderTrackingPage(order: order),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openTracking(BuildContext context, PickupRequest order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderTrackingPage(order: order),
      ),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrderHistoryPage(
          onOpenOrderTracking: (order) => _openTracking(context, order),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ScrapStateScope.of(context);
    final role = state.previewMode;

    Widget body;
    if (role == UserRole.rider) {
      body = const RiderAgentPage();
    } else if (role == UserRole.admin) {
      body = const AdminPanelPage();
    } else if (role == UserRole.vendor) {
      body = _buildVendorShell(context);
    } else {
      body = _buildCustomerShell(context);
    }

    final showBottomNav = role == UserRole.customer || role == UserRole.vendor;

    return Scaffold(
      body: Column(
        children: [
          // Top Demo Mode Persona Switcher
          const DemoModeBanner(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: _currentIndex.clamp(0, 3),
              onDestinationSelected: (idx) {
                setState(() {
                  _currentIndex = idx;
                });
              },
              destinations: role == UserRole.vendor
                  ? const [
                      NavigationDestination(
                        icon: Icon(Icons.warehouse_outlined),
                        selectedIcon: Icon(Icons.warehouse_rounded),
                        label: 'Godown',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.currency_rupee_rounded),
                        selectedIcon: Icon(Icons.currency_rupee_rounded),
                        label: 'Rate List',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.inventory_2_outlined),
                        selectedIcon: Icon(Icons.inventory_2_rounded),
                        label: 'Pickups',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(Icons.person_rounded),
                        label: 'Profile',
                      ),
                    ]
                  : const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home_rounded),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.receipt_long_outlined),
                        selectedIcon: Icon(Icons.receipt_long_rounded),
                        label: 'Rate List',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.card_giftcard_outlined),
                        selectedIcon: Icon(Icons.card_giftcard_rounded),
                        label: 'Rewards',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.person_outline_rounded),
                        selectedIcon: Icon(Icons.person_rounded),
                        label: 'Profile',
                      ),
                    ],
            )
          : null,
    );
  }

  Widget _buildCustomerShell(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return CustomerHomePage(
          onOpenBookPickup: () => _openBookingWizard(context),
          onOpenRateCard: () => setState(() => _currentIndex = 1),
          onOpenOrderHistory: () => _openHistory(context),
          onOpenOrderTracking: (order) => _openTracking(context, order),
        );
      case 1:
        return RateCardPage(
          onOpenBookPickup: () => _openBookingWizard(context),
        );
      case 2:
        return RewardsPage(
          onOpenBookPickup: () => _openBookingWizard(context),
        );
      case 3:
        return ProfilePage(
          onOpenOrderHistory: () => _openHistory(context),
        );
      default:
        return CustomerHomePage(
          onOpenBookPickup: () => _openBookingWizard(context),
          onOpenRateCard: () => setState(() => _currentIndex = 1),
          onOpenOrderHistory: () => _openHistory(context),
          onOpenOrderTracking: (order) => _openTracking(context, order),
        );
    }
  }

  Widget _buildVendorShell(BuildContext context) {
    switch (_currentIndex) {
      case 0:
        return VendorHomePage(
          onOpenBookPickup: () => _openBookingWizard(context),
          onOpenOrderTracking: (order) => _openTracking(context, order),
        );
      case 1:
        return RateCardPage(
          onOpenBookPickup: () => _openBookingWizard(context),
        );
      case 2:
        return OrderHistoryPage(
          onOpenOrderTracking: (order) => _openTracking(context, order),
        );
      case 3:
        return ProfilePage(
          onOpenOrderHistory: () => _openHistory(context),
        );
      default:
        return VendorHomePage(
          onOpenBookPickup: () => _openBookingWizard(context),
          onOpenOrderTracking: (order) => _openTracking(context, order),
        );
    }
  }
}
