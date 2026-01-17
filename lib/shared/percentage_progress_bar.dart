import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

class PercentageProgressBar extends StatefulWidget {
  final double percent; // 0 → 100
  final Duration duration; // Thời gian animation
  final Curve curve; // Loại animation curve

  const PercentageProgressBar({
    super.key,
    required this.percent,
    this.duration = const Duration(milliseconds: 1500), // 1.5 giây mặc định
    this.curve = Curves.easeInOut,
  });

  @override
  State<PercentageProgressBar> createState() => _PercentageProgressBarState();
}

class _PercentageProgressBarState extends State<PercentageProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.percent,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    // Bắt đầu animation
    _controller.forward();
  }

  @override
  void didUpdateWidget(PercentageProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Nếu percent thay đổi, animate đến giá trị mới
    if (oldWidget.percent != widget.percent) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.percent,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentPercent = _animation.value;
        final progressValue = (currentPercent / 100).clamp(0.0, 1.0);

        return Stack(
          alignment: Alignment.centerRight,
          children: [
            /// Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 15,
                backgroundColor: AppTheme.darkThird,
                valueColor: AlwaysStoppedAnimation(AppTheme.darkPrimary),
              ),
            ),
          ],
        );
      },
    );
  }
}
