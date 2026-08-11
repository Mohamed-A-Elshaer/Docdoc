import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/core/widgets/custom_app_bar.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/features/profile/domain/entities/payment_entity.dart';
import 'package:docdoc/features/profile/presentation/views/widgets/payment_method_card.dart';
import 'package:flutter/material.dart';

class PaymentViewBody extends StatelessWidget {
  const PaymentViewBody({super.key});

  static const List<PaymentEntity> _payments = [
    PaymentEntity(
      imageAsset: Assets.imagesPaypal,
      title: 'Paypal',
      lastFourDigits: '3784',
    ),
    PaymentEntity(
      imageAsset: Assets.imagesMastercard,
      title: 'MasterCard',
      lastFourDigits: '5529',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment',
        leftPadding: 66,
        onTap: () => Navigator.of(context).pop(),
        showAction: true,
        onActionTap: () {},
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    for (var i = 0; i < _payments.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      PaymentMethodCard(payment: _payments[i]),
                    ],
                  ],
                ),
              ),
            ),
            CustomButton(
              text: 'Add New',
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
