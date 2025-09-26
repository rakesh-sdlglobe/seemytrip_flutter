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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Theme.of(context).brightness == Brightness.dark ? Border.all(
          color: AppColors.borderDark.withValues(alpha: 0.3),
          width: 1,
        ) : null,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? AppColors.shadowDark.withValues(alpha: 0.3)
                : AppColors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.redCA0.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.luggage, 'Bookings', 0, context),
          _buildNavItem(Icons.account_balance_wallet, 'Cash', 1, context),
          _buildNavItem(Icons.headset_mic, 'Help', 2, context),
        ],
      ),
    );

  Widget _buildNavItem(IconData icon, String label, int index, BuildContext context) {
    bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onItemTapped(index),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.redCA0.withValues(alpha: 0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? AppColors.redCA0.withValues(alpha: 0.15) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected 
                      ? AppColors.redCA0 
                      : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : Colors.grey[600]),
                  size: 20,
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 200),
                style: TextStyle(
                  color: isSelected 
                      ? AppColors.redCA0 
                      : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : Colors.grey[600]),
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
