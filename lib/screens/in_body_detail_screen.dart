import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/in_body_data.dart';
import '../services/in_body_service.dart';
import '../theme/app_theme.dart';
import 'edit_in_body.dart';

class InBodyDetailScreen extends StatefulWidget {
  final InBodyData record;

  const InBodyDetailScreen({super.key, required this.record});

  @override
  State<InBodyDetailScreen> createState() => _InBodyDetailScreenState();
}

class _InBodyDetailScreenState extends State<InBodyDetailScreen> {
  late InBodyData currentRecord;

  @override
  void initState() {
    super.initState();
    currentRecord = widget.record;
  }

  Future<void> _deleteRecord() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Delete Record',
              style: TextStyle(color: AppTheme.darkText),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this InBody record? This action cannot be undone.',
          style: TextStyle(fontSize: 15, color: AppTheme.darkText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await InBodyService.deleteInBodyRecord(currentRecord.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Record deleted successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        Navigator.pop(context, {'deleted': true, 'id': currentRecord.id});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.darkText),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'InBody Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.darkText,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 22,
                    ),
                    onPressed: _deleteRecord,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card
                    _headerCard(),

                    const SizedBox(height: 24),

                    // Body Metrics Section
                    _sectionTitle('Body Metrics'),
                    const SizedBox(height: 12),
                    _bodyMetricsGrid(),

                    const SizedBox(height: 24),

                    // Body Composition Section
                    _sectionTitle('Body Composition'),
                    const SizedBox(height: 12),
                    _bodyCompositionCards(),

                    const SizedBox(height: 24),

                    // Additional Info Section
                    _sectionTitle('Additional Information'),
                    const SizedBox(height: 12),
                    _additionalInfoCard(),

                    const SizedBox(height: 24),

                    // Trends Section
                    _sectionTitle('Trends'),
                    const SizedBox(height: 12),
                    _trendsCard(),

                    // Notes Section (if exists)
                    if (currentRecord.notes != null &&
                        currentRecord.notes!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle('Notes'),
                      const SizedBox(height: 12),
                      _notesCard(),
                    ],

                    const SizedBox(height: 24),

                    // Edit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditInBodyScreen(
                                inBodyData: {
                                  'id': currentRecord.id,
                                  'measuredAt': currentRecord.measuredAt,
                                  'height': currentRecord.height,
                                  'weight': currentRecord.weight,
                                  'bodyFatPercentage':
                                  currentRecord.bodyFatPercentage,
                                  'muscleMass': currentRecord.muscleMass,
                                  'notes': currentRecord.notes ?? '',
                                },
                              ),
                            ),
                          );

                          if (result != null && result is Map) {
                            if (result['deleted'] == true) {
                              if (mounted) {
                                Navigator.pop(context, result);
                              }
                            } else {
                              try {
                                final updated =
                                await InBodyService.getInBodyRecordById(
                                  currentRecord.id,
                                );
                                setState(() {
                                  currentRecord = updated;
                                });
                              } catch (e) {
                                debugPrint('Error reloading record: $e');
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.edit, size: 20, color: AppTheme.darkBackground),
                        label: const Text(
                          'Edit Record',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkBackground,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.darkPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.darkThird, width: 1),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.darkPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fitness_center,
                  size: 28,
                  color: AppTheme.darkPrimary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentRecord.fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                        color: AppTheme.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'InBody Measurement',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.darkThird,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: AppTheme.darkPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('MMM dd').format(currentRecord.measuredAt),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy').format(currentRecord.measuredAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 40, color: AppTheme.darkThird),
                Column(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 20,
                      color: AppTheme.darkPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(currentRecord.measuredAt),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkText,
                      ),
                    ),
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
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

  Widget _bodyMetricsGrid() {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            icon: Icons.height_rounded,
            label: 'Height',
            value: currentRecord.height.toStringAsFixed(1),
            unit: 'cm',
            color: AppTheme.darkPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _metricCard(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: currentRecord.weight.toStringAsFixed(1),
            unit: 'kg',
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTheme.darkText,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bodyCompositionCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _compositionCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Body Fat',
                value: currentRecord.bodyFatPercentage.toStringAsFixed(1),
                unit: '%',
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _compositionCard(
                icon: Icons.fitness_center,
                label: 'Muscle Mass',
                value: currentRecord.muscleMass.toStringAsFixed(1),
                unit: '%',
                color: AppTheme.darkPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _waterCard(),
      ],
    );
  }

  Widget _compositionCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                  height: 1,
                  color: AppTheme.darkText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 2),
                child: Text(
                  unit,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _waterCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkPrimary.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.darkPrimary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.water_drop,
              color: AppTheme.darkPrimary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Body Water',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Estimated from lean mass',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentRecord.estimatedTotalBodyWater.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTheme.darkText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 3, left: 2),
                child: Text(
                  'L',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _additionalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
          _infoRow(
            icon: Icons.calculate_outlined,
            label: 'BMI',
            value: currentRecord.bmi.toStringAsFixed(1),
            color: Colors.purple,
          ),
          Divider(height: 24, color: AppTheme.darkThird),
          _infoRow(
            icon: Icons.accessible_forward_rounded,
            label: 'Lean Body Mass',
            value: '${currentRecord.leanBodyMass.toStringAsFixed(1)} kg',
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkText,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
            color: AppTheme.darkText,
          ),
        ),
      ],
    );
  }

  Widget _trendsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
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
          _trendRow(label: 'Body Fat Trend', trend: currentRecord.bodyFatTrend),
          Divider(height: 24, color: AppTheme.darkThird),
          _trendRow(
            label: 'Muscle Mass Trend',
            trend: currentRecord.muscleMassTrend,
          ),
        ],
      ),
    );
  }

  Widget _trendRow({required String label, required String trend}) {
    Color trendColor;
    IconData trendIcon;

    switch (trend.toLowerCase()) {
      case 'up':
        trendColor = Colors.red;
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = Colors.green;
        trendIcon = Icons.trending_down;
        break;
      case 'stable':
      default:
        trendColor = Colors.grey;
        trendIcon = Icons.trending_flat;
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.darkText,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: trendColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(trendIcon, size: 16, color: trendColor),
              const SizedBox(width: 6),
              Text(
                trend.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: trendColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.darkThird),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.note_outlined, size: 24, color: Colors.grey.shade400),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentRecord.notes!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.darkText,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}