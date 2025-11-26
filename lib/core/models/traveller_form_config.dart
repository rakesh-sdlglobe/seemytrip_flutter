/// Enum to represent different travel types
enum TravelType {
  train,
  bus,
  hotel,
  flight,
}

/// Represents a form section with a title and fields
class FormSection {
  final String? title;
  final String? subtitle;
  final List<String> fieldOrder; // Order of fields in this section
  final bool showDivider;

  const FormSection({
    this.title,
    this.subtitle,
    required this.fieldOrder,
    this.showDivider = true,
  });
}

/// Configuration for traveller form fields
class TravellerFormConfig {
  final TravelType travelType;
  final bool showName;
  final bool showFirstName; // For flights
  final bool showLastName; // For flights
  final bool showAge;
  final bool showGender;
  final bool showMobile;
  final bool showEmail;
  final bool showAddress;
  final bool showCity;
  final bool showPostalCode;
  final bool showCountry;
  final bool showBerthPreference; // Train specific
  final bool showFoodPreference; // Train specific
  final bool showIdProof; // Bus specific
  final bool showIdNumber; // Bus specific
  final bool showSeatNumber; // Bus specific (display only)
  final String? seatNumber; // Bus specific value
  final bool showTitle; // Hotel specific - Title dropdown (Mr, Mrs, Miss, Master)
  final bool showMiddleName; // Hotel specific - Middle name (optional)
  final bool showMobilePrefix; // Hotel specific - Mobile prefix dropdown (+91, etc.)
  final bool showRoomId; // Hotel specific - Room ID
  final bool showLeadPax; // Hotel specific - Lead passenger checkbox
  final bool showPaxType; // Hotel specific - Passenger type (A=Adult, C=Child)
  final bool showDob; // Hotel specific - Date of birth (for children)
  final List<String>? berthOptions;
  final List<String>? foodOptions;
  final List<String>? idProofTypes;
  final List<String>? titleOptions; // Hotel specific - Title options
  final List<String>? mobilePrefixOptions; // Hotel specific - Mobile prefix options
  final String? title;
  final String? subtitle;
  final List<FormSection>? sections; // Optional: define custom sections
  final bool useSections; // Whether to use section-based layout

  const TravellerFormConfig({
    required this.travelType,
    this.showName = true,
    this.showFirstName = false,
    this.showLastName = false,
    this.showAge = true,
    this.showGender = true,
    this.showMobile = false,
    this.showEmail = false,
    this.showAddress = false,
    this.showCity = false,
    this.showPostalCode = false,
    this.showCountry = false,
    this.showBerthPreference = false,
    this.showFoodPreference = false,
    this.showIdProof = false,
    this.showIdNumber = false,
    this.showSeatNumber = false,
    this.seatNumber,
    this.showTitle = false,
    this.showMiddleName = false,
    this.showMobilePrefix = false,
    this.showRoomId = false,
    this.showLeadPax = false,
    this.showPaxType = false,
    this.showDob = false,
    this.berthOptions,
    this.foodOptions,
    this.idProofTypes,
    this.titleOptions,
    this.mobilePrefixOptions,
    this.title,
    this.subtitle,
    this.sections,
    this.useSections = false,
  });

  /// Factory constructor for Train configuration
  factory TravellerFormConfig.train({
    String? title,
    String? subtitle,
    List<String>? berthOptions,
    List<String>? foodOptions,
  }) {
    return TravellerFormConfig(
      travelType: TravelType.train,
      showName: true,
      showAge: true,
      showGender: true,
      showMobile: true,
      showBerthPreference: true,
      showFoodPreference: true,
      berthOptions: berthOptions ?? [
        'Lower Berth',
        'Middle Berth',
        'Upper Berth',
        'Side Lower',
        'Side Upper',
        'No Preference'
      ],
      foodOptions: foodOptions ?? ['Veg', 'Non-Veg'],
      title: title ?? 'Add New Traveller',
      subtitle: subtitle,
      useSections: false, // Simple linear layout for train
    );
  }

  /// Factory constructor for Bus configuration
  factory TravellerFormConfig.bus({
    String? title,
    String? subtitle,
    String? seatNumber,
    List<String>? idProofTypes,
  }) {
    return TravellerFormConfig(
      travelType: TravelType.bus,
      showName: true,
      showAge: true,
      showGender: true,
      showMobile: true, // Required for bus booking
      showEmail: true, // Required for bus booking
      showAddress: true, // Required for bus booking
      showIdProof: false, // ID proof removed from bus booking
      showIdNumber: false, // ID proof removed from bus booking
      showSeatNumber: seatNumber != null,
      seatNumber: seatNumber,
      idProofTypes: idProofTypes ?? [
        'Aadhaar',
        'Passport',
        'Driving License',
        'Voter ID',
        'PAN Card'
      ],
      title: title,
      subtitle: subtitle,
      useSections: false, // Simple layout for bus
    );
  }

  /// Factory constructor for Hotel configuration
  factory TravellerFormConfig.hotel({
    String? title,
    String? subtitle,
    bool isAdult = true, // true for adults, false for children
    bool showFullForm = true, // Show all fields including title, prefix, etc.
  }) {
    return TravellerFormConfig(
      travelType: TravelType.hotel,
      showName: !showFullForm, // Use full name only if not showing full form
      showFirstName: showFullForm, // Show first name for full form
      showLastName: showFullForm, // Show last name for full form
      showMiddleName: showFullForm && isAdult, // Middle name only for adults
      showAge: !isAdult, // Age only for children
      showDob: !isAdult, // DOB only for children
      showGender: false, // Hotels don't need gender
      showEmail: true,
      showMobile: true,
      showMobilePrefix: showFullForm, // Mobile prefix for full form
      showAddress: true,
      showCity: true,
      showPostalCode: true,
      showCountry: true,
      showTitle: showFullForm, // Title dropdown for full form
      showRoomId: showFullForm, // Room ID for full form
      showLeadPax: showFullForm && isAdult, // Lead pax only for adults
      showPaxType: showFullForm, // Pax type for full form
      titleOptions: isAdult 
          ? ['Mr', 'Mrs', 'Ms', 'Dr'] 
          : ['Master', 'Miss'], // Different titles for adults vs children
      mobilePrefixOptions: ['+91', '+1', '+44', '+61', '+971'], // Common prefixes
      title: title ?? (isAdult ? 'Adult Passenger Details' : 'Child Passenger Details'),
      subtitle: subtitle,
      useSections: !showFullForm, // Use sections only for simplified form
      sections: showFullForm ? null : [
        // Contact Details Section (for simplified form)
        const FormSection(
          title: 'Contact Details',
          subtitle: 'Required for booking confirmation',
          fieldOrder: ['name', 'email', 'mobile'],
          showDivider: true,
        ),
        // Billing Address Section
        const FormSection(
          title: 'Billing Address',
          subtitle: 'Optional',
          fieldOrder: ['address', 'city', 'postalCode', 'country'],
          showDivider: false,
        ),
      ],
    );
  }

  /// Factory constructor for Flight configuration
  factory TravellerFormConfig.flight({
    String? title,
    String? subtitle,
  }) {
    return TravellerFormConfig(
      travelType: TravelType.flight,
      showFirstName: true,
      showLastName: true,
      showGender: true,
      title: title ?? 'Add Traveller',
      subtitle: subtitle,
      useSections: false, // Simple layout for flight
    );
  }
}

