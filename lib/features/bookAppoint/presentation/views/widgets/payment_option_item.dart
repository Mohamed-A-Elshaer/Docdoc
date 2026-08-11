import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/assets.dart';

class PaymentOptionItem extends StatelessWidget {
  final void Function()? onTap;
  final bool isSelected;
  final String text;
  final bool isCreditCard;

  PaymentOptionItem({
    super.key,
    this.onTap,
    required this.isSelected,
    required this.text,
    this.isCreditCard = false,
  });

  /*final List<Map<String, dynamic>> nestedPaymentItems = [
    {'image': Assets.imagesMastercard, 'text': 'Master Card'},
    {'image': Assets.imagesAmericanExpress, 'text': 'American Express'},
    {'image': Assets.imagesCapitalOne, 'text': 'Capital One'},
    {'image': Assets.imagesBarclays, 'text': 'Barclays'},
  ];*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: onTap,
                icon: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primaryColor,
                  size: 20,
                )),
            Text(
              text,
              style: TextStyles.semiBold14
                  .copyWith(color: const Color(0xff212121)),
            )
          ],
        ),
        /*if (isCreditCard)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SizedBox(
              height: 216,
              child: ListView.builder(
                  itemCount: nestedPaymentItems.length,
                  itemBuilder: (context, index) {
                    return NestedPaymentItem(
                        image: nestedPaymentItems[index]['image'],
                        text: nestedPaymentItems[index]['text']);
                  }),
            ),
          )*/
      ],
    );
  }
}

class NestedPaymentItem extends StatelessWidget {
  const NestedPaymentItem({super.key, required this.image, required this.text});

  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Image.asset(
                image,
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                text,
                style: TextStyles.regular14
                    .copyWith(color: const Color(0xff242424)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            thickness: 1,
            height: 2,
            color: Color(0xffEDEDED),
          )
        ],
      ),
    );
  }
}
