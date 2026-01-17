import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exerciseName;
  final IconData icon;
  final Color color;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseName,
    required this.icon,
    required this.color,
  });

  // Mock data for exercises
  Map<String, dynamic> _getExerciseData() {
    final exercises = {
      'Walking': {
        'name': 'Walking',
        'description':
        'Walking is a great low-impact cardiovascular exercise that helps improve heart health, burn calories, and strengthen bones. It\'s suitable for all fitness levels and can be done anywhere. Regular walking can help reduce the risk of chronic diseases, improve mood, and boost energy levels.',
        'category': 'Cardio',
        'targetAreas': ['Legs', 'Glutes', 'Core', 'Cardiovascular System'],
        'benefits': [
          'Improves cardiovascular health',
          'Burns calories and aids weight loss',
          'Strengthens bones and muscles',
          'Reduces stress and anxiety',
          'Easy on joints',
        ],
        'videoUrl': 'https://www.youtube.com/watch?v=FXy6XihwbAU',
        'duration': '30-60 minutes',
        'intensity': 'Low to Moderate',
        'caloriesBurn': '150-300 calories/hour',
      },
      'Swimming': {
        'name': 'Swimming',
        'description':
        'Swimming is a full-body workout that builds endurance, muscle strength, and cardiovascular fitness. It\'s excellent for people of all ages and fitness levels. The water provides natural resistance, making it a great low-impact exercise that\'s easy on joints while providing an effective workout.',
        'category': 'Full Body',
        'targetAreas': [
          'Arms',
          'Shoulders',
          'Back',
          'Core',
          'Legs',
          'Cardiovascular System'
        ],
        'benefits': [
          'Full-body workout',
          'Improves lung capacity',
          'Builds muscle endurance',
          'Low impact on joints',
          'Reduces stress',
        ],
        'videoUrl': 'https://www.youtube.com/watch?v=5HLW2AI1Alk',
        'duration': '30-45 minutes',
        'intensity': 'Moderate to High',
        'caloriesBurn': '400-700 calories/hour',
      },
      'Jogging': {
        'name': 'Jogging',
        'description':
        'Jogging is a form of running at a slower, more sustainable pace. It\'s an excellent cardiovascular exercise that helps burn calories, build strong bones, and improve mental health. Regular jogging can help maintain a healthy weight, boost confidence, and increase longevity.',
        'category': 'Cardio',
        'targetAreas': [
          'Legs',
          'Glutes',
          'Core',
          'Cardiovascular System',
          'Calves'
        ],
        'benefits': [
          'Excellent calorie burner',
          'Strengthens cardiovascular system',
          'Builds leg muscles',
          'Improves bone density',
          'Boosts mental health',
        ],
        'videoUrl': 'https://www.youtube.com/watch?v=brFHyOtTwH4',
        'duration': '20-45 minutes',
        'intensity': 'Moderate to High',
        'caloriesBurn': '400-600 calories/hour',
      },
      'Tennis': {
        'name': 'Tennis',
        'description':
        'Tennis is a dynamic sport that combines aerobic exercise with bursts of intense activity. It improves agility, balance, and coordination while providing an excellent cardiovascular workout. Tennis also enhances hand-eye coordination and strategic thinking.',
        'category': 'Sport',
        'targetAreas': [
          'Arms',
          'Shoulders',
          'Legs',
          'Core',
          'Cardiovascular System'
        ],
        'benefits': [
          'Improves agility and coordination',
          'Full-body workout',
          'Burns significant calories',
          'Enhances mental alertness',
          'Social activity',
        ],
        'videoUrl': 'https://www.youtube.com/watch?v=BAYl1MWXR2k',
        'duration': '45-90 minutes',
        'intensity': 'Moderate to High',
        'caloriesBurn': '400-600 calories/hour',
      },
    };

    return exercises[exerciseName] ?? exercises['Walking']!;
  }

  Future<void> _launchYouTube(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final exercise = _getExerciseData();

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 20, color: AppTheme.darkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Exercise Details',
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

            /// CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  /// HERO CARD
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color.withOpacity(0.2),
                          color.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 48, color: color),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          exercise['name'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                            color: AppTheme.darkText,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            exercise['category'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// QUICK STATS
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          Icons.access_time,
                          'Duration',
                          exercise['duration'],
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          Icons.speed,
                          'Intensity',
                          exercise['intensity'],
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildFullWidthStatCard(
                    Icons.local_fire_department,
                    'Calories Burned',
                    exercise['caloriesBurn'],
                    Colors.red,
                  ),

                  const SizedBox(height: 24),

                  /// DESCRIPTION
                  _buildSectionTitle('Description'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.darkThird),
                    ),
                    child: Text(
                      exercise['description'],
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// TARGET AREAS
                  _buildSectionTitle('Target Areas'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (exercise['targetAreas'] as List<String>)
                        .map((area) => _buildTargetChip(area))
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  /// BENEFITS
                  _buildSectionTitle('Benefits'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.darkThird),
                    ),
                    child: Column(
                      children: (exercise['benefits'] as List<String>)
                          .asMap()
                          .entries
                          .map((entry) {
                        final isLast =
                            entry.key == exercise['benefits'].length - 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  entry.value,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade300,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// VIDEO TUTORIAL
                  _buildSectionTitle('Video Tutorial'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.darkSecondary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.darkThird),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _launchYouTube(exercise['videoUrl']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.play_circle_filled,
                                  size: 32,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Watch Tutorial on YouTube',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.darkText,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Learn proper form and technique',
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
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppTheme.darkText,
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkThird),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
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
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthStatCard(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkThird),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
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
                    color: AppTheme.darkText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetChip(String area) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            area,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
        ],
      ),
    );
  }
}