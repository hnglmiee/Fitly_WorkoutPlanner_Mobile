import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';
import 'height_screen.dart';

class GenderScreen extends StatefulWidget {
  final int userId;
  const GenderScreen({super.key, required this.userId});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String selectedGender = "";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// HEADER
              const Text(
                "Gender",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkText),
              ),

              const SizedBox(height: 20),

              /// PROGRESS BAR
              Row(
                children: [
                  _progress(true),
                  _progress(false),
                  _progress(false),
                  _progress(false),
                ],
              ),

              const SizedBox(height: 40),

              /// TITLE
              const Text(
                "Tell Us About Yourself",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                    color: AppTheme.darkText
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// SUBTITLE
              Text(
                "To give you a better experience and results\nwe need to know your gender",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppTheme.darkText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              /// GENDER CARDS
              Row(
                children: [
                  Expanded(
                    child: _genderCard(
                      label: "Male",
                      icon: Icons.male,
                      imageUrl:
                          "https://images.unsplash.com/photo-1605296867304-46d5465a13f1?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      color: Colors.blue,
                      isSelected: selectedGender == "Male",
                      onTap: () => setState(() => selectedGender = "Male"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _genderCard(
                      label: "Female",
                      icon: Icons.female,
                      imageUrl:
                          "https://images.unsplash.com/photo-1644845225271-4cd4f76a0631?q=80&w=1172&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      color: Colors.pink,
                      isSelected: selectedGender == "Female",
                      onTap: () => setState(() => selectedGender = "Female"),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// NEXT BUTTON
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      selectedGender.isNotEmpty && !_isLoading
                          ? _onNextPressed
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkPrimary,
                    disabledBackgroundColor: AppTheme.darkPrimary.withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child:
                      _isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppTheme.darkText,
                            ),
                          )
                          : const Text(
                            "Next",
                            style: TextStyle(
                              color: AppTheme.darkBackground,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progress(bool active) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: active ? AppTheme.darkPrimary : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _genderCard({
    required String label,
    required IconData icon,
    required String imageUrl,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade200,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isSelected
                      ? color.withOpacity(0.2)
                      : Colors.black.withOpacity(0.02),
              blurRadius: isSelected ? 16 : 4,
              offset: Offset(0, isSelected ? 4 : 1),
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// AVATAR IMAGE
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.05 : 1,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade300,
                    width: 3,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// ICON
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected ? color.withOpacity(0.15) : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? color : Colors.grey.shade600,
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            /// LABEL
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onNextPressed() async {
    setState(() => _isLoading = true);

    try {
      await UserService.updateUserGender(
        userId: widget.userId,
        gender: selectedGender,
      );

      if (!mounted) return;

      Navigator.push(context, _slideTo(const HeightScreen()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Route _slideTo(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
