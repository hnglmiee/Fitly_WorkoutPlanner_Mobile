import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/shared/navigation_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/user_inbody.dart';
import '../models/user_info.dart';
import '../services/auth_service.dart';
import '../services/user_inbody_service.dart';
import '../services/user_service.dart';
import 'goal_progress.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserInfo> _userFuture;
  Future<UserInbody?>? _inbodyFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = UserService.getMyInfo();
    _inbodyFuture = UserInbodyService.getLatestInbody();
  }

  void _onNavTapped(int index) {
    if (index == 3) return; // đang ở Profile → không làm gì

    Widget nextScreen;

    switch (index) {
      case 0:
        nextScreen = const TrainingScreen();
        break;
      case 1:
        nextScreen = const ScheduleScreen();
      case 2:
        nextScreen = const GoalProgressScreen();
        break;
      case 3:
        nextScreen = const ProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // 🚫 không animation
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => nextScreen,
      ),
    );
  }

  // Widget riêng để xây dựng thẻ chỉ số nhỏ (Giữ nguyên)
  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
    Color primaryColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: primaryColor),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // ---------- MENU ITEM ----------
  Widget _buildMenuItem(BuildContext context, IconData icon, String title) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final thirdColor = AppTheme.third; // Màu nền của mục menu

    final isLogout = title == "Logout";
    final itemColor = isLogout ? Colors.red : primaryColor;
    final arrowColor = isLogout ? Colors.red : Colors.grey.shade600;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      // BỌC TRONG CLIPRRECT VÀ INKWELL ĐỂ TẠO HIỆU ỨNG NHẤN
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () {
            if (isLogout) {
              // 🔥 Dialog xác nhận logout
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // ⚠️ ICON CẢNH BÁO
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 36,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // TITLE
                            const Text(
                              "Confirm Logout",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // CONTENT
                            Text(
                              "Are you sure you want to logout?\nYou will need to login again.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text("Cancel"),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // 🔴 LOGOUT
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      try {
                                        await AuthService.logout();

                                        if (!context.mounted) return;

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                          (_) => false,
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Tapped on $title')));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isLogout ? Colors.red.shade50 : thirdColor,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: isLogout ? Colors.red : primaryColor,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        color: isLogout ? Colors.red : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Burn calories and gain muscles",
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isLogout ? Colors.red : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final thirdColor = AppTheme.third;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<UserInfo>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            final user = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header và Nút Quay Lại
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nút Quay Lại
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Text("Profile", style: textTheme.headlineMedium),
                        const Spacer(),
                        // Khoảng trống cân bằng
                        Opacity(
                          opacity: 0.0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, size: 20),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Avatar và Tên
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1644845225271-4cd4f76a0631?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(user.fullName, style: textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text(user.email, style: textTheme.bodyMedium),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Thẻ Chỉ số Cơ thể (Body Stats)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder<UserInbody?>(
                        future: _inbodyFuture,
                        builder: (context, inbodySnapshot) {
                          final inbody = inbodySnapshot.data;

                          return GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 2.0,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            children: [
                              _buildStatCard(
                                context,
                                Icons.accessibility_new,
                                "Gender",
                                user.gender ?? "Not set",
                                primaryColor,
                                Colors.white,
                              ),
                              _buildStatCard(
                                context,
                                Icons.cake,
                                "Age",
                                "20 yrs",
                                primaryColor,
                                Colors.white,
                              ),
                              _buildStatCard(
                                context,
                                Icons.monitor_weight,
                                "Weight",
                                inbody?.weight != null
                                    ? "${inbody!.weight} kg"
                                    : "Not set",
                                primaryColor,
                                Colors.white,
                              ),
                              _buildStatCard(
                                context,
                                Icons.height,
                                "Height",
                                inbody?.height != null
                                    ? "${inbody!.height} cm"
                                    : "Not set",
                                primaryColor,
                                Colors.white,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Danh sách Tùy chọn (Menu List)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          Icons.fitness_center,
                          "Workout Plan",
                        ),
                        _buildMenuItem(
                          context,
                          Icons.calendar_today,
                          "Workout Schedule",
                        ),
                        _buildMenuItem(context, Icons.description, "In Body"),
                        _buildMenuItem(
                          context,
                          Icons.local_fire_department,
                          "Goal",
                        ),
                        _buildMenuItem(context, Icons.logout, "Logout"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: 3, // Profile là index 3
          onItemTapped: _onNavTapped,
        ),
      ),
    );
  }
}
