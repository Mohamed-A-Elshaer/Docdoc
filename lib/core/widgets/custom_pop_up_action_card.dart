import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';
import 'package:docdoc/core/widgets/custom_button.dart';
import 'package:docdoc/core/widgets/custom_tab_button.dart';
import 'package:docdoc/features/speciality/presentation/views/widgets/doctor_speciality_view_body.dart';
import 'package:flutter/material.dart';
import '../helper_functions/responsive_dimesions.dart';

class CustomPopUpActionCard extends StatefulWidget {
  const CustomPopUpActionCard({
    super.key,
    required this.title,
    this.onDone,
    this.isReviewMode = false,
    this.onSubmitReview,
  });
  final String title;
  final bool isReviewMode;
  final void Function(String? selectedSpeciality, String? selectedRating)?
      onDone;
  final Future<bool> Function(int rating, String review)? onSubmitReview;

  @override
  State<CustomPopUpActionCard> createState() => _CustomPopUpActionCardState();
}

class _CustomPopUpActionCardState extends State<CustomPopUpActionCard> {
  int _selectedIndex = 0;
  int _selectedRatingIndex = 0;
  int _currentRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  final FocusNode _reviewFocusNode = FocusNode();
  final GlobalKey _reviewFieldKey = GlobalKey();

  static const List<String> _ratingTabs = ['All', '5', '4', '3', '2', '1'];

  @override
  void initState() {
    super.initState();
    _reviewFocusNode.addListener(() {
      if (_reviewFocusNode.hasFocus && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 350), () {
            if (mounted && _reviewFieldKey.currentContext != null) {
              Scrollable.ensureVisible(
                _reviewFieldKey.currentContext!,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
              );
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _reviewFocusNode.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxSheetHeight = ResponsiveDimensions.responsiveHeight(context, 480);
    final viewInsetsBottom = mediaQuery.viewInsets.bottom;
    final paddingBottom = mediaQuery.padding.bottom;
    final screenHeight = mediaQuery.size.height;
    final isKeyboardOpen = viewInsetsBottom > 0;
    // When keyboard is open, give the sheet more height so the text field stays comfortable
    const double extraHeightWhenKeyboardOpen = 200;
    final height = widget.isReviewMode && isKeyboardOpen
        ? (screenHeight -
                viewInsetsBottom -
                paddingBottom -
                16 +
                extraHeightWhenKeyboardOpen)
            .clamp(320.0, double.infinity)
        : maxSheetHeight;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.53),
            topRight: Radius.circular(30.53),
          ),
          border: Border.all(
            width: 0.95,
            color: const Color(0xffF5F5F5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.13),
              blurRadius: 19.08,
              offset: const Offset(0, -3.82),
              spreadRadius: 0,
            )
          ]),
      child: Column(
        children: [
          const SizedBox(
            height: 55,
          ),
          Center(
            child: Text(
              widget.title,
              style: TextStyles.semiBold18
                  .copyWith(color: const Color(0xff242424)),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Color(0xffEDEDED),
            ),
          ),
          const SizedBox(
            height: 33,
          ),
          Expanded(
            child: widget.isReviewMode
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                      bottom: paddingBottom +
                          24 +
                          (isKeyboardOpen ? viewInsetsBottom : 0),
                    ),
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starIndex = index + 1;
                              final isActive = starIndex <= _currentRating;
                              return IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  setState(() {
                                    _currentRating = starIndex;
                                  });
                                },
                                icon: Icon(
                                  Icons.star,
                                  color: isActive
                                      ? const Color(0xffFFD600)
                                      : const Color(0xffE0E0E0),
                                  size: 32,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 33),
                          Text(
                            'Share your feedback about the doctor',
                            style: TextStyles.medium16.copyWith(
                              color: const Color(0xff151515),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          Padding(
                            key: _reviewFieldKey,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: TextField(
                              controller: _reviewController,
                              focusNode: _reviewFocusNode,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Your review',
                                hintStyle: TextStyles.regular12.copyWith(
                                  color: const Color(0xff9E9E9E),
                                ),
                                filled: true,
                                fillColor: AppColors.secondrySurfaceColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'Done',
                            onPressed: () async {
                              if (_currentRating < 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please select a star rating'),
                                  ),
                                );
                                return;
                              }
                              final didSave = await widget.onSubmitReview?.call(
                                    _currentRating,
                                    _reviewController.text.trim(),
                                  ) ??
                                  true;
                              if (didSave && context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Speciality',
                            style: TextStyles.medium16
                                .copyWith(color: const Color(0xff242424)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 51,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 24),
                          itemCount:
                              DoctorSpecialityViewBody.specialities.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index <
                                        DoctorSpecialityViewBody
                                                .specialities.length -
                                            1
                                    ? 12
                                    : 0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = index;
                                  });
                                },
                                child: CustomTabButton(
                                  containerHeight: 51,
                                  containerWidth: 145,
                                  buttonRadius: 34,
                                  isActive: _selectedIndex == index,
                                  isRatingTab: false,
                                  tabTitle: DoctorSpecialityViewBody
                                          .specialities[index]['speciality']
                                      as String,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Rating',
                            style: TextStyles.medium16
                                .copyWith(color: const Color(0xff242424)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SizedBox(
                        height: 41,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 24),
                          itemCount: _ratingTabs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < _ratingTabs.length - 1 ? 12 : 0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedRatingIndex = index;
                                  });
                                },
                                child: CustomTabButton(
                                  containerHeight: 41,
                                  containerWidth: 84,
                                  buttonRadius: 34,
                                  isActive: _selectedRatingIndex == index,
                                  isRatingTab: true,
                                  tabTitle: _ratingTabs[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
          if (!widget.isReviewMode)
            CustomButton(
              text: 'Done',
              onPressed: () {
                final selectedSpeciality = DoctorSpecialityViewBody
                    .specialities[_selectedIndex]['speciality'] as String;
                final selectedRating = _selectedRatingIndex == 0
                    ? null
                    : _ratingTabs[_selectedRatingIndex];
                widget.onDone?.call(selectedSpeciality, selectedRating);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}
