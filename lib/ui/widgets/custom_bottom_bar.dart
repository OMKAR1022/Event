import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';


class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: AnimatedNotchBottomBar(
        notchColor: Colors.blue.shade600,
        color: Colors.white,
        showLabel: false,
        notchBottomBarController: NotchBottomBarController(index: currentIndex),
        onTap: onTap,
        kBottomRadius: 30.0,
        kIconSize: 28.0,
        bottomBarItems: [
          _buildBottomBarItem(
            activeIcon: Icons.home,
            inactiveIcon: Icons.home_filled,
            index: 0,
          ),
          _buildBottomBarItem(
            activeIcon: Icons.calendar_month,
            inactiveIcon: Icons.calendar_month_outlined,
            index: 1,
          ),
          _buildBottomBarItem(
            activeIcon: Icons.person,
            inactiveIcon: Icons.person_outline,
            index: 2,
          ),
        ],
        removeMargins: true,
      ),
    );
  }

  BottomBarItem _buildBottomBarItem({
    required IconData activeIcon,
    required IconData inactiveIcon,
    required int index,
  }) {
    final isActive = currentIndex == index;
    return BottomBarItem(
      inActiveItem: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Icon(
          inactiveIcon,
          color: Colors.grey.shade400,
          size: 28,
        ),
      ),
      activeItem: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          Positioned.fill(
            top: -8, // Half of the container height to center it
            child: Align(
              alignment: Alignment.center,
              child: Icon(
                activeIcon,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

