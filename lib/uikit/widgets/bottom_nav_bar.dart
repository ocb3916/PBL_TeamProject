import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.cardBackground,
      selectedItemColor: AppColors.textWhite,
      unselectedItemColor: AppColors.textGray,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
      ],
    );
  }
}
