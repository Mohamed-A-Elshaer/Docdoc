part of 'paypal_payment_cubit.dart';

@immutable
sealed class PayPalPaymentState {}

final class PayPalPaymentInitial extends PayPalPaymentState {}

final class PayPalPaymentLoading extends PayPalPaymentState {}

final class PayPalPaymentSuccess extends PayPalPaymentState {}

final class PayPalPaymentFailure extends PayPalPaymentState {
  final String errMsg;

  PayPalPaymentFailure(this.errMsg);
}
