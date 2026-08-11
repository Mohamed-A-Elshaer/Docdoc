class PaymentEntity {
  const PaymentEntity({
    required this.imageAsset,
    required this.title,
    required this.lastFourDigits,
  });

  final String imageAsset;
  final String title;
  final String lastFourDigits;

  String get maskedCardNumber => '**** **** **** $lastFourDigits';
}
