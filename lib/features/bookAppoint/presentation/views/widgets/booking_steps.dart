import 'package:docdoc/core/helper_functions/responsive_dimesions.dart';
import 'package:docdoc/features/bookAppoint/presentation/views/widgets/step_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/helper_functions/build_error_bar.dart';
import '../../../domain/entities/booking_entity.dart';

class BookingSteps extends StatelessWidget {
  const BookingSteps({super.key,
    required this.currentPageIndex,
    required this.pageController
  });

final int currentPageIndex;
final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: ResponsiveDimensions.responsiveWidth(context, 25)),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(getSteps().length, (index) {
            return GestureDetector(
              onTap: (){
                // Allow navigation to previous steps without validation or error bars
                if (index < currentPageIndex) {
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300), 
                    curve: Curves.easeIn
                  );
                  return;
                }
                
                // Prevent navigation to future steps - show validation errors
                if (index > currentPageIndex) {
                  final bookingEntity = context.read<BookingEntity>();
                  
                  // Check prerequisites: to go to step N, all steps before N must be completed
                  // Step 0 (Date & Time) must be completed to go to any future step
                  if (bookingEntity.dateTimeEntity == null || bookingEntity.dateTimeEntity?.isAvailableTimeChosen != true) {
                    buildErrorBar(context, 'Please choose an appointment time');
                    return;
                  }

                  // Step 1 (Payment) must be completed only to go to step 2 (Summary)
                  if (index == 2 && (bookingEntity.paymentOptionEntity == null || bookingEntity.paymentOptionEntity?.isPaymentOptionChosen != true)) {
                    buildErrorBar(context, 'Please choose a payment option');
                    return;
                  }
                  
                  // If validation passes, allow navigation
                  pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300), 
                    curve: Curves.easeIn
                  );
                  return;
                }
                
                // For current step (index == currentPageIndex), allow navigation
                pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300), 
                  curve: Curves.easeIn
                );
              },
              child: StepItem(
                isFirst: index == 0,
                text: getSteps()[index],
                index: (index+1).toString(),
                hasRightPadding: index >= 2,
                isActive: index == currentPageIndex,
                isCompleted: index < currentPageIndex,
              ),
            );
          }),
        ),
      ),
    );
  }

}

List<String> getSteps(){
  return[
    'Date & Time',
    'Payment',
    'Summary'
  ];
}