import 'package:flutter/material.dart';
import '../models/exercise_log.dart';
import '../theme/app_theme.dart';

class WorkoutCard extends StatelessWidget {
  final String image;
  final String title;
  final String sets;
  final String reps;
  final bool active;
  final bool completed;
  final int exerciseNumber;
  final ExerciseLog? loggedData;
  final VoidCallback onStart;
  final VoidCallback? onEdit;

  const WorkoutCard({
    super.key,
    required this.image,
    required this.title,
    required this.sets,
    required this.reps,
    required this.active,
    required this.completed,
    required this.exerciseNumber,
    this.loggedData,
    required this.onStart,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              active
                  ? AppTheme.primary
                  : completed
                  ? Colors.green
                  : Colors.grey.shade200,
          width: active || completed ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // Exercise Number Badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            completed
                                ? Colors.green
                                : active
                                ? AppTheme.primary
                                : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child:
                            completed
                                ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                                : Text(
                                  '$exerciseNumber',
                                  style: TextStyle(
                                    color:
                                        active ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Exercise Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        image,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.fitness_center),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Exercise Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sets,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.repeat,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                reps,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Action Button
                    SizedBox(
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onStart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              completed
                                  ? Colors.green
                                  : active
                                  ? AppTheme.primary
                                  : Colors.grey.shade300,
                          foregroundColor:
                              completed || active
                                  ? Colors.white
                                  : Colors.black54,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          completed
                              ? 'Done'
                              : active
                              ? 'Start'
                              : 'Start',
                          style: const TextStyle(
                            fontSize: 13,
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

          // Logged Data Section
          if (loggedData != null)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Logged Data',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                      if (onEdit != null)
                        GestureDetector(
                          onTap: onEdit,
                          child: Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.green.shade700,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLogItem(
                          'Sets',
                          '${loggedData!.sets}',
                          Icons.fitness_center,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildLogItem(
                          'Reps',
                          '${loggedData!.reps}',
                          Icons.repeat,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: _buildLogItem(
                          'Weight',
                          '${loggedData!.weight} kg',
                          Icons.monitor_weight_outlined,
                        ),
                      ),
                    ],
                  ),
                  if (loggedData!.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 14,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notes',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  loggedData!.notes,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLogItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14, color: Colors.green.shade700),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
