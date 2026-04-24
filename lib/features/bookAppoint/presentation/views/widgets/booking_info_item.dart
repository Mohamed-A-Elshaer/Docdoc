import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/utils/assets.dart';
import 'package:docdoc/features/bookAppoint/domain/entities/booking_entity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/widgets/custom_text_button.dart';

class BookingInfoItem extends StatelessWidget {
 final bool isBookingDetailsSection;
  const BookingInfoItem({super.key,required this.isBookingDetailsSection});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingEntity>(
      builder: (context, bookingEntity, child) {
        return Column(
          children: [
            Row(
              children: [
                  Image.asset(Assets.imagesCalenderBookingIcon,height: 40,width: 40,),
                  const SizedBox(width: 12,),
                  Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date & Time',style: TextStyles.semiBold14.copyWith(color: const Color(0xff242424)),),
                      const SizedBox(height: 2,),
                      Text(bookingEntity.dateTimeEntity?.dateTimeToString() ?? '',style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),),
                      const SizedBox(height: 2,),
                    ],
                  )
              ],
            ),
            const SizedBox(height: 16,),
            const Divider(
              thickness: 1,
              height: 2,
              color: Color(0xffEDEDED),
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                Image.asset(Assets.imagesAppointTypeIcon,height: 40,width: 40,),
                const SizedBox(width: 12,),

                isBookingDetailsSection?
                   Row(
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Appointment Type',style: TextStyles.semiBold14.copyWith(color: const Color(0xff242424)),),
                           const SizedBox(height: 2,),
                           Text(bookingEntity.dateTimeEntity?.appointTypeToString() ?? '',style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),),
                         ],
                       ),
                       const SizedBox(width: 40,),
                       const SizedBox(
                           width: 109,
                           height: 38,
                           child: CustomTextButton(text: 'Get Location')
                       )
                     ],
                   )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appointment Type',style: TextStyles.semiBold14.copyWith(color: const Color(0xff242424)),),
                    const SizedBox(height: 2,),
                    Text(bookingEntity.dateTimeEntity?.appointTypeToString() ?? '',style: TextStyles.regular12.copyWith(color: const Color(0xff757575)),),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16,),
            const Divider(
              thickness: 1,
              height: 2,
              color: Color(0xffEDEDED),
            ),
          ],
        );
      },
    );
  }
}
