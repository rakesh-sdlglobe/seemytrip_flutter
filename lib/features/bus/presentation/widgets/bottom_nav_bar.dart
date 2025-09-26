import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BusBottomNavBar extends StatelessWidget {

  const BusBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);
  final int selectedIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: AppColors.redCA0.withValues(alpha: 0.13),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.luggage, 'Bookings', 0),
          _buildNavItem(Icons.account_balance_wallet, 'Cash', 1),
          _buildNavItem(Icons.headset_mic, 'Help', 2),
        ],
      ),
    );

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.redCA0 : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.redCA0 : Colors.grey[600],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
