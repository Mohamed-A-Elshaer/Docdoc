import 'package:dio/dio.dart';

class StripeDioApi {
  StripeDioApi();

  /// Required for Customer Session `mobile_payment_element` (saved cards).
  static const stripeApiVersion = '2025-10-29.clover';

  final Dio dio = Dio();

  Future<Response> post({
    required Map<String, dynamic> body,
    required String url,
    required String token,
    String? stripeVersion,
  }) async {
    try {
      return await dio.post(
        url,
        data: body,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          listFormat: ListFormat.multiCompatible,
          headers: {
            'Authorization': 'Bearer $token',
            if (stripeVersion != null) 'Stripe-Version': stripeVersion,
          },
        ),
      );
    } on DioException {
      rethrow;
    }
  }
}
