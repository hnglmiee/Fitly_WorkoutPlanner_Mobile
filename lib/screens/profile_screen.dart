import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/profile_edit_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/schedule_screen.dart';
import 'package:workout_tracker_mini_project_mobile/screens/training_screen.dart';
import 'package:workout_tracker_mini_project_mobile/shared/navigation_bar.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';

import '../models/user_inbody.dart';
import '../models/user_info.dart';
import '../services/auth_service.dart';
import '../services/user_inbody_service.dart';
import '../services/user_service.dart';
import '../theme/gradient_scaffold.dart';
import 'goal_progress.dart';
import 'inbody_screen.dart';
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
    if (index == 3) return;

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
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => nextScreen,
      ),
    );
  }

  /// ✅ RESTYLED: Modern stat card with improved design
  Widget _buildModernStatCard(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    return Container(
      height: 110, // ✅ Fixed height for consistency
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkThird),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ICON
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),

          /// TITLE + VALUE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: AppTheme.darkText,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernMenuItem(
      IconData icon,
      String title,
      String subtitle, {
        VoidCallback? onTap,
        bool isDanger = false,
      }) {
    final itemColor = isDanger ? Colors.red : AppTheme.darkText;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            if (isDanger) {
              _showLogoutDialog();
            } else {
              if (onTap != null) {
                onTap();
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Tapped on $title')));
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.darkSecondary,
              border: Border.all(color: AppTheme.darkThird),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDanger
                        ? Colors.red.withOpacity(0.15)
                        : AppTheme.darkPrimary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: isDanger ? Colors.red : AppTheme.darkPrimary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDanger ? Colors.red : AppTheme.darkText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDanger ? Colors.red : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: AppTheme.darkSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Are you sure you want to logout?\nYou will need to login again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppTheme.darkThird,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: FutureBuilder<UserInfo>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final user = snapshot.data!;

            return Column(
              children: [
                /// HEADER
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 20, color: AppTheme.darkText),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrainingScreen(),
                            ),
                          );
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Profile",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        /// AVATAR & NAME CARD
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.darkSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.darkThird),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  // Avatar
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.darkPrimary,
                                          AppTheme.darkPrimary.withOpacity(0.7),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.darkPrimary
                                              .withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        user.fullName.isNotEmpty
                                            ? user.fullName[0].toUpperCase()
                                            : '?',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Edit button with navigation
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ProfileEditScreen(
                                              userInfo: user,
                                            ),
                                          ),
                                        );
                                        // Reload profile data
                                        setState(() {
                                          _userFuture = UserService.getMyInfo();
                                        });
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: AppTheme.darkPrimary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppTheme.darkSecondary,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                user.fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  color: AppTheme.darkText,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// BODY STATS
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Body Stats",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        FutureBuilder<UserInbody?>(
                          future: _inbodyFuture,
                          builder: (context, inbodySnapshot) {
                            final inbody = inbodySnapshot.data;

                            return GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              childAspectRatio: 1.4,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                _buildModernStatCard(
                                  Icons.person_outline,
                                  "Gender",
                                  user.gender ?? "Not set",
                                  Colors.purple,
                                ),
                                _buildModernStatCard(
                                  Icons.cake_outlined,
                                  "Age",
                                  "20 yrs",
                                  Colors.pink,
                                ),
                                _buildModernStatCard(
                                  Icons.monitor_weight_outlined,
                                  "Weight",
                                  inbody?.weight != null
                                      ? "${inbody!.weight} kg"
                                      : "Not set",
                                  Colors.orange,
                                ),
                                _buildModernStatCard(
                                  Icons.height_rounded,
                                  "Height",
                                  inbody?.height != null
                                      ? "${inbody!.height} cm"
                                      : "Not set",
                                  Colors.blue,
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 24),

                        /// MENU LIST
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        _buildModernMenuItem(
                          Icons.assessment_outlined,
                          "In Body",
                          "Track your body composition",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const InBodyScreen(),
                              ),
                            );
                          },
                        ),
                        _buildModernMenuItem(
                          Icons.logout_rounded,
                          "Logout",
                          "Sign out from your account",
                          isDanger: true,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: 3,
          onItemTapped: _onNavTapped,
        ),
      ),
    );
  }
}