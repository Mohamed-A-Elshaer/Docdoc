import 'package:docdoc/core/helper_classes/stripe_dio_api.dart';
import 'package:docdoc/core/helper_models/dot_env_keys.dart';
import 'package:docdoc/core/services/shared_preferences_singelton.dart';
import 'package:docdoc/features/checkout/data/models/customer_session_input_model.dart';
import 'package:docdoc/features/checkout/data/models/customer_session_model/customer_session_model.dart';
import 'package:docdoc/features/checkout/data/models/payment_intent_input_model.dart';
import 'package:docdoc/features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StripeService {
  StripeDioApi stripeDioApi = StripeDioApi();

  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    final response = await stripeDioApi.post(
      body: paymentIntentInputModel.toJson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: DotEnvKeys.stripeSecretKey,
    );

    return PaymentIntentModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<CustomerSessionModel> createCustomerSession(
    CustomerSessionInputModel customerSessionInputModel,
  ) async {
    final response = await stripeDioApi.post(
      body: customerSessionInputModel.toJson(),
      url: 'https://api.stripe.com/v1/customer_sessions',
      token: DotEnvKeys.stripeSecretKey,
      stripeVersion: StripeDioApi.stripeApiVersion,
    );

    return CustomerSessionModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String> createCustomer({String? email, String? name}) async {
    final body = <String, dynamic>{};
    if (email != null && email.isNotEmpty) {
      body['email'] = email;
    }
    if (name != null && name.isNotEmpty) {
      body['name'] = name;
    }

    final response = await stripeDioApi.post(
      body: body,
      url: 'https://api.stripe.com/v1/customers',
      token: DotEnvKeys.stripeSecretKey,
    );

    final customerId = (response.data as Map<String, dynamic>)['id'] as String?;
    if (customerId == null || customerId.isEmpty) {
      throw StateError('Stripe customer creation returned no id.');
    }

    return customerId;
  }

  Future<String> getOrCreateCustomerId({bool forceRefresh = false}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to pay.');
    }

    final prefKey = _customerPrefKey(user.id);
    if (!forceRefresh) {
      final cached = Prefs.getString(prefKey);
      if (cached != null && cached.isNotEmpty) {
        return cached;
      }
    } else {
      await Prefs.remove(prefKey);
    }

    final customerId = await createCustomer(
      email: user.email,
      name: user.userMetadata?['name'] as String?,
    );
    await Prefs.setString(prefKey, customerId);
    return customerId;
  }

  String _customerPrefKey(String userId) => 'stripe_customer_id_$userId';

  bool _isNoSuchCustomer(DioException exception) {
    final data = exception.response?.data;
    if (data is Map) {
      final error = data['error'];
      if (error is Map) {
        final code = error['code'];
        final message = error['message']?.toString() ?? '';
        return code == 'resource_missing' ||
            message.contains('No such customer');
      }
    }
    return false;
  }

  Future<T> _retryOnStaleCustomer<T>({
    required String userId,
    required Future<T> Function(String customerId) action,
  }) async {
    final prefKey = _customerPrefKey(userId);
    var customerId = await getOrCreateCustomerId();

    try {
      return await action(customerId);
    } on DioException catch (exception) {
      if (!_isNoSuchCustomer(exception)) {
        rethrow;
      }

      await Prefs.remove(prefKey);
      customerId = await getOrCreateCustomerId(forceRefresh: true);
      return action(customerId);
    }
  }

  Future initPaymentSheet({
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerSessionClientSecret,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerSessionClientSecret: customerSessionClientSecret,
        merchantDisplayName: 'Docdoc Corp.',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to pay.');
    }

    final customerId = paymentIntentInputModel.customerId.isNotEmpty
        ? paymentIntentInputModel.customerId
        : await getOrCreateCustomerId();

    final paymentIntentModel = await _retryOnStaleCustomer<PaymentIntentModel>(
      userId: user.id,
      action: (resolvedCustomerId) async {
        return createPaymentIntent(
          PaymentIntentInputModel(
            amount: paymentIntentInputModel.amount,
            currency: paymentIntentInputModel.currency,
            customerId: resolvedCustomerId,
          ),
        );
      },
    );

    final paymentIntentClientSecret = paymentIntentModel.clientSecret;
    if (paymentIntentClientSecret == null ||
        paymentIntentClientSecret.isEmpty) {
      throw StateError('Stripe payment intent did not return a client secret.');
    }

    final resolvedCustomerId = paymentIntentModel.customer is String
        ? paymentIntentModel.customer as String
        : customerId;

    final customerSessionModel =
        await _retryOnStaleCustomer<CustomerSessionModel>(
      userId: user.id,
      action: (resolvedCustomerId) async {
        return createCustomerSession(
          CustomerSessionInputModel.fromCustomer(
            customerId: resolvedCustomerId,
          ),
        );
      },
    );
    final customerSessionClientSecret = customerSessionModel.clientSecret;
    if (customerSessionClientSecret == null ||
        customerSessionClientSecret.isEmpty) {
      throw StateError(
          'Stripe customer session did not return a client secret.');
    }

    await initPaymentSheet(
      paymentIntentClientSecret: paymentIntentClientSecret,
      customerId: resolvedCustomerId,
      customerSessionClientSecret: customerSessionClientSecret,
    );
    await displayPaymentSheet();
  }
}
