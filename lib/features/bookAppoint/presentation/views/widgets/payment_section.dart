import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/payment_option_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../../domain/entities/payment_option_entity.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection>
    with AutomaticKeepAliveClientMixin {
  int selectedPaymentOption = -1;

  String _getPaymentOptionString(int index) {
    switch (index) {
      case 0:
        return 'Credit Card';
      case 1:
        return 'Paypal';
      default:
        return 'Credit Card';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(
          height: 21,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Payment Option',
                style: TextStyles.semiBold16
                    .copyWith(color: const Color(0xff070C18)),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        PaymentOptionItem(
            isSelected: selectedPaymentOption == 0,
            isCreditCard: selectedPaymentOption == 0,
            onTap: () {
              setState(() {
                selectedPaymentOption = 0;
                final bookingEntity = context.read<BookingEntity>();
                // Create or update paymentOptionEntity with current selection
                bookingEntity.paymentOptionEntity = PaymentOptionEntity(
                  paymentOption: _getPaymentOptionString(0),
                  isPaymentOptionChosen: true,
                );
              });
            },
            text: 'Credit Card'),
        PaymentOptionItem(
            isSelected: selectedPaymentOption == 1,
            onTap: () {
              setState(() {
                selectedPaymentOption = 1;
                final bookingEntity = context.read<BookingEntity>();
                // Create or update paymentOptionEntity with current selection
                bookingEntity.paymentOptionEntity = PaymentOptionEntity(
                  paymentOption: _getPaymentOptionString(1),
                  isPaymentOptionChosen: true,
                );
              });
            },
            text: 'Paypal'),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
