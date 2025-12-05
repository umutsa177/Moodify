import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseProvider extends ChangeNotifier {
  CustomerInfo? _customerInfo;
  List<Package> _availablePackages = [];
  bool _isLoading = false;

  CustomerInfo? get customerInfo => _customerInfo;
  List<Package> get availablePackages => _availablePackages;
  bool get isLoading => _isLoading;
  bool get isPremium => _customerInfo?.entitlements.active.isNotEmpty ?? false;

  static const String _testStoreApiKey = 'test_ruORoRZllQQLXTAsQYKaXPEEkYf';

  static const String _iosProductionKey = 'appl_YOUR_IOS_KEY_HERE';
  static const String _androidProductionKey = 'goog_YOUR_ANDROID_KEY_HERE';

  static const bool _useTestMode = true;

  // Initialize RevenueCat
  Future<void> initialize() async {
    try {
      PurchasesConfiguration configuration;

      if (_useTestMode) {
        if (kDebugMode) {
          log('RevenueCat: Test mode - Using Test Store API key');
        }
        configuration = PurchasesConfiguration(_testStoreApiKey);
      } else {
        // PRODUCTION MODE
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          if (kDebugMode) {
            log('RevenueCat: Production mode - Using iOS API key');
          }
          configuration = PurchasesConfiguration(_iosProductionKey);
        } else if (defaultTargetPlatform == TargetPlatform.android) {
          if (kDebugMode) {
            log('RevenueCat: Production mode - Using Android API key');
          }
          configuration = PurchasesConfiguration(_androidProductionKey);
        } else {
          if (kDebugMode) log('RevenueCat: Unsupported platform');
          return;
        }
      }

      if (kDebugMode) {
        await Purchases.setLogLevel(LogLevel.debug);
      }

      await Purchases.configure(configuration);

      await refreshCustomerInfo();

      await loadOfferings();

      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

      if (kDebugMode) log('RevenueCat initialized successfully');
    } on Exception catch (e) {
      if (kDebugMode) log('RevenueCat initialization error: $e');
    }
  }

  // Refresh customer info
  Future<void> refreshCustomerInfo() async {
    try {
      _customerInfo = await Purchases.getCustomerInfo();
      notifyListeners();
    } on Exception catch (e) {
      if (kDebugMode) log('Error refreshing customer info: $e');
    }
  }

  // Load offerings
  Future<void> loadOfferings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final offerings = await Purchases.getOfferings();

      if (offerings.current != null) {
        _availablePackages = offerings.current!.availablePackages;
        if (kDebugMode) {
          log('Loaded ${_availablePackages.length} packages');
        }
      } else {
        if (kDebugMode) log('No current offering available');
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Error loading offerings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Purchase package
  Future<bool> purchasePackage(Package package) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (kDebugMode) {
        log('Attempting to purchase: ${package.storeProduct.identifier}');
      }

      final purchaseResult = await Purchases.purchase(
        PurchaseParams.package(package),
      );

      _customerInfo = purchaseResult.customerInfo;

      final success =
          purchaseResult.customerInfo.entitlements.active.isNotEmpty;

      if (kDebugMode) {
        log('Purchase ${success ? "successful" : "failed"}');
      }

      return success;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        log('Purchase error: ${e.code} - ${e.message}');
      }
      return false;
    } on Exception catch (e) {
      if (kDebugMode) log('Purchase error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Restore purchases
  Future<void> restorePurchases() async {
    try {
      _isLoading = true;
      notifyListeners();

      if (kDebugMode) log('Restoring purchases...');

      _customerInfo = await Purchases.restorePurchases();

      if (kDebugMode) {
        log('Purchases restored. Premium: $isPremium');
      }
    } on Exception catch (e) {
      if (kDebugMode) log('Restore error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // When customer info is updated
  void _onCustomerInfoUpdate(CustomerInfo info) {
    if (kDebugMode) log('Customer info updated');
    _customerInfo = info;
    notifyListeners();
  }

  @override
  void dispose() {
    Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdate);
    super.dispose();
  }
}
