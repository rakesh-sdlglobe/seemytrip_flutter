import 'package:flutter/material.dart';

class PassengerFormWidget extends StatelessWidget {
  final int index;
  final List<TextEditingController> nameControllers;
  final List<TextEditingController> ageControllers;
  final List<TextEditingController> idNumberControllers;
  final List<List<bool>> genderSelections;
  final List<String> selectedIdProofTypes;
  final List<String> idProofTypes;
  final List<String> selectedSeats;
  final VoidCallback validateForm;
  final Function(int) onGenderSelected;

  const PassengerFormWidget({
    Key? key,
    required this.index,
    required this.nameControllers,
    required this.ageControllers,
    required this.idNumberControllers,
    required this.genderSelections,
    required this.selectedIdProofTypes,
    required this.idProofTypes,
    required this.selectedSeats,
    required this.validateForm,
    required this.onGenderSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Passenger Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _AppStyles.primary.withOpacity(0.05),
                  _AppStyles.primary.withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(
                bottom: BorderSide(color: _AppStyles.divider.withOpacity(0.2)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_AppStyles.primary, _AppStyles.primary.withOpacity(0.8)],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Passenger ${index + 1}',
                          style: _AppStyles.cardTitle.copyWith(
                            fontSize: 16,
                            color: _AppStyles.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _AppStyles.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.event_seat_rounded, color: _AppStyles.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'Seat ${selectedSeats[index]}',
                        style: _AppStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _AppStyles.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Form Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: nameControllers[index],
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age Field
                    _buildTextField(
                      controller: ageControllers[index],
                      label: 'Age',
                      icon: Icons.cake_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      onChanged: (_) => validateForm(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age <= 0 || age > 120) {
                          return 'Invalid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Gender Selector
                    _GenderSelector(
                      isSelected: genderSelections[index],
                      onPressed: onGenderSelected,
                    ),
                  ],
                ),
                // ID Proof Section
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Builder(
                    builder: (context) {
                      final age = int.tryParse(ageControllers[index].text);
                      if (age == null || age <= 5) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            'ID Proof (Required for age 5+)',
                            style: _AppStyles.subtitle.copyWith(
                              fontSize: 14,
                              color: _AppStyles.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: _buildDropdown(
                                  value: selectedIdProofTypes[index],
                                  items: idProofTypes,
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      selectedIdProofTypes[index] = newValue;
                                      (context as Element).markNeedsBuild();
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 6,
                                child: _buildTextField(
                                  controller: idNumberControllers[index],
                                  label: 'ID Number',
                                  icon: Icons.credit_card_rounded,
                                  onChanged: (_) => validateForm(),
                                  validator: (value) {
                                    if (age > 5 && (value == null || value.isEmpty)) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) => TextFormField(
      controller: controller,
      style: _AppStyles.body.copyWith(fontSize: 16, color: _AppStyles.textPrimary),
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: _AppStyles.subtitle.copyWith(fontSize: 14),
        floatingLabelStyle: TextStyle(color: _AppStyles.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _AppStyles.divider.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _AppStyles.divider.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _AppStyles.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Icon(icon, color: _AppStyles.primary.withOpacity(0.7), size: 22),
        filled: true,
        fillColor: _AppStyles.background,
        counterText: maxLength != null ? '' : null,
        hintStyle: _AppStyles.body.copyWith(color: _AppStyles.textSecondary),
      ),
    );

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) => Container(
      decoration: BoxDecoration(
        color: _AppStyles.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _AppStyles.divider.withOpacity(0.5)),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: _AppStyles.primary, size: 24),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.badge_outlined, color: _AppStyles.primary.withOpacity(0.7), size: 22),
            ),
            style: _AppStyles.body.copyWith(fontSize: 16, color: _AppStyles.textPrimary),
            dropdownColor: Colors.white,
            items: items.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(
                  type,
                  style: _AppStyles.body.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
}

class _GenderSelector extends StatelessWidget {
  final List<bool> isSelected;
  final Function(int) onPressed;

  _GenderSelector({
    Key? key,
    required List<bool> isSelected,
    required this.onPressed,
  })  : isSelected = isSelected.length == 3 ? isSelected : const [true, false, false],
       super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _AppStyles.divider.withOpacity(0.5)),
      ),
      child: ToggleButtons(
        borderRadius: BorderRadius.circular(10),
        selectedColor: Colors.white,
        fillColor: _AppStyles.primary,
        selectedBorderColor: _AppStyles.primary,
        borderColor: _AppStyles.divider.withOpacity(0.5),
        children: const [
          _GenderOption(label: 'Male', icon: Icons.male_rounded),
          _GenderOption(label: 'Female', icon: Icons.female_rounded),
          _GenderOption(label: 'Other', icon: Icons.transgender_rounded),
        ],
        isSelected: isSelected,
        onPressed: onPressed,
      ),
    );
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;

  const _GenderOption({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: _AppStyles.textPrimary),
            const SizedBox(width: 6),
            Text(
              label,
              style: _AppStyles.body.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}

class _AppStyles {
  static const Color primary = Color(0xFF1E88E5);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF8FAFC);
  static const Color iconColor = Color(0xFF616161);

  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
  );
}