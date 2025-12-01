import 'package:flutter/material.dart';

class CustomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final List<IconData> icons = [
    Icons.home,
    Icons.directions,
    Icons.dashboard,
    Icons.person_outline,
  ];
  final List<String> labels = ["Home", "Stats", "Chart", "Profile"];
  static const double itemSpacing = 8.0;
  static const double unselectedItemFixedSize = 60.0;
  static const double selectedItemWidth = 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xffc9e6ff),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        // Dùng Center để kiểm soát khoảng cách bằng SizedBox, khắc phục lỗi overflow
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(icons.length, (index) {
          final bool isSelected = index == widget.selectedIndex;

          Widget item = GestureDetector(
            onTap: () {
              widget.onItemTapped(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,

              // Loại bỏ padding ngang khi unselected để đảm bảo hình tròn
              padding:
                  isSelected
                      ? const EdgeInsets.symmetric(horizontal: 16, vertical: 15)
                      : const EdgeInsets.symmetric(horizontal: 0, vertical: 15),

              width: isSelected ? selectedItemWidth : unselectedItemFixedSize,

              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    isSelected
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                children: [
                  Icon(icons[index], color: Colors.blue),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      labels[index],
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );

          // Thêm SizedBox giữa các mục
          if (index < icons.length - 1) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [item, const SizedBox(width: itemSpacing)],
            );
          }
          return item;
        }),
      ),
    );
  }
}
