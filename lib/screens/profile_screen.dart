import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/shared/navigation_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/user_inbody.dart';
import '../models/user_info.dart';
import '../services/user_inbody_service.dart';
import '../services/user_service.dart';

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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      // BỌC TRONG CLIPRRECT VÀ INKWELL ĐỂ TẠO HIỆU ỨNG NHẤN
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Tapped on $title')));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: thirdColor),
            child: Row(
              children: [
                Icon(icon, size: 24, color: primaryColor),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(fontSize: 16),
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
                  color: Colors.grey.shade600,
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
          onItemTapped: (index) {
            if (index == 0) {
              Navigator.pop(context); // Quay lại TrainingScreen
            }
          },
        ),
      ),
    );
  }
}
