// screens/in_body_history_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/in_body_data.dart';
import '../services/in_body_service.dart';
import '../theme/app_theme.dart';
import 'in_body_detail_screen.dart';

class InBodyHistoryScreen extends StatefulWidget {
  const InBodyHistoryScreen({super.key});

  @override
  State<InBodyHistoryScreen> createState() => _InBodyHistoryScreenState();
}

class _InBodyHistoryScreenState extends State<InBodyHistoryScreen> {
  Future<List<InBodyData>>? _recordsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  void _loadRecords() {
    setState(() {
      _recordsFuture = InBodyService.fetchMyInBodyRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Header
            _header(context),

            Expanded(
              child: FutureBuilder<List<InBodyData>>(
                future: _recordsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child:
                      CircularProgressIndicator(color: AppTheme.darkPrimary),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Failed to load records',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _loadRecords,
                              icon: const Icon(Icons.refresh,
                                  color: AppTheme.darkBackground),
                              label: const Text('Retry',
                                  style: TextStyle(
                                      color: AppTheme.darkBackground)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.darkPrimary,
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No records yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final records = snapshot.data!;
                  // Sort by measuredAt descending (newest first)
                  records.sort((a, b) => b.measuredAt.compareTo(a.measuredAt));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      final isLatest = index == 0;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _RecordCard(
                          record: record,
                          isLatest: isLatest,
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    InBodyDetailScreen(record: record),
                              ),
                            );

                            if (result != null) {
                              if (result is Map && result['deleted'] == true) {
                                _loadRecords();
                              } else {
                                _loadRecords();
                              }
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Header
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                size: 20, color: AppTheme.darkText),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          const Text(
            'In Body History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.darkText,
            ),
          ),
          const Spacer(),
          const Opacity(
            opacity: 0,
            child: Icon(Icons.arrow_back_ios, size: 20),
          ),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final InBodyData record;
  final bool isLatest;
  final VoidCallback onTap;

  const _RecordCard({
    required this.record,
    required this.isLatest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: isLatest
            ? LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.darkPrimary.withOpacity(0.15),
            AppTheme.darkPrimary.withOpacity(0.05),
          ],
        )
            : null,
        color: isLatest ? null : AppTheme.darkSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLatest
              ? AppTheme.darkPrimary.withOpacity(0.3)
              : AppTheme.darkThird,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.darkPrimary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.fitness_center,
                        size: 20,
                        color: AppTheme.darkPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy').format(record.measuredAt),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              color: AppTheme.darkText,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(record.measuredAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLatest)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade400.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star,
                                size: 14, color: Colors.green.shade400),
                            const SizedBox(width: 4),
                            Text(
                              'Latest',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Stats
                Row(
                  children: [
                    _StatChip(
                      label: 'Weight',
                      value: record.weight.toStringAsFixed(1),
                      unit: 'kg',
                      icon: Icons.monitor_weight_outlined,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Body Fat',
                      value: record.bodyFatPercentage.toStringAsFixed(1),
                      unit: '%',
                      icon: Icons.local_fire_department_rounded,
                    ),
                    const SizedBox(width: 8),
                    _StatChip(
                      label: 'Muscle',
                      value: record.muscleMass.toStringAsFixed(1),
                      unit: '%',
                      icon: Icons.fitness_center,
                    ),
                  ],
                ),

                // Notes (if exists)
                if (record.notes != null && record.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkThird,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.notes!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade300,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.darkThird,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: AppTheme.darkPrimary),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    color: AppTheme.darkText,
                  ),
                ),
                const SizedBox(width: 2),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    unit,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}