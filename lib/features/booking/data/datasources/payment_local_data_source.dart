import 'package:fix_it/features/booking/data/models/payment_method_model.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentMethodModel>> getCachedPaymentMethods();
  Future<void> cachePaymentMethods(List<PaymentMethodModel> paymentMethods);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  // In a real app, this would use shared_preferences, hive, or another local storage solution
  final Map<String, dynamic> _cache = {};

  @override
  Future<List<PaymentMethodModel>> getCachedPaymentMethods() async {
    // In a real app, this would retrieve the payment methods from local storage
    // For now, we'll return mock data if available in the cache
    if (_cache.containsKey('payment_methods')) {
      return _cache['payment_methods'];
    } else {
      // Return empty list if no cached data
      return [];
    }
  }

  @override
  Future<void> cachePaymentMethods(List<PaymentMethodModel> paymentMethods) async {
    // In a real app, this would save the payment methods to local storage
    // For now, we'll just store them in the in-memory cache
    _cache['payment_methods'] = paymentMethods;
  }
}
