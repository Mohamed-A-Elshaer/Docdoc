import 'dart:io';

import 'package:dio/dio.dart';

Future<void> main() async {
  final envFile = File('.env.development');
  String? secretKey;
  String? publishableKey;
  for (final line in envFile.readAsLinesSync()) {
    if (line.startsWith('stripe_secretKey=')) {
      secretKey = line.substring('stripe_secretKey='.length).trim();
    }
    if (line.startsWith('stripe_publishableKey=')) {
      publishableKey = line.substring('stripe_publishableKey='.length).trim();
    }
  }

  stdout.writeln('secret prefix: ${secretKey?.substring(0, 20)}...');
  stdout.writeln('publishable prefix: ${publishableKey?.substring(0, 20)}...');
  stdout.writeln(
    'same account: ${secretKey?.split('_')[2].substring(0, 8) == publishableKey?.split('_')[2].substring(0, 8)}',
  );

  final dio = Dio();
  const stripeVersion = '2025-10-29.clover';

  Future<void> testCustomer(String customerId, String label) async {
    stdout.writeln('\nTesting with $label customer: $customerId');
    try {
      await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: {
          'amount': '10000',
          'currency': 'usd',
          'automatic_payment_methods[enabled]': 'true',
          'customer': customerId,
          'setup_future_usage': 'off_session',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          listFormat: ListFormat.multiCompatible,
          headers: {'Authorization': 'Bearer $secretKey'},
        ),
      );
      stdout.writeln('  payment_intent: OK');
    } on DioException catch (e) {
      final err = (e.response?.data as Map?)?['error'] as Map?;
      stdout.writeln('  payment_intent FAIL: ${err?['message']}');
    }

    try {
      await dio.post(
        'https://api.stripe.com/v1/customer_sessions',
        data: {
          'customer': customerId,
          'components[mobile_payment_element][enabled]': 'true',
          'components[mobile_payment_element][features][payment_method_save]':
              'enabled',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          listFormat: ListFormat.multiCompatible,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Stripe-Version': stripeVersion,
          },
        ),
      );
      stdout.writeln('  customer_session: OK');
    } on DioException catch (e) {
      final err = (e.response?.data as Map?)?['error'] as Map?;
      stdout.writeln('  customer_session FAIL: ${err?['message']}');
    }
  }

  await testCustomer('cus_INVALID123456789', 'invalid');
  await testCustomer('cus_V0PQT9ssX4UvND', 'valid');
}
