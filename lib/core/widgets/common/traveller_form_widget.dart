import 'package:flutter/material.dart';
import '../../models/traveller_form_config.dart';
import 'inputs/app_text_field.dart';
import 'inputs/dropdown_field.dart';

/// A reusable traveller form widget that can be configured for different travel types
class TravellerFormWidget extends StatefulWidget {
  final TravellerFormConfig config;
  final GlobalKey<FormState>? formKey;
  final GlobalKey<TravellerFormWidgetState>? widgetKey; // Key to access widget state
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>)? onSaved;
  final Function()? onChanged;
  final int? passengerIndex; // For bus/flight where multiple passengers are shown
  final bool showHeader; // Show passenger header with index/seat

  TravellerFormWidget({
    Key? key,
    required this.config,
    this.formKey,
    this.widgetKey,
    this.initialData,
    this.onSaved,
    this.onChanged,
    this.passengerIndex,
    this.showHeader = false,
  }) : super(key: widgetKey as Key? ?? key);

  @override
  State<TravellerFormWidget> createState() => TravellerFormWidgetState();
}

/// State class for TravellerFormWidget - made public to allow access via GlobalKey
class TravellerFormWidgetState extends State<TravellerFormWidget> {
  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _ageController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;
  late final TextEditingController _idNumberController;
  late final TextEditingController _roomIdController;
  late final TextEditingController _dobController;

  // Dropdown values
  String? _selectedGender;
  String? _selectedBerth;
  String? _selectedFood;
  String? _selectedIdProofType;
  String? _selectedTitle; // Hotel: Title (Mr, Mrs, Miss, Master, etc.)
  String? _selectedMobilePrefix; // Hotel: Mobile prefix (+91, etc.)

  // Hotel specific
  bool _leadPax = false; // Hotel: Lead passenger checkbox
  String? _paxType; // Hotel: Passenger type (A=Adult, C=Child)
  DateTime? _selectedDob; // Hotel: Date of birth for children

  // Gender selection for bus (toggle buttons)
  late List<bool> _genderSelection; // Male, Female, Other

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _nameController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _mobileController = TextEditingController();
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _postalCodeController = TextEditingController();
    _countryController = TextEditingController();
    _idNumberController = TextEditingController();
    _roomIdController = TextEditingController();
    _dobController = TextEditingController();
    
    // Initialize gender selection
    _genderSelection = [false, false, false]; // Male, Female, Other
    
    // Initialize hotel-specific defaults
    if (widget.config.showTitle) {
      _selectedTitle = widget.config.titleOptions?.first;
    }
    if (widget.config.showMobilePrefix) {
      _selectedMobilePrefix = widget.config.mobilePrefixOptions?.first ?? '+91';
    }
    if (widget.config.showPaxType) {
      _paxType = widget.config.showAge ? 'C' : 'A'; // C for children (has age), A for adults
    }

    // Initialize from initialData if provided
    if (widget.initialData != null) {
      _initializeFromData(widget.initialData!);
    }

    // Set default values
    if (widget.config.showBerthPreference) {
      _selectedBerth = widget.config.berthOptions?.last ?? 'No Preference';
    }
    if (widget.config.showFoodPreference) {
      _selectedFood = widget.config.foodOptions?.first ?? 'Veg';
    }
    if (widget.config.showIdProof) {
      _selectedIdProofType = widget.config.idProofTypes?.first ?? 'Aadhaar';
    }

    // Add listeners for onChange callback
    _nameController.addListener(_onFieldChanged);
    _firstNameController.addListener(_onFieldChanged);
    _middleNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _ageController.addListener(_onFieldChanged);
    _mobileController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _roomIdController.addListener(_onFieldChanged);
    _dobController.addListener(_onFieldChanged);
  }

  void _initializeFromData(Map<String, dynamic> data) {
    if (widget.config.showName) {
      _nameController.text = data['passengerName'] ?? 
                            data['firstname'] ?? 
                            data['name'] ?? '';
    }
    if (widget.config.showFirstName) {
      _firstNameController.text = data['firstName'] ?? 
                                 data['firstAndMiddleName'] ?? '';
    }
    if (widget.config.showMiddleName) {
      _middleNameController.text = data['middleName'] ?? '';
    }
    if (widget.config.showLastName) {
      _lastNameController.text = data['lastName'] ?? '';
    }
    if (widget.config.showAge) {
      _ageController.text = data['passengerAge']?.toString() ?? 
                           data['age']?.toString() ?? '';
    }
    if (widget.config.showMobile) {
      _mobileController.text = data['passengerMobileNumber'] ?? 
                              data['mobile'] ?? 
                              data['phone'] ?? '';
    }
    if (widget.config.showEmail) {
      _emailController.text = data['contact_email'] ?? data['email'] ?? '';
    }
    if (widget.config.showAddress) {
      _addressController.text = data['address'] ?? '';
    }
    if (widget.config.showCity) {
      _cityController.text = data['city'] ?? '';
    }
    if (widget.config.showPostalCode) {
      _postalCodeController.text = data['postalCode'] ?? '';
    }
    if (widget.config.showCountry) {
      _countryController.text = data['country'] ?? '';
    }
    if (widget.config.showIdNumber) {
      _idNumberController.text = data['idNumber'] ?? '';
    }
    if (widget.config.showRoomId) {
      _roomIdController.text = data['roomId']?.toString() ?? data['room_id']?.toString() ?? '';
    }
    if (widget.config.showDob) {
      if (data['dob'] != null) {
        if (data['dob'] is DateTime) {
          _selectedDob = data['dob'] as DateTime;
        } else if (data['dob'] is String) {
          _selectedDob = DateTime.tryParse(data['dob']);
        }
        if (_selectedDob != null) {
          _dobController.text = '${_selectedDob!.day}/${_selectedDob!.month}/${_selectedDob!.year}';
        }
      }
    }

    // Set hotel-specific dropdown values
    if (widget.config.showTitle) {
      _selectedTitle = data['title'] ?? widget.config.titleOptions?.first;
    }
    if (widget.config.showMobilePrefix) {
      _selectedMobilePrefix = data['mobilePrefix'] ?? data['mobile_prefix'] ?? widget.config.mobilePrefixOptions?.first ?? '+91';
    }
    if (widget.config.showLeadPax) {
      _leadPax = data['leadPax'] ?? data['lead_pax'] ?? false;
    }
    if (widget.config.showPaxType) {
      _paxType = data['paxType'] ?? data['pax_type'] ?? (widget.config.showAge ? 'C' : 'A');
    }

    // Set dropdown values - convert gender codes to full names
    final genderValue = data['passengerGender'] ?? data['gender'];
    if (genderValue != null) {
      final genderStr = genderValue.toString();
      if (genderStr == 'M' || genderStr.toLowerCase() == 'male') {
        _selectedGender = 'Male';
      } else if (genderStr == 'F' || genderStr.toLowerCase() == 'female') {
        _selectedGender = 'Female';
      } else if (genderStr == 'O' || genderStr.toLowerCase() == 'other') {
        _selectedGender = 'Other';
      } else {
        _selectedGender = genderStr; // Use as-is if it's already a full name
      }
    } else {
      _selectedGender = null;
    }
    
    // Set gender selection for bus
    if (widget.config.travelType == TravelType.bus) {
      final gender = data['passengerGender'] ?? data['gender'];
      if (gender != null) {
        final genderStr = gender.toString();
        if (genderStr == 'M' || genderStr.toLowerCase() == 'male' || genderStr == 'Male') {
          _genderSelection = [true, false, false];
        } else if (genderStr == 'F' || genderStr.toLowerCase() == 'female' || genderStr == 'Female') {
          _genderSelection = [false, true, false];
        } else if (genderStr == 'O' || genderStr.toLowerCase() == 'other' || genderStr == 'Other') {
          _genderSelection = [false, false, true];
        }
      }
    }
    
    if (widget.config.showBerthPreference) {
      final berthCode = data['passengerBerthChoice'];
      if (berthCode != null) {
        final berthMap = {
          'LB': 'Lower Berth',
          'MB': 'Middle Berth',
          'UB': 'Upper Berth',
          'SL': 'Side Lower',
          'SU': 'Side Upper',
        };
        _selectedBerth = berthMap[berthCode] ?? 'No Preference';
      }
    }
    
    if (widget.config.showFoodPreference) {
      _selectedFood = data['passengerFoodChoice'] ?? 'Veg';
    }
    
    if (widget.config.showIdProof) {
      _selectedIdProofType = data['idProofType'] ?? 
                            widget.config.idProofTypes?.first;
    }
  }

  void _onFieldChanged() {
    widget.onChanged?.call();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _idNumberController.dispose();
    _roomIdController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  /// Get all form data as a map
  Map<String, dynamic> getFormData() {
    final data = <String, dynamic>{};
    
    if (widget.config.showName) {
      data['name'] = _nameController.text;
      data['passengerName'] = _nameController.text;
    }
    if (widget.config.showFirstName) {
      data['firstName'] = _firstNameController.text;
      data['firstAndMiddleName'] = _firstNameController.text;
    }
    if (widget.config.showMiddleName) {
      data['middleName'] = _middleNameController.text;
    }
    if (widget.config.showLastName) {
      data['lastName'] = _lastNameController.text;
    }
    if (widget.config.showAge) {
      data['age'] = _ageController.text;
      data['passengerAge'] = int.tryParse(_ageController.text);
    }
    if (widget.config.showGender) {
      if (widget.config.travelType == TravelType.bus) {
        // For bus, get from toggle buttons
        if (_genderSelection[0]) {
          data['gender'] = 'Male';
          data['passengerGender'] = 'Male';
        } else if (_genderSelection[1]) {
          data['gender'] = 'Female';
          data['passengerGender'] = 'Female';
        } else if (_genderSelection[2]) {
          data['gender'] = 'Other';
          data['passengerGender'] = 'Other';
        }
      } else {
        data['gender'] = _selectedGender;
        data['passengerGender'] = _selectedGender;
      }
    }
    if (widget.config.showMobile) {
      data['mobile'] = _mobileController.text;
      data['phone'] = _mobileController.text;
      data['passengerMobileNumber'] = _mobileController.text;
      // Include mobile prefix if available
      if (widget.config.showMobilePrefix && _selectedMobilePrefix != null) {
        data['mobilePrefix'] = _selectedMobilePrefix;
        data['mobile_prefix'] = _selectedMobilePrefix;
        // Combine prefix with mobile number for full number
        if (_mobileController.text.isNotEmpty) {
          data['fullMobileNumber'] = '$_selectedMobilePrefix${_mobileController.text}';
        }
      }
    }
    if (widget.config.showEmail) {
      data['email'] = _emailController.text;
      data['contact_email'] = _emailController.text; // Also include contact_email for backend
    }
    if (widget.config.showAddress) {
      data['address'] = _addressController.text;
    }
    if (widget.config.showCity) {
      data['city'] = _cityController.text;
    }
    if (widget.config.showPostalCode) {
      data['postalCode'] = _postalCodeController.text;
    }
    if (widget.config.showCountry) {
      data['country'] = _countryController.text;
    }
    if (widget.config.showBerthPreference) {
      final berthMap = {
        'Lower Berth': 'LB',
        'Middle Berth': 'MB',
        'Upper Berth': 'UB',
        'Side Lower': 'SL',
        'Side Upper': 'SU',
      };
      data['passengerBerthChoice'] = berthMap[_selectedBerth] ?? 'NP';
    }
    if (widget.config.showFoodPreference) {
      data['passengerFoodChoice'] = _selectedFood;
    }
    if (widget.config.showIdProof) {
      data['idProofType'] = _selectedIdProofType;
    }
    if (widget.config.showIdNumber) {
      data['idNumber'] = _idNumberController.text;
    }
    if (widget.config.showSeatNumber && widget.config.seatNumber != null) {
      data['seatNumber'] = widget.config.seatNumber;
    }
    
    // Hotel-specific fields
    if (widget.config.showTitle) {
      data['title'] = _selectedTitle;
    }
    if (widget.config.showRoomId) {
      data['roomId'] = _roomIdController.text;
      data['room_id'] = _roomIdController.text;
    }
    if (widget.config.showLeadPax) {
      data['leadPax'] = _leadPax;
      data['lead_pax'] = _leadPax;
    }
    if (widget.config.showPaxType) {
      data['paxType'] = _paxType;
      data['pax_type'] = _paxType;
    }
    if (widget.config.showDob && _selectedDob != null) {
      data['dob'] = _selectedDob!.toIso8601String().split('T')[0]; // Format as YYYY-MM-DD
      data['dateOfBirth'] = _selectedDob!.toIso8601String().split('T')[0];
    }
    
    return data;
  }

  /// Validate the form
  bool validate() {
    return widget.formKey?.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Form(
      key: widget.formKey,
      onChanged: () {
        if (widget.onSaved != null && validate()) {
          widget.onSaved!(getFormData());
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (for bus/flight with passenger index)
          if (widget.showHeader && widget.passengerIndex != null)
            _buildHeader(context, theme),
          
          // Title and subtitle
          if (widget.config.title != null) ...[
            Text(
              widget.config.title!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.config.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                widget.config.subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],

          // Form fields - use sections if configured, otherwise linear layout
          if (widget.config.useSections && widget.config.sections != null)
            ..._buildFormFieldsWithSections(context, theme)
          else
            ..._buildFormFields(context, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.05),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          bottom: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.passengerIndex! + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Passenger ${widget.passengerIndex! + 1}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.config.showSeatNumber && widget.config.seatNumber != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_seat_rounded, 
                       color: theme.primaryColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Seat ${widget.config.seatNumber}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a text field with styling based on travel type
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLength,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    // Use different styling based on travel type
    if (widget.config.travelType == TravelType.hotel) {
      // Hotel-specific styling (matches original hotel form)
      return TextFormField(
        controller: controller,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFFFF5722)
                  : const Color(0xFFCA0B0B),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(icon, size: 22, color: Colors.grey[600]),
          ),
          counterText: maxLength != null ? '' : null,
        ),
        validator: validator,
        cursorColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFFF5722)
            : const Color(0xFFCA0B0B),
      );
    } else {
      // Default styling for train/bus/flight (using AppTextField)
      return AppTextField(
        controller: controller,
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        keyboardType: keyboardType,
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        validator: validator,
      );
    }
  }

  List<Widget> _buildFormFields(BuildContext context, ThemeData theme) {
    final fields = <Widget>[];

    // Name field (full name)
    if (widget.config.showName) {
      fields.add(
        _buildTextField(
          context: context,
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter full name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Title dropdown (Hotel)
    if (widget.config.showTitle) {
      fields.add(
        DropdownField<String>(
          value: _selectedTitle,
          labelText: 'Title',
          hintText: 'Select title',
          items: DropdownItems.fromList(
            items: widget.config.titleOptions ?? [],
            displayText: (item) => item,
          ),
          onChanged: (value) {
            setState(() => _selectedTitle = value);
            _onFieldChanged();
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // First Name and Last Name (for flights/hotels)
    if (widget.config.showFirstName || widget.config.showLastName) {
      if (widget.config.showFirstName) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _firstNameController,
            label: 'First Name',
            hint: 'Enter first name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'First name is required';
              }
              return null;
            },
          ),
        );
        fields.add(const SizedBox(height: 16));
      }
      
      // Middle Name (Hotel - optional)
      if (widget.config.showMiddleName) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _middleNameController,
            label: 'Middle Name (Optional)',
            hint: 'Enter middle name',
            icon: Icons.person_outline,
          ),
        );
        fields.add(const SizedBox(height: 16));
      }
      
      if (widget.config.showLastName) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _lastNameController,
            label: 'Last Name',
            hint: 'Enter last name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Last name is required';
              }
              return null;
            },
          ),
        );
        fields.add(const SizedBox(height: 16));
      }
    }

    // Age and Gender row (for train/bus)
    if (widget.config.showAge && widget.config.showGender && 
        widget.config.travelType != TravelType.flight) {
      fields.add(
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                context: context,
                controller: _ageController,
                label: 'Age',
                hint: 'Age',
                icon: Icons.cake_rounded,
                keyboardType: TextInputType.number,
                maxLength: 3,
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
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: _buildGenderDropdown(context),
            ),
          ],
        ),
      );
      fields.add(const SizedBox(height: 16));
    } else {
      // Age only
      if (widget.config.showAge) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _ageController,
            label: 'Age',
            hint: 'Age',
            icon: Icons.cake_rounded,
            keyboardType: TextInputType.number,
            maxLength: 3,
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
        );
        fields.add(const SizedBox(height: 16));
      }

      // Gender (for flight or standalone)
      if (widget.config.showGender) {
        if (widget.config.travelType == TravelType.bus) {
          fields.add(_buildGenderToggle(context));
        } else {
          fields.add(_buildGenderDropdown(context));
        }
        fields.add(const SizedBox(height: 16));
      }
    }

    // Mobile number with prefix (Hotel)
    if (widget.config.showMobile) {
      if (widget.config.showMobilePrefix) {
        // Mobile with prefix dropdown
        fields.add(
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownField<String>(
                  value: _selectedMobilePrefix,
                  labelText: 'Prefix',
                  hintText: 'Prefix',
                  items: DropdownItems.fromList(
                    items: widget.config.mobilePrefixOptions ?? ['+91'],
                    displayText: (item) => item,
                  ),
                  onChanged: (value) {
                    setState(() => _selectedMobilePrefix = value);
                    _onFieldChanged();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: _buildTextField(
                  context: context,
                  controller: _mobileController,
                  label: 'Mobile Number',
                  hint: 'Enter mobile number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mobile number is required';
                    }
                    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
                    if (cleaned.length < 10) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        // Mobile without prefix
        fields.add(
          _buildTextField(
            context: context,
            controller: _mobileController,
            label: 'Mobile Number',
            hint: 'Enter mobile number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mobile number is required';
              }
              final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
              if (cleaned.length < 10) {
                return 'Enter a valid 10-digit mobile number';
              }
              return null;
            },
          ),
        );
      }
      fields.add(const SizedBox(height: 16));
    }

    // Email
    if (widget.config.showEmail) {
      fields.add(
        _buildTextField(
          context: context,
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Address fields (Hotel/Bus) - Show right after email for better flow
    if (widget.config.showAddress || widget.config.showCity || widget.config.showPostalCode || widget.config.showCountry) {
      // Address Line 1
      if (widget.config.showAddress) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _addressController,
            label: 'Address Line 1',
            hint: 'Enter street address',
            icon: Icons.home_outlined,
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Address is required';
              }
              if (value.length < 5) {
                return 'Please enter a valid address';
              }
              return null;
            },
          ),
        );
        fields.add(const SizedBox(height: 16));
      }

      // City and Postal Code in a row
      if (widget.config.showCity || widget.config.showPostalCode) {
        fields.add(
          Row(
            children: [
              if (widget.config.showCity) ...[
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    context: context,
                    controller: _cityController,
                    label: 'City',
                    hint: 'Enter city',
                    icon: Icons.location_city_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'City is required';
                      }
                      return null;
                    },
                  ),
                ),
                if (widget.config.showPostalCode) const SizedBox(width: 16),
              ],
              if (widget.config.showPostalCode)
                Expanded(
                  child: _buildTextField(
                    context: context,
                    controller: _postalCodeController,
                    label: 'Postal Code',
                    hint: 'Enter postal code',
                    icon: Icons.numbers_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ),
            ],
          ),
        );
        fields.add(const SizedBox(height: 16));
      }

      // Country
      if (widget.config.showCountry) {
        fields.add(
          _buildTextField(
            context: context,
            controller: _countryController,
            label: 'Country',
            hint: 'Enter country',
            icon: Icons.flag_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Country is required';
              }
              return null;
            },
          ),
        );
        fields.add(const SizedBox(height: 16));
      }
    }

    // Room ID (Hotel)
    if (widget.config.showRoomId) {
      fields.add(
        _buildTextField(
          context: context,
          controller: _roomIdController,
          label: 'Room ID',
          hint: 'Enter room ID',
          icon: Icons.hotel_outlined,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Room ID is required';
            }
            return null;
          },
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Lead Pax checkbox (Hotel - Adults only)
    if (widget.config.showLeadPax) {
      fields.add(
        CheckboxListTile(
          title: const Text('Lead Passenger'),
          subtitle: const Text('First passenger in the booking'),
          value: _leadPax,
          onChanged: (value) {
            setState(() => _leadPax = value ?? false);
            _onFieldChanged();
          },
          controlAffinity: ListTileControlAffinity.leading,
        ),
      );
      fields.add(const SizedBox(height: 8));
    }

    // DOB Date Picker (Hotel - Children only)
    if (widget.config.showDob) {
      fields.add(
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDob ?? DateTime.now().subtract(const Duration(days: 365 * 5)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              setState(() {
                _selectedDob = picked;
                _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
              });
              _onFieldChanged();
            }
          },
          child: AbsorbPointer(
            child: _buildTextField(
              context: context,
              controller: _dobController,
              label: 'Date of Birth',
              hint: 'Select date of birth',
              icon: Icons.calendar_today_outlined,
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Date of birth is required';
                }
                return null;
              },
            ),
          ),
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Berth Preference (Train)
    if (widget.config.showBerthPreference) {
      fields.add(
        DropdownField<String>(
          value: _selectedBerth,
          labelText: 'Berth Preference',
          hintText: 'Select berth preference',
          items: DropdownItems.fromList(
            items: widget.config.berthOptions ?? [],
            displayText: (item) => item,
          ),
          onChanged: (value) {
            setState(() => _selectedBerth = value);
            _onFieldChanged();
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // Food Preference (Train)
    if (widget.config.showFoodPreference) {
      fields.add(
        DropdownField<String>(
          value: _selectedFood,
          labelText: 'Food Preference',
          hintText: 'Select food preference',
          items: DropdownItems.fromList(
            items: widget.config.foodOptions ?? [],
            displayText: (item) => item,
          ),
          onChanged: (value) {
            setState(() => _selectedFood = value);
            _onFieldChanged();
          },
          validator: (value) => value == null ? 'Required' : null,
        ),
      );
      fields.add(const SizedBox(height: 16));
    }

    // ID Proof Section (Bus) - optional, always shown
    if (widget.config.showIdProof || widget.config.showIdNumber) {
      fields.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.config.showIdProof) ...[
              Text(
                'ID Proof (Optional)',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
            ],
            Row(
              children: [
                if (widget.config.showIdProof) ...[
                  Expanded(
                    flex: 4,
                    child: DropdownField<String>(
                      value: _selectedIdProofType,
                      hintText: 'Select ID type',
                      items: DropdownItems.fromList(
                        items: widget.config.idProofTypes ?? [],
                        displayText: (item) => item,
                      ),
                      onChanged: (value) {
                        setState(() => _selectedIdProofType = value);
                        _onFieldChanged();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                if (widget.config.showIdNumber)
                  Expanded(
                    flex: widget.config.showIdProof ? 6 : 1,
                    child: _buildTextField(
                      context: context,
                      controller: _idNumberController,
                      label: 'ID Number (Optional)',
                      hint: 'Enter ID number',
                      icon: Icons.credit_card_rounded,
                      // ID proof is optional, no validation required
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
      fields.add(const SizedBox(height: 16));
    }


    return fields;
  }

  /// Builds form fields organized by sections (for hotel and other complex forms)
  List<Widget> _buildFormFieldsWithSections(BuildContext context, ThemeData theme) {
    final widgets = <Widget>[];
    
    if (widget.config.sections == null) {
      return _buildFormFields(context, theme);
    }
    
    for (int i = 0; i < widget.config.sections!.length; i++) {
      final section = widget.config.sections![i];
      
      // Section header
      if (section.title != null) {
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (i > 0 && section.showDivider) ...[
                const SizedBox(height: 24),
                Divider(color: theme.dividerColor.withOpacity(0.3)),
                const SizedBox(height: 24),
              ] else if (i > 0) ...[
                const SizedBox(height: 20),
              ],
              Text(
                section.title!,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              if (section.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  section.subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                    fontSize: 11,
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        );
      }
      
      // Section fields
      for (final fieldName in section.fieldOrder) {
        final field = _buildFieldByName(context, fieldName);
        if (field != null) {
          widgets.add(field);
          widgets.add(const SizedBox(height: 16));
        }
      }
    }
    
    return widgets;
  }

  /// Builds a specific field by its name
  Widget? _buildFieldByName(BuildContext context, String fieldName) {
    switch (fieldName) {
      case 'name':
        if (!widget.config.showName) return null;
        return _buildTextField(
          context: context,
          controller: _nameController,
          label: 'Full Name',
          hint: 'Enter full name',
          icon: Icons.person_outline,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        );
      
      case 'email':
        if (!widget.config.showEmail) return null;
        return _buildTextField(
          context: context,
          controller: _emailController,
          label: 'Email Address',
          hint: 'Enter email address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Enter a valid email address';
            }
            return null;
          },
        );
      
      case 'mobile':
        if (!widget.config.showMobile) return null;
        return _buildTextField(
          context: context,
          controller: _mobileController,
          label: 'Mobile Number',
          hint: 'Enter mobile number',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mobile number is required';
            }
            final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
            if (cleaned.length < 10) {
              return 'Enter a valid 10-digit mobile number';
            }
            return null;
          },
        );
      
      case 'address':
        if (!widget.config.showAddress) return null;
        return _buildTextField(
          context: context,
          controller: _addressController,
          label: 'Address',
          hint: 'Enter address',
          icon: Icons.home_outlined,
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address is required';
            }
            if (value.length < 5) {
              return 'Please enter a valid address';
            }
            return null;
          },
        );
      
      case 'city':
        if (!widget.config.showCity) return null;
        return _buildTextField(
          context: context,
          controller: _cityController,
          label: 'City',
          hint: 'Enter city',
          icon: Icons.location_city_outlined,
        );
      
      case 'postalCode':
        if (!widget.config.showPostalCode) return null;
        return _buildTextField(
          context: context,
          controller: _postalCodeController,
          label: 'Postal Code',
          hint: 'Enter postal code',
          icon: Icons.numbers_outlined,
          keyboardType: TextInputType.number,
        );
      
      case 'country':
        if (!widget.config.showCountry) return null;
        return _buildTextField(
          context: context,
          controller: _countryController,
          label: 'Country',
          hint: 'Enter country',
          icon: Icons.flag_outlined,
        );
      
      default:
        return null;
    }
  }

  Widget _buildGenderDropdown(BuildContext context) {
    final genderOptions = ['Male', 'Female', 'Other'];
    
    return DropdownField<String>(
      value: _selectedGender,
      labelText: 'Gender',
      hintText: 'Select gender',
      items: DropdownItems.fromList(
        items: genderOptions,
        displayText: (item) => item,
      ),
      onChanged: (value) {
        setState(() => _selectedGender = value);
        _onFieldChanged();
      },
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildGenderToggle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
          ),
          child: ToggleButtons(
            constraints: const BoxConstraints.expand(),
            borderRadius: BorderRadius.circular(8),
            selectedColor: Colors.white,
            fillColor: theme.primaryColor,
            selectedBorderColor: theme.primaryColor,
            borderColor: theme.dividerColor.withOpacity(0.3),
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.male_rounded, size: 16),
                    SizedBox(width: 4),
                    Text('Male', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.female_rounded, size: 16),
                    SizedBox(width: 4),
                    Text('Female', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.transgender_rounded, size: 16),
                    SizedBox(width: 4),
                    Text('Other', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
            isSelected: List.from(_genderSelection),
            onPressed: (index) {
              setState(() {
                for (int i = 0; i < _genderSelection.length; i++) {
                  _genderSelection[i] = i == index;
                }
              });
              _onFieldChanged();
            },
          ),
        ),
      ],
    );
  }
}

