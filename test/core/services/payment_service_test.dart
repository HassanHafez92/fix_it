import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fix_it/core/services/payment_service.dart';

Dio createMockDio(Map<String, dynamic> mockResponses) {
  final dio = Dio();
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    final res = mockResponses[options.path];
    if (res != null) {
      handler.resolve(
          Response(requestOptions: options, data: res, statusCode: 200));
    } else {
      handler.reject(DioException(
          requestOptions: options,
          error: 'No mock response for ${options.path}'));
    }
  }));
  return dio;
}

class _MockStripeAdapter implements StripeAdapter {
  bool applied = false;
  String? lastHandled;

  @override
  Future<void> applySettings() async {
    applied = true;
  }

  @override
  Future<AdapterPaymentMethod> createPaymentMethod(
      {required PaymentMethodParams params}) async {
    return AdapterPaymentMethod('pm_test_123');
  }

  @override
  Future<void> handleNextAction(String clientSecret) async {
    lastHandled = clientSecret;
  }
}

void main() {
  group('PaymentServiceImpl', () {
    test('createPaymentMethod returns adapter id', () async {
      final dio = createMockDio({});
      final stripe = _MockStripeAdapter();
      final svc = PaymentServiceImpl(dio: dio, stripe: stripe);

      final res = await svc.createPaymentMethod(
        cardNumber: '4242424242424242',
        expiryMonth: '12',
        expiryYear: '2030',
        cvv: '123',
      );

      expect(res.paymentMethodId, 'pm_test_123');
    });

    test('createPaymentIntent calls backend and returns client_secret',
        () async {
      final dio = createMockDio({
        '/payments/process': {
          'client_secret': 'cs_test_abc',
          'status': 'requires_confirmation'
        }
      });
      final stripe = _MockStripeAdapter();
      final svc = PaymentServiceImpl(dio: dio, stripe: stripe);

      final resp = await svc.createPaymentIntent(
          amount: 100.0, currency: 'usd', paymentMethodId: 'pm_test_123');
      expect(resp.paymentIntentId, 'cs_test_abc');
      expect(resp.status, 'requires_confirmation');
    });

    test('confirmPayment handles requires_action via adapter', () async {
      final dio = createMockDio({
        '/payments/confirm': {
          'status': 'requires_action',
          'requires_action': true,
          'client_secret': 'cs_test_abc'
        }
      });
      final stripe = _MockStripeAdapter();
      final svc = PaymentServiceImpl(dio: dio, stripe: stripe);

      final ok = await svc.confirmPayment(
          paymentIntentId: 'cs_test_abc', paymentMethodId: 'pm_test_123');
      expect(ok, isTrue);
      expect(stripe.lastHandled, 'cs_test_abc');
    });
  });
}
