import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart' as AppTheme;
import '../screens/passenger_form.dart';

class PassengerDetailsCard extends StatelessWidget {
  final List<String> selectedSeats;
  final List<TextEditingController> nameControllers;
  final List<TextEditingController> ageControllers;
  final List<TextEditingController> idNumberControllers;
  final List<List<bool>> genderSelections;
  final List<String> selectedIdProofTypes;
  final List<String> idProofTypes;
  final VoidCallback onValidate;
  final Function(int passengerIndex, int genderIndex) onGenderSelected;

  const PassengerDetailsCard({
    super.key,
    required this.selectedSeats,
    required this.nameControllers,
    required this.ageControllers,
    required this.idNumberControllers,
    required this.genderSelections,
    required this.selectedIdProofTypes,
    required this.idProofTypes,
    required this.onValidate,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.AppColors.redCA0,
                      AppTheme.AppColors.redCA0.withOpacity(0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people_alt_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Passenger Details',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enter details for each passenger. All fields are mandatory.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
          const SizedBox(height: 20),

          // Passenger Forms
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedSeats.length,
            itemBuilder: (context, index) => TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: PassengerFormWidget(
                      index: index,
                      nameControllers: nameControllers,
                      ageControllers: ageControllers,
                      idNumberControllers: idNumberControllers,
                      genderSelections: genderSelections,
                      selectedIdProofTypes: selectedIdProofTypes,
                      idProofTypes: idProofTypes,
                      selectedSeats: selectedSeats,
                      validateForm: onValidate,
                      onGenderSelected: (genderIndex) {
                        onGenderSelected(index, genderIndex);
                        onValidate();
                      },
                    ),
                  ),
                );
              },
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: child,
        ),
      );
}
