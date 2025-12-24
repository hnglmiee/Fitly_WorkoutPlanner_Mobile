import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample notifications data
    final List<Map<String, dynamic>> notifications = [
      {
        'type': 'workout_reminder',
        'title': 'Time for your workout!',
        'message': 'Chest & Triceps session starts in 30 minutes',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
        'isRead': false,
        'icon': Icons.fitness_center,
        'color': Colors.blue,
      },
      {
        'type': 'workout_reminder',
        'title': 'Morning Workout Reminder',
        'message': 'Don\'t forget your leg day at 6:00 AM tomorrow',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': false,
        'icon': Icons.alarm,
        'color': Colors.orange,
      },
      {
        'type': 'goal_achievement',
        'title': 'Goal Completed! 🎉',
        'message': 'Congratulations! You completed 5 workouts this week',
        'time': DateTime.now().subtract(const Duration(hours: 5)),
        'isRead': true,
        'icon': Icons.emoji_events,
        'color': Colors.amber,
      },
      {
        'type': 'workout_reminder',
        'title': 'Rest Day Tomorrow',
        'message': 'Remember to take rest and recover properly',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'isRead': true,
        'icon': Icons.hotel,
        'color': Colors.green,
      },
      {
        'type': 'streak',
        'title': 'Keep the streak going! 🔥',
        'message': 'You\'re on a 7-day workout streak. Keep it up!',
        'time': DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        'isRead': true,
        'icon': Icons.local_fire_department,
        'color': Colors.red,
      },
      {
        'type': 'workout_reminder',
        'title': 'Weekly Plan Updated',
        'message': 'Your coach updated your workout plan for next week',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'isRead': true,
        'icon': Icons.update,
        'color': Colors.purple,
      },
    ];

    final unreadCount = notifications.where((n) => !n['isRead']).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Mark all as read button
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: () {
                        // TODO: Mark all as read
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'All notifications marked as read',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(16),
                          ),
                        );
                      },
                      child: Text(
                        'Mark all',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

            /// CONTENT
            Expanded(
              child:
                  notifications.isEmpty
                      ? _buildEmptyState()
                      : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Unread section
                          if (unreadCount > 0) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  const Text(
                                    'New',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '$unreadCount',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...notifications
                                .where((n) => !n['isRead'])
                                .map(
                                  (notification) => _buildNotificationCard(
                                    notification,
                                    context,
                                  ),
                                )
                                .toList(),
                            const SizedBox(height: 24),
                          ],

                          // Earlier section
                          if (notifications.any((n) => n['isRead'])) ...[
                            const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: Text(
                                'Earlier',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            ...notifications
                                .where((n) => n['isRead'])
                                .map(
                                  (notification) => _buildNotificationCard(
                                    notification,
                                    context,
                                  ),
                                )
                                .toList(),
                          ],
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    Map<String, dynamic> notification,
    BuildContext context,
  ) {
    final isRead = notification['isRead'] as bool;
    final time = notification['time'] as DateTime;
    final timeAgo = _formatTimeAgo(time);

    return Dismissible(
      key: Key(notification['title'] + time.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Notification deleted',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : AppTheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isRead
                    ? Colors.grey.shade200
                    : AppTheme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (notification['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification['icon'] as IconData,
                size: 22,
                color: notification['color'] as Color,
              ),
            ),

            const SizedBox(width: 12),

            /// CONTENT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'] as String,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                isRead ? FontWeight.w600 : FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(time);
    }
  }
}
