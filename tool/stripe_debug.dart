import 'dart:io';

import 'package:dio/dio.dart';

Future<void> main() async {
  final envFile = File('.env.development');
  if (!envFile.existsSync()) {
    stderr.writeln('FAIL: .env.development not found');
    exit(1);
  }

  String? secretKey;
  for (final line in envFile.readAsLinesSync()) {
    if (line.startsWith('stripe_secretKey=')) {
      secretKey = line.substring('stripe_secretKey='.length).trim();
      break;
    }
  }

  if (secretKey == null || secretKey.isEmpty) {
    stderr.writeln('FAIL: stripe_secretKey missing');
    exit(1);
  }

  const stripeVersion = '2025-10-29.clover';
  final dio = Dio();

  Future<Response<dynamic>> stripePost(
    String path,
    Map<String, dynamic> body, {
    bool withVersion = false,
  }) async {
    return dio.post(
      'https://api.stripe.com/v1/$path',
      data: body,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        listFormat: ListFormat.multiCompatible,
        headers: {
          'Authorization': 'Bearer $secretKey',
          if (withVersion) 'Stripe-Version': stripeVersion,
        },
      ),
    );
  }

  void printStripeError(String step, DioException e) {
    stderr.writeln('FAIL at $step');
    final data = e.response?.data;
    if (data is Map && data['error'] is Map) {
      final err = data['error'] as Map;
      stderr.writeln('  type: ${err['type']}');
      stderr.writeln('  code: ${err['code']}');
      stderr.writeln('  message: ${err['message']}');
      stderr.writeln('  param: ${err['param']}');
    } else {
      stderr.writeln('  ${e.message}');
    }
  }

  try {
    stdout.writeln('Step 1: create customer');
    final customerRes = await stripePost('customers', {
      'email': 'debug@test.docdoc.local',
      'name': 'Debug User',
    });
    final customerId = (customerRes.data as Map)['id'] as String;
    stdout.writeln('  customer: $customerId');

    stdout.writeln('Step 2: create payment intent');
    final piRes = await stripePost('payment_intents', {
      'amount': '10000',
      'currency': 'usd',
      'automatic_payment_methods[enabled]': 'true',
      'customer': customerId,
      'setup_future_usage': 'off_session',
    });
    final piSecret = (piRes.data as Map)['client_secret'];
    stdout.writeln(
      '  payment_intent secret: ${piSecret != null ? 'ok' : 'missing'}',
    );

    stdout.writeln('Step 3: create customer session (with Stripe-Version)');
    final csRes = await stripePost(
      'customer_sessions',
      {
        'customer': customerId,
        'components[mobile_payment_element][enabled]': 'true',
        'components[mobile_payment_element][features][payment_method_save]':
            'enabled',
        'components[mobile_payment_element][features][payment_method_redisplay]':
            'enabled',
        'components[mobile_payment_element][features][payment_method_remove]':
            'enabled',
      },
      withVersion: true,
    );
    final csSecret = (csRes.data as Map)['client_secret'];
    stdout.writeln(
      '  customer_session secret: ${csSecret != null ? 'ok' : 'missing'}',
    );

    stdout.writeln('Step 4: customer session WITHOUT Stripe-Version');
    try {
      await stripePost(
        'customer_sessions',
        {
          'customer': customerId,
          'components[mobile_payment_element][enabled]': 'true',
        },
        withVersion: false,
      );
      stdout.writeln('  unexpected success without version header');
    } on DioException catch (e) {
      printStripeError('customer session without version', e);
    }

    stdout.writeln('ALL REQUIRED STEPS OK');
  } on DioException catch (e) {
    final path = e.requestOptions.path;
    if (path.contains('customers')) {
      printStripeError('create customer', e);
    } else if (path.contains('payment_intents')) {
      printStripeError('create payment intent', e);
    } else if (path.contains('customer_sessions')) {
      printStripeError('create customer session', e);
    } else {
      printStripeError('unknown', e);
    }
    exit(1);
  }
}
