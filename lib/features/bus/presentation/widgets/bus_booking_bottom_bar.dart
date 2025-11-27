import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart' as AppTheme;
import 'fare_breakdown_modal.dart';

class BusBookingBottomBar extends StatelessWidget {
  final double baseFare;
  final int seatCount;
  final bool tripProtectionEnabled;
  final bool isFormValid;
  final bool isLoading;
  final VoidCallback? onProceed;

  const BusBookingBottomBar({
    super.key,
    required this.baseFare,
    required this.seatCount,
    required this.tripProtectionEnabled,
    required this.isFormValid,
    this.isLoading = false,
    this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    final double totalFare = (baseFare * seatCount).toDouble();
    final double tripProtection =
        tripProtectionEnabled ? (109.0 * seatCount) : 0.0;
    final double finalFare = totalFare + tripProtection;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.currency_rupee_rounded,
                      size: 20, color: AppTheme.AppColors.redCA0),
                  Text(
                    finalFare.toStringAsFixed(0),
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.AppColors.redCA0,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => FareBreakdownModal(
                      totalFare: totalFare,
                      finalFare: finalFare,
                      seatCount: seatCount,
                      tripProtectionEnabled: tripProtectionEnabled,
                    ),
                  );
                },
                child: Text(
                  'View Fare Details',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.AppColors.redCA0,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.AppColors.redCA0,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isFormValid && !isLoading
                    ? [
                        AppTheme.AppColors.redCA0,
                        AppTheme.AppColors.redCA0.withOpacity(0.9)
                      ]
                    : [Colors.grey[400]!, Colors.grey[500]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: isFormValid && !isLoading
                  ? [
                      BoxShadow(
                        color: AppTheme.AppColors.redCA0.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 0,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: (isFormValid && !isLoading) ? onProceed : null,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Proceed',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
