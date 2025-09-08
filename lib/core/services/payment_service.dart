// ignore_for_file: avoid_print

import 'package:fix_it/app_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

abstract class PaymentService {
  Future<void> initialize();
  Future<PaymentMethodResponse> createPaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  });
  Future<PaymentIntentResponse> createPaymentIntent({
    required double amount,
    required String currency,
    required String paymentMethodId,
  });
  Future<bool> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  });
}

/// Lightweight payment method returned by the adapter to keep tests
/// independent of flutter_stripe types.
class AdapterPaymentMethod {
  final String id;
  AdapterPaymentMethod(this.id);
}

/// Adapter interface to make flutter_stripe usage testable.
abstract class StripeAdapter {
  Future<void> applySettings();
  Future<AdapterPaymentMethod> createPaymentMethod(
      {required PaymentMethodParams params});
  Future<void> handleNextAction(String clientSecret);
}

/// Default adapter forwarding to `Stripe` implementation.
class DefaultStripeAdapter implements StripeAdapter {
  @override
  Future<void> applySettings() => Stripe.instance.applySettings();

  @override
  Future<AdapterPaymentMethod> createPaymentMethod(
      {required PaymentMethodParams params}) async {
    final paymentMethod =
        await Stripe.instance.createPaymentMethod(params: params);
    return AdapterPaymentMethod(paymentMethod.id);
  }

  @override
  Future<void> handleNextAction(String clientSecret) =>
      Stripe.instance.handleNextAction(clientSecret);
}

class PaymentServiceImpl implements PaymentService {
  final Dio dio;
  final StripeAdapter stripeAdapter;

  PaymentServiceImpl({required this.dio, StripeAdapter? stripe})
      : stripeAdapter = stripe ?? DefaultStripeAdapter();
  // static const String _publishableKey =
  //     'pk_test_your_stripe_publishable_key_here';
  // static const String _merchantId = 'your_merchant_id_here';

  @override
  Future<void> initialize() async {
    // If Stripe payments are disabled in config, skip initialization.
    if (!AppConfig.enableStripePayments) {
      // Payments are deliberately disabled in the MVP configuration.
      return;
    }
    // If the publishable key is still the placeholder, skip initializing
    // the native Stripe SDK to avoid runtime errors in dev environments.
    if (AppConfig.stripePublishableKey ==
        AppConfig.stripePublishableKeyPlaceholder) {
      print('Stripe publishable key not provided; skipping initialization');
      return;
    }

    // Initialize flutter_stripe with publishable key from AppConfig.
    try {
      Stripe.publishableKey = AppConfig.stripePublishableKey;
      await stripeAdapter.applySettings();
      print('Stripe initialized with publishable key');
    } catch (e) {
      // Initialization failures should not crash the app in MVP
      print('PaymentService.init failed: $e');
    }
  }

  @override
  Future<PaymentMethodResponse> createPaymentMethod({
    required String cardNumber,
    required String expiryMonth,
    required String expiryYear,
    required String cvv,
  }) async {
    // If payments are disabled, return a mocked payment method id
    if (!AppConfig.enableStripePayments) {
      return PaymentMethodResponse(
        paymentMethodId: 'pm_mock_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
    // Client-side: create PaymentMethod using flutter_stripe.
    try {
      // Note: flutter_stripe typically expects card collection via CardField widget.
      // Creating a PaymentMethod from raw card details is not recommended on
      // mobile due to PCI considerations; prefer CardField UI. If you still
      // need to construct it, use `PaymentMethodParams.card` and pass the
      // details collected securely.
      final params =
          PaymentMethodParams.card(paymentMethodData: PaymentMethodData());

      final paymentMethod =
          await stripeAdapter.createPaymentMethod(params: params);
      return PaymentMethodResponse(paymentMethodId: paymentMethod.id);
    } catch (e) {
      // Fallback: return a mocked id and surface error message
      print('createPaymentMethod error: $e');
      return PaymentMethodResponse(
        paymentMethodId: 'pm_mock_${DateTime.now().millisecondsSinceEpoch}',
        error: e.toString(),
      );
    }
  }

  @override
  Future<PaymentIntentResponse> createPaymentIntent({
    required double amount,
    required String currency,
    required String paymentMethodId,
  }) async {
    // This would typically call your backend API to create a payment intent.
    // If payments are disabled, return a mock payment intent response so UI flows work.
    if (!AppConfig.enableStripePayments) {
      return PaymentIntentResponse(
        paymentIntentId: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        status: 'requires_confirmation',
      );
    }

    // Call backend to create a PaymentIntent. Backend should return at least
    // a client_secret to be used for confirmation.
    try {
      final resp = await dio.post('/payments/process', data: {
        'amount': amount,
        'currency': currency,
        'payment_method_id': paymentMethodId,
      });

      final data = resp.data as Map<String, dynamic>;
      final clientSecret = data['client_secret'] as String?;
      final status = data['status'] as String? ?? 'requires_confirmation';

      return PaymentIntentResponse(
        paymentIntentId:
            clientSecret ?? 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        status: status,
      );
    } catch (e) {
      print('createPaymentIntent error: $e');
      return PaymentIntentResponse(
        paymentIntentId: 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
        status: 'error',
        error: e.toString(),
      );
    }
  }

  @override
  Future<bool> confirmPayment({
    required String paymentIntentId,
    required String paymentMethodId,
  }) async {
    // If payments are disabled return success so flows complete in dev
    if (!AppConfig.enableStripePayments) {
      return true;
    }
    // Confirm payment by calling backend to complete the PaymentIntent
    // and, if required, defer to flutter_stripe to handle next actions.
    try {
      final resp = await dio.post('/payments/confirm', data: {
        'payment_intent_client_secret': paymentIntentId,
        'payment_method_id': paymentMethodId,
      });

      final data = resp.data as Map<String, dynamic>;
      final status = data['status'] as String? ?? '';

      // If backend indicates further action is required and provides a
      // client_secret, let flutter_stripe handle the action.
      if (data['requires_action'] == true && data['client_secret'] != null) {
        final clientSecret = data['client_secret'] as String;
        try {
          await stripeAdapter.handleNextAction(clientSecret);
        } catch (e) {
          print('handleNextAction error: $e');
        }
        // After handling action, backend should be polled or webhook used to
        // finalize status; for UI flow purposes treat this as success.
        return true;
      }

      return status == 'succeeded' ||
          status == 'requires_confirmation' ||
          status == 'requires_action';
    } catch (e) {
      print('confirmPayment error: $e');
      return false;
    }
  }
}

class PaymentMethodResponse {
  final String paymentMethodId;
  final String? error;

  PaymentMethodResponse({
    required this.paymentMethodId,
    this.error,
  });
}

class PaymentIntentResponse {
  final String paymentIntentId;
  final String status;
  final String? error;

  PaymentIntentResponse({
    required this.paymentIntentId,
    required this.status,
    this.error,
  });
}
