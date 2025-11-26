import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsuranceController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Tab Controller - will be initialized in the widget
  late final TabController tabController;
  
  // Form Controllers
  final TextEditingController departDateController = TextEditingController(text: '10/11/2025');
  final TextEditingController returnDateController = TextEditingController(text: '11/11/2025');
  final List<TextEditingController> travelerAgeControllers = [
    TextEditingController(text: '25')
  ];
  final TextEditingController tripDurationController = TextEditingController(text: '2');
  
  // Dropdown values
  final RxString selectedCategory = 'Domestic Travel Policy'.obs;
  final RxString selectedCoverage = 'WorldWide'.obs;
  final RxString selectedTravelers = '1'.obs;
  
  // Options
  final List<String> categories = [
    'Domestic Travel Policy',
    'International Travel Policy'
  ];
  
  final List<String> coverages = [
    'WorldWide',
    'Asia Only', 
    'Europe Only'
  ];
  
  final List<String> travelerOptions = ['1', '2', '3', '4', '5+'];
  
  @override
  void onInit() {
    super.onInit();
    
    // Listen to changes in number of travelers
    ever(selectedTravelers, _handleTravelerCountChange);
    
    // Calculate initial trip duration
    updateTripDuration();
  }
  
  // Parse date string in format dd/MM/yyyy to DateTime
  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return null;
  }
  
  // Initialize tab controller with external TickerProvider
  void initTabController(TickerProvider vsync) {
    tabController = TabController(length: 2, vsync: vsync);
  }
  
  void _handleTravelerCountChange(String count) {
    final int numTravelers = count == '5+' ? 5 : int.parse(count);
    
    // Add or remove age controllers based on selection
    if (numTravelers > travelerAgeControllers.length) {
      // Add new controllers
      for (int i = travelerAgeControllers.length; i < numTravelers; i++) {
        travelerAgeControllers.add(TextEditingController(text: '25'));
      }
    } else if (numTravelers < travelerAgeControllers.length) {
      // Remove extra controllers
      travelerAgeControllers.removeRange(
        numTravelers, 
        travelerAgeControllers.length
      );
    }
    update(); // Notify listeners
  }
  
  // Handle date picker
  Future<void> selectDate(
    BuildContext context, 
    TextEditingController controller, {
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty 
          ? _parseDate(controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2100),
    );
    
    if (picked != null) {
      controller.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      
      // If this is the departure date and return date is before it, update return date
      if (controller == departDateController) {
        final departDate = _parseDate(departDateController.text);
        final returnDate = _parseDate(returnDateController.text);
        
        if (departDate != null && (returnDate == null || returnDate.isBefore(departDate))) {
          final newReturnDate = departDate.add(const Duration(days: 1));
          returnDateController.text = "${newReturnDate.day.toString().padLeft(2, '0')}/${newReturnDate.month.toString().padLeft(2, '0')}/${newReturnDate.year}";
        }
      }
      
      updateTripDuration();
      update();
    }
  }
  
  // Helper method to parse date from string
  DateTime? parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return null;
    }
  }
  
  // Update trip duration based on dates
  void updateTripDuration() {
    final duration = tripDurationInDays;
    if (duration > 0) {
      tripDurationController.text = duration.toString();
    }
  }
  
  // Calculate trip duration in days
  int get tripDurationInDays {
    try {
      final departDate = _parseDate(departDateController.text);
      final returnDate = _parseDate(returnDateController.text);
      
      if (departDate == null || returnDate == null) return 0;
      if (returnDate.isBefore(departDate)) return 0;
      
      return returnDate.difference(departDate).inDays + 1;
    } catch (e) {
      return 0;
    }
  }
  
  // Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }
  
  // Submit form
  void submitForm() {
    if (!validateForm()) return;
    
    // Process form submission here
    // You can add your API calls or business logic
    
    Get.snackbar(
      'Success',
      'Insurance request submitted successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
  
  @override
  void onClose() {
    tabController.dispose();
    departDateController.dispose();
    returnDateController.dispose();
    for (var controller in travelerAgeControllers) {
      controller.dispose();
    }
    tripDurationController.dispose();
    super.onClose();
  }
}
