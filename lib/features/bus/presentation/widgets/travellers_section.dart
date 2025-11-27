import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/traveller_form_config.dart';
import '../../../../core/theme/app_colors.dart' as AppTheme;
import '../../../../core/widgets/common/traveller_form_widget.dart';
import '../../../train/presentation/controllers/travellerDetailController.dart';
import '../../../train/presentation/screens/traveller_detail_screen.dart';
import '../../utils/traveller_utils.dart';

class TravellersSection extends StatefulWidget {
  final TravellerDetailController travellerController;
  final Set<String> selectedTravellers;
  final Function(Map<String, dynamic> traveller, bool selected)
      onTravellerSelected;
  final Function() onValidate;

  const TravellersSection({
    Key? key,
    required this.travellerController,
    required this.selectedTravellers,
    required this.onTravellerSelected,
    required this.onValidate,
  }) : super(key: key);

  @override
  State<TravellersSection> createState() => _TravellersSectionState();
}

class _TravellersSectionState extends State<TravellersSection> {
  bool _showAddGuestForm = false;
  final GlobalKey<FormState> _addGuestFormKey = GlobalKey<FormState>();
  final GlobalKey<TravellerFormWidgetState> _addGuestFormWidgetKey =
      GlobalKey<TravellerFormWidgetState>();
  Map<String, dynamic>? _savedGuestFormData;
  late TravellerFormConfig _addGuestConfig;

  @override
  void initState() {
    super.initState();
    _addGuestConfig = TravellerFormConfig.bus(
      title: 'Add Guest',
      subtitle: 'Add a guest to your saved travellers list',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Obx(() {
          final travellers = widget.travellerController.travellers;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saved Travellers (Optional)',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select from saved travellers or add new (${widget.selectedTravellers.length} selected)',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _showAddGuestForm = !_showAddGuestForm;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.AppColors.redCA0.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.AppColors.redCA0, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showAddGuestForm ? Icons.close : Icons.add,
                              color: AppTheme.AppColors.redCA0,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _showAddGuestForm ? 'Cancel' : 'Add Guest',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: AppTheme.AppColors.redCA0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.to(() => TravellerDetailScreen(
                            travelType: TravelType.bus,
                          )),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline,
                                color: Colors.blue, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Manage',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Add Guest Form (expandable)
              if (_showAddGuestForm) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.AppColors.redCA0.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.AppColors.redCA0.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TravellerFormWidget(
                        config: _addGuestConfig,
                        formKey: _addGuestFormKey,
                        widgetKey: _addGuestFormWidgetKey,
                        onSaved: (data) {
                          _savedGuestFormData = data;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showAddGuestForm = false;
                                _addGuestFormKey.currentState?.reset();
                                _savedGuestFormData = null;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _handleAddGuest,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.AppColors.redCA0,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add Guest'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50]?.withOpacity(0.5) ??
                      Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.blue[200] ?? Colors.blue, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can select saved travellers to auto-fill passenger details below, or add new travellers to your saved list.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (travellers.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.person_add_alt_1_outlined,
                          size: 40, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      Text(
                        'No saved travellers yet',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'You can add travellers or fill passenger details manually',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...travellers.map((traveller) {
                  final name = traveller['passengerName'] ??
                      traveller['firstname'] ??
                      'Unknown';
                  final age = traveller['passengerAge'] ?? traveller['age'];
                  final ageNum = age != null
                      ? (age is int ? age : int.tryParse(age.toString()))
                      : null;
                  final isSelected = widget.selectedTravellers.contains(name);
                  final isComplete =
                      TravellerUtils.isTravellerComplete(traveller);
                  final missingFields =
                      TravellerUtils.getMissingFields(traveller);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? (isComplete
                                ? AppTheme.AppColors.redCA0
                                : Colors.orange)
                            : Colors.grey.withOpacity(0.5),
                        width: isSelected ? 1.5 : 1,
                      ),
                      color: isSelected
                          ? (isComplete
                              ? AppTheme.AppColors.redCA0.withOpacity(0.05)
                              : Colors.orange.withOpacity(0.05))
                          : Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              if (!isComplete && isSelected)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Incomplete',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (ageNum != null)
                                Text(
                                  '$ageNum yrs • ${ageNum < 18 ? 'Child' : 'Adult'}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              if (!isComplete &&
                                  isSelected &&
                                  missingFields.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Missing: ${missingFields.join(", ")}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.orange[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          value: isSelected,
                          onChanged: (value) {
                            widget.onTravellerSelected(
                                traveller, value == true);
                          },
                          activeColor: AppTheme.AppColors.redCA0,
                        ),
                        if (!isComplete && isSelected)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Navigate to edit traveller with pre-filled data
                                  final travellers =
                                      widget.travellerController.travellers;
                                  final t = travellers.firstWhere(
                                    (t) =>
                                        (t['passengerName'] ??
                                            t['firstname'] ??
                                            'Unknown') ==
                                        name,
                                    orElse: () => <String, dynamic>{},
                                  );
                                  if (t.isNotEmpty) {
                                    Get.to(() => TravellerDetailScreen(
                                          traveller: t,
                                          travelType: TravelType.bus,
                                        ))?.then((_) {
                                      widget.travellerController
                                          .fetchTravelers();
                                      widget.onValidate();
                                    });
                                  }
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: Colors.orange, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit,
                                          size: 16, color: Colors.orange[700]),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Edit Details',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange[700],
                                        ),
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
                }).toList(),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _handleAddGuest() async {
    // Use post-frame callback to ensure widget is built
    await Future.microtask(() {});

    if (!_addGuestFormKey.currentState!.validate()) {
      return;
    }

    // Save the form first to ensure state is updated
    _addGuestFormKey.currentState?.save();

    // Try to get form data from widget state (primary method)
    Map<String, dynamic>? formData;
    final widgetState = _addGuestFormWidgetKey.currentState;

    if (widgetState != null) {
      formData = widgetState.getFormData();
      if (formData.isNotEmpty) {
        _savedGuestFormData = formData;
      }
    } else {
      formData = _savedGuestFormData;
    }

    if (formData != null && formData.isNotEmpty) {
      try {
        // Prepare data for controller
        final name = formData['name'] ?? formData['passengerName'] ?? '';
        final age = formData['age']?.toString() ?? '';
        final gender = formData['gender'] ?? formData['passengerGender'];
        final mobile = formData['mobile'] ??
            formData['phone'] ??
            formData['passengerMobileNumber'] ??
            '';
        final email = formData['email'] ?? '';
        final address = formData['address'] ?? '';

        // Validate required fields for bus
        if (name.isEmpty) {
          Get.snackbar(
            'Error',
            'Name is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (age.isEmpty) {
          Get.snackbar(
            'Error',
            'Age is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        final ageNum = int.tryParse(age);
        if (ageNum == null || ageNum < 0) {
          Get.snackbar(
            'Error',
            'Please enter a valid age',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (mobile.isEmpty) {
          Get.snackbar(
            'Error',
            'Mobile number is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (email.isEmpty) {
          Get.snackbar(
            'Error',
            'Email is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        if (address.isEmpty) {
          Get.snackbar(
            'Error',
            'Address is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Save the new traveller
        await widget.travellerController.saveTravellerDetails(
          name: name,
          age: age,
          gender: gender,
          mobile: mobile,
          berthPreference: '',
          foodPreference: '',
        );

        // Refresh travellers list
        await widget.travellerController.fetchTravelers();

        // Reset form and hide
        if (mounted) {
          _addGuestFormKey.currentState?.reset();
          _savedGuestFormData = null;
          setState(() {
            _showAddGuestForm = false;
          });

          Get.snackbar(
            'Success',
            'Guest added successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Failed to add guest: ${e.toString()}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } else {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
