import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';

class ScheduleCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime currentMonth;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onNextMonth;
  final VoidCallback onPrevMonth;

  const ScheduleCalendar({
    super.key,
    required this.selectedDate,
    required this.currentMonth,
    required this.onDateSelected,
    required this.onNextMonth,
    required this.onPrevMonth,
  });

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  final ScrollController _scrollController = ScrollController();

  static const double _itemWidth = 72; // 60 + margin

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!DateUtils.isSameDay(oldWidget.selectedDate, widget.selectedDate) ||
        oldWidget.currentMonth.month != widget.currentMonth.month) {
      _scrollToSelected();
    }
  }

  void _scrollToSelected() {
    final days = _generateDays();

    final index = days.indexWhere(
      (d) => DateUtils.isSameDay(d, widget.selectedDate),
    );

    if (index == -1 || !_scrollController.hasClients) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final offset = index * _itemWidth - (screenWidth / 2) + (_itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> _generateDays() {
    final firstDay = DateTime(
      widget.currentMonth.year,
      widget.currentMonth.month,
      1,
    );

    return List.generate(
      DateUtils.getDaysInMonth(
        widget.currentMonth.year,
        widget.currentMonth.month,
      ),
      (i) => firstDay.add(Duration(days: i)),
    );
  }

  bool _isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDays();

    return Column(
      children: [
        /// MONTH HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppTheme.darkText),
              onPressed: widget.onPrevMonth,
            ),
            Text(
              DateFormat('MMMM').format(widget.currentMonth),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppTheme.darkText),
              onPressed: widget.onNextMonth,
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// DAYS LIST
        SizedBox(
          height: 120,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
              final isToday = _isToday(date);

              return GestureDetector(
                onTap: () => widget.onDateSelected(date),
                child: Column(
                  children: [
                    /// DOT
                    Container(
                      height: 5,
                      width: 5,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color:
                            isToday
                                ? Colors.red
                                : isSelected
                                ? AppTheme.darkPrimary
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                    ),

                    /// DATE CARD
                    Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.darkPrimary : AppTheme.darkThird,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('EEE').format(date),
                              style: TextStyle(
                                color: isSelected ? AppTheme.darkBackground : AppTheme.lightBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 45,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Text(
                                date.day.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
