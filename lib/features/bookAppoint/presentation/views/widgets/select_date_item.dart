import 'package:flutter/material.dart';
import 'package:docdoc/core/utils/app_colors.dart';
import 'package:docdoc/core/utils/app_text_styles.dart';

class SelectDateItem extends StatefulWidget {
  const SelectDateItem({super.key, this.onDateChanged});

  final VoidCallback? onDateChanged;

  @override
  State<SelectDateItem> createState() => SelectDateItemState();
}

class SelectDateItemState extends State<SelectDateItem> {
  int selectedDayIndex = 0; // Start from first day (today)
  late final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // Generate 14 days (two weeks) starting from today
  List<DayData> utilsays() {
    final now = DateTime.now();
    final List<DayData> days = [];

    // Generate 14 days starting from today
    for (int i = 0; i < 14; i++) {
      final date = now.add(Duration(days: i));
      days.add(DayData(
        weekday: getWeekdayName(date.weekday),
        day: date.day.toString().padLeft(2, '0'),
        date: date,
      ));
    }

    return days;
  }

  // Method to select a date by DateTime
  void selectDate(DateTime date) {
    utilsays();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(date.year, date.month, date.day);

    // Calculate the difference in days
    final difference = targetDate.difference(today).inDays;

    // Check if the date is within the 14-day range
    if (difference >= 0 && difference < 14) {
      setState(() {
        selectedDayIndex = difference;
        scrollToIndex(selectedDayIndex);
      });
      widget.onDateChanged?.call();
    }
  }

  // Method to get the selected date
  DateTime getSelectedDate() {
    final days = utilsays();
    return days[selectedDayIndex].date;
  }

  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  void scrollToIndex(int index) {
    // Calculate the position to scroll to
    const itemWidth = 50.0; // Unselected width
    const separatorWidth = 10.0;
    const selectedExtraWidth = 10.0; // Extra width when selected (60 - 50)

    double scrollPosition = 0;
    for (int i = 0; i < index; i++) {
      scrollPosition += itemWidth + separatorWidth;
      if (i == selectedDayIndex) {
        scrollPosition += selectedExtraWidth;
      }
    }

    // Scroll with animation
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = utilsays();
    const maxHeight = 67.0; // Maximum height when selected

    return SizedBox(
      height: maxHeight,
      child: Row(
        children: [
          // Left arrow
          IconButton(
            onPressed: selectedDayIndex > 0
                ? () {
                    setState(() {
                      selectedDayIndex--;
                      scrollToIndex(selectedDayIndex);
                    });
                    widget.onDateChanged?.call();
                  }
                : null, // Disabled when at first day (today)
            icon: Icon(
              Icons.chevron_left,
              size: 28,
              color: selectedDayIndex > 0 ? Colors.black : Colors.grey,
            ),
          ),

          // Days list
          Expanded(
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final isSelected = selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDayIndex = index;
                    });
                    widget.onDateChanged?.call();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      height: isSelected ? 67 : 55,
                      width: isSelected ? 60 : 50,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(isSelected ? 16 : 12),
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color(0xffF2F4F7),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            days[index].weekday,
                            style: TextStyles.regular14.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xffC2C2C2),
                              fontSize: isSelected ? 14 : 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            days[index].day,
                            style: TextStyles.regular14.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xffC2C2C2),
                              fontSize: isSelected ? 18 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Right arrow
          IconButton(
            onPressed: selectedDayIndex < days.length - 1
                ? () {
                    setState(() {
                      selectedDayIndex++;
                      scrollToIndex(selectedDayIndex);
                    });
                    widget.onDateChanged?.call();
                  }
                : null, // Disabled when at last day
            icon: Icon(
              Icons.chevron_right,
              size: 28,
              color: selectedDayIndex < days.length - 1
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class DayData {
  final String weekday;
  final String day;
  final DateTime date;

  DayData({required this.weekday, required this.day, required this.date});
}
