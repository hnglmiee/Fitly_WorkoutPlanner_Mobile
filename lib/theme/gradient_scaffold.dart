import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool enableGradient;

  const GradientScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.enableGradient = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: Container(
        decoration:
            enableGradient
                ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF0091FF).withOpacity(0.1),
                      const Color(0xFFB7E0FF).withOpacity(0.5),
                      const Color(0xFFEDF7FF).withOpacity(0.3),
                      Colors.white,
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                )
                : null,
        child: body,
      ),
    );
  }
}
