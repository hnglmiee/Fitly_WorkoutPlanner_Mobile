import 'package:flutter/material.dart';
import 'package:workout_tracker_mini_project_mobile/screens/congratulation_page.dart';
import 'package:workout_tracker_mini_project_mobile/shared/navigation_bar.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  int selectedDayIndex = 2; // mặc định là Wednesday
  int _selectedIndex = 0; // Trạng thái Navigation Bar

  final List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  final List<String> dates = ["09", "10", "11", "12", "13", "14", "15"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Thêm logic điều hướng tại đây nếu có nhiều trang
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final thirdColor = Theme.of(context).colorScheme.background;

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      body: SafeArea(
        // THÊM CUỘN DỌC
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting + Profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hello,', style: TextStyle(fontSize: 20)),
                        SizedBox(height: 4),
                        Text(
                          'Jenny Wilson',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?img=3',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Training Plan (Lịch ngày - UI đã được FIX)
                const Text(
                  'Training Plan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 120, // Chiều cao cho phép chấm chỉ báo
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      bool isSelected = index == selectedDayIndex;
                      Color dayBackgroundColor =
                          isSelected ? Colors.blue : Colors.blue.shade100!;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDayIndex = index;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Chấm chỉ báo (Dot Indicator)
                            Container(
                              height: 5,
                              width: 5,
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),

                            // Thân Lịch Ngày
                            Container(
                              width: 60,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: dayBackgroundColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Tên ngày trong tuần (Mon, Tue, Wed)
                                    Text(
                                      days[index],
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Ngày (09, 10, 11) trong hình tròn/oval
                                    Container(
                                      width: 45,
                                      height: 45,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        dates[index],
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Workout Card (UI đã được FIX)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dòng "Progress"
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Row chứa thông tin và hình ảnh
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Phần thông tin Workout
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Text(
                                    'Cardio',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Lower Body',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Heavy weight for strength',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Hình ảnh
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://plus.unsplash.com/premium_photo-1661962342128-505f8032ea45?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Nút "Continue The Workout"
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CongratulationsPage(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Continue The Workout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            // Icon mũi tên trong hình tròn
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // My Activities (Đã FIX UI sang dạng cuộn ngang)
                const Text(
                  'My Activities',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),

                // THAY THẾ: Dùng SizedBox và ListView.builder để cuộn ngang
                SizedBox(
                  height: 50, // Chiều cao vừa đủ cho các nút pill
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4, // Số lượng activities
                    itemBuilder: (context, index) {
                      // Lấy màu từ Theme
                      final primaryColor =
                          Theme.of(context).colorScheme.primary;
                      final secondaryColor =
                          Theme.of(context).colorScheme.secondary;
                      final thirdColor =
                          Theme.of(context).colorScheme.background;

                      final activities = [
                        {'icon': Icons.fitness_center, 'label': 'Bench Press'},
                        {'icon': Icons.directions_run, 'label': 'Running'},
                        {'icon': Icons.accessibility_new, 'label': 'Squat'},
                        {'icon': Icons.fitness_center, 'label': 'Deadlift'},
                      ];

                      return Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                        ), // Khoảng cách giữa các mục
                        child: ActivityIcon(
                          icon: activities[index]['icon'] as IconData,
                          label: activities[index]['label'] as String,
                          iconColor: primaryColor,
                          bgColor:
                              secondaryColor, // Sử dụng secondaryColor làm màu nền sáng
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Daily Progress
                const Text(
                  'Daily Progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          // Sử dụng màu nền sáng từ theme
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Căn trái cho các mục
                          children: [
                            Row(
                              mainAxisSize:
                                  MainAxisSize.min, // Giữ Row vừa đủ nội dung
                              children: [
                                // Icon (Thay đổi icon cho gần giống hình mẫu)
                                Icon(
                                  Icons
                                      .local_drink_outlined, // Ví dụ dùng icon cốc/ly
                                  color: Colors.black, // Màu đen
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                // Label (Calories)
                                Text(
                                  'Calories',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ), // Khoảng cách giữa label và giá trị
                            // Giá trị lớn (1,024 kcal)
                            Text(
                              '1,024 kcal',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22, // Kích thước lớn hơn
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start, // Căn trái cho các mục
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Icon (Sử dụng icon gần giống máy chạy bộ)
                                Icon(
                                  Icons.directions_run,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                // Label (Steps)
                                Text(
                                  'Steps',
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Giá trị lớn (1000 steps)
                            Text(
                              '1,000 steps',
                              style: Theme.of(
                                context,
                              ).textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SỬA ĐỔI LỚP ActivityIcon
class ActivityIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;

  const ActivityIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    // THAY ĐỔI: Container lớn hơn cho hiệu ứng pill (viên thuốc)
    return Container(
      // Padding để tạo khoảng trống cho chữ và icon
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor, // Màu nền sáng (secondary/third)
        borderRadius: BorderRadius.circular(30), // Bo tròn tối đa
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Giúp Container chỉ rộng bằng nội dung
        children: [
          // Container icon tròn nhỏ hơn
          Container(
            padding: const EdgeInsets.all(8), // Padding icon nhỏ hơn
            decoration: BoxDecoration(
              color: Colors.white, // Nền trắng cho icon
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 18, color: iconColor), // Icon nhỏ hơn
          ),
          const SizedBox(width: 8), // Khoảng cách giữa icon và chữ

          Text(
            label,
            style: const TextStyle(fontSize: 14), // Text style phù hợp
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
