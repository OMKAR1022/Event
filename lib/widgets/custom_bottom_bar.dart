import 'package:flutter/material.dart';

enum BottomBarType { student, admin }

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BottomBarType type;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: _getBottomBarItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> _getBottomBarItems() {
    switch (type) {
      case BottomBarType.student:
        return [
          _buildBottomNavigationBarItem(
            icon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.calendar_today,
            label: 'Events',
            index: 1,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.person,
            label: 'Profile',
            index: 2,
          ),
        ];
      case BottomBarType.admin:
        return [
          _buildBottomNavigationBarItem(
            icon: Icons.home,
            label: 'Home',
            index: 0,
          ),
          _buildBottomNavigationBarItem(
            icon: Icons.person,
            label: 'Profile',
            index: 1,
          ),
        ];
    }
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
      activeIcon: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.blue[700]!,
              width: 3,
            ),
          ),
        ),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
      label: label,
    );
  }
}

