import 'package:flutter/material.dart';

Route slideRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Slide in from right
      final tweenIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      // Slight slide out for previous
      final tweenOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.08, 0.0),
      ).chain(CurveTween(curve: Curves.easeOut));

      return Stack(
        children: [
          SlideTransition(
            position: secondaryAnimation.drive(tweenOut),
            child: Container(color: Colors.transparent),
          ),
          SlideTransition(position: animation.drive(tweenIn), child: child),
        ],
      );
    },
  );
}
