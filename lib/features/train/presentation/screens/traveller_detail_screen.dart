import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/travellerDetailController.dart';
import '../../../../core/widgets/common/traveller_form_widget.dart';
import '../../../../core/models/traveller_form_config.dart';

class TravellerDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? traveller;
  final TravelType? travelType; // Add travel type parameter
  
  const TravellerDetailScreen({Key? key, this.traveller, this.travelType}) : super(key: key);

  @override
  State<TravellerDetailScreen> createState() => _TravellerDetailScreenState();
}

class _TravellerDetailScreenState extends State<TravellerDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _widgetKey = GlobalKey<TravellerFormWidgetState>();
  final TravellerDetailController _travellerController = Get.put(TravellerDetailController());

  bool _isExpanded = false;
  bool _isEditMode = false;
  
  // Configuration for traveller form
  late final TravellerFormConfig _formConfig;

  @override
  void initState() {
    super.initState();
    
    _isEditMode = widget.traveller != null;
    
    // Initialize form configuration based on travel type
    final travelType = widget.travelType ?? TravelType.train;
    
    if (travelType == TravelType.bus) {
      _formConfig = TravellerFormConfig.bus(
        title: _isEditMode ? 'Edit Traveller' : 'Add New Traveller',
      );
    } else if (travelType == TravelType.flight) {
      _formConfig = TravellerFormConfig.flight(
        title: _isEditMode ? 'Edit Traveller' : 'Add New Traveller',
      );
    } else if (travelType == TravelType.hotel) {
      _formConfig = TravellerFormConfig.hotel(
        title: _isEditMode ? 'Edit Traveller' : 'Add New Traveller',
      );
    } else {
      // Default to train
      _formConfig = TravellerFormConfig.train(
        title: _isEditMode ? 'Edit Traveller' : 'Add New Traveller',
        berthOptions: [
          'Lower Berth',
          'Middle Berth',
          'Upper Berth',
          'Side Lower',
          'Side Upper',
          'No Preference'
        ],
        foodOptions: ['Veg', 'Non-Veg'],
      );
    }
    
    // Only fetch travelers if not in edit mode
    if (!_isEditMode) {
      _travellerController.fetchTravelers();
    } else {
      // If editing, expand the form
      _isExpanded = true;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    
    final formData = _widgetKey.currentState?.getFormData();
    if (formData == null) return;
    
    try {
      final travelType = widget.travelType ?? TravelType.train;
      
      // Check if we're in edit mode
      if (_isEditMode && widget.traveller != null) {
        // Get passenger ID from traveller data
        final passengerId = (widget.traveller!['id'] ?? 
                            widget.traveller!['passengerId'] ?? 
                            '').toString();
        
        if (passengerId.isEmpty) {
          Get.snackbar(
            'Error',
            'Cannot edit: Passenger ID is missing',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }
        
        // Edit traveller using PUT request
        if (travelType == TravelType.bus) {
          await _travellerController.editTraveller(
            passengerId: passengerId,
            name: formData['name'] ?? formData['passengerName'] ?? '',
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            email: formData['email'] ?? '',
            address: formData['address'] ?? '',
          );
        } else if (travelType == TravelType.flight) {
          final firstName = formData['firstName'] ?? formData['firstAndMiddleName'] ?? '';
          final lastName = formData['lastName'] ?? '';
          await _travellerController.editTraveller(
            passengerId: passengerId,
            name: '$firstName $lastName'.trim(),
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
          );
        } else if (travelType == TravelType.hotel) {
          await _travellerController.editTraveller(
            passengerId: passengerId,
            name: formData['name'] ?? formData['passengerName'] ?? '',
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            email: formData['email'] ?? '',
            address: formData['address'] ?? '',
          );
        } else {
          // Train
          await _travellerController.editTraveller(
            passengerId: passengerId,
            name: formData['name'] ?? formData['passengerName'] ?? '',
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            berthPreference: formData['passengerBerthChoice'] == 'NP' 
                ? 'No Preference' 
                : _getBerthNameFromCode(formData['passengerBerthChoice']),
            foodPreference: formData['passengerFoodChoice'] ?? 'Veg',
          );
        }
      } else {
        // Add new traveller using POST request
        if (travelType == TravelType.bus) {
          // Bus requires: name, age, gender, mobile, email, address
          await _travellerController.saveTravellerDetails(
            name: formData['name'] ?? formData['passengerName'] ?? '',
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            email: formData['email'] ?? '',
            address: formData['address'] ?? '',
          );
        } else if (travelType == TravelType.flight) {
          // Flight requires: firstName, lastName, gender
          final firstName = formData['firstName'] ?? formData['firstAndMiddleName'] ?? '';
          final lastName = formData['lastName'] ?? '';
          await _travellerController.saveTravellerDetails(
            name: '$firstName $lastName'.trim(),
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
          );
        } else if (travelType == TravelType.hotel) {
          // Hotel requires: title, firstName, lastName, email, mobile, roomId, leadPax, paxType
          final firstName = formData['firstName'] ?? '';
          final middleName = formData['middleName'] ?? '';
          final lastName = formData['lastName'] ?? '';
          final fullName = formData['name'] ?? formData['passengerName'] ?? '';
          
          // Build name: if firstName/lastName exist, use them; otherwise use fullName
          final name = (firstName.isNotEmpty || lastName.isNotEmpty)
              ? [firstName, middleName, lastName].where((n) => n.isNotEmpty).join(' ').trim()
              : fullName;
          
          await _travellerController.saveTravellerDetails(
            name: name,
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            email: formData['email'] ?? formData['contact_email'] ?? '',
            address: formData['address'] ?? '',
            // Hotel-specific fields
            title: formData['title'],
            firstName: firstName.isNotEmpty ? firstName : null,
            middleName: middleName.isNotEmpty ? middleName : null,
            lastName: lastName.isNotEmpty ? lastName : null,
            mobilePrefix: formData['mobilePrefix'] ?? formData['mobile_prefix'],
            roomId: formData['roomId'] ?? formData['room_id'],
            leadPax: formData['leadPax'] ?? formData['lead_pax'],
            paxType: formData['paxType'] ?? formData['pax_type'],
            dob: formData['dob'] ?? formData['dateOfBirth'],
          );
        } else {
          // Train requires: name, age, gender, mobile, berth, food
          await _travellerController.saveTravellerDetails(
            name: formData['name'] ?? formData['passengerName'] ?? '',
            age: formData['age']?.toString() ?? '',
            gender: formData['gender'] ?? formData['passengerGender'],
            mobile: formData['mobile'] ?? formData['passengerMobileNumber'] ?? '',
            berthPreference: formData['passengerBerthChoice'] == 'NP' 
                ? 'No Preference' 
                : _getBerthNameFromCode(formData['passengerBerthChoice']),
            foodPreference: formData['passengerFoodChoice'] ?? 'Veg',
          );
        }
        
        // Show success message and reset form for new traveller
        if (mounted) {
          Get.snackbar(
            'Success',
            'Traveller saved successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          
          _formKey.currentState?.reset();
          setState(() => _isExpanded = false);
          
          // Refresh travellers list
          _travellerController.fetchTravelers();
        }
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to ${_isEditMode ? 'update' : 'save'} traveler: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
  
  String _getBerthNameFromCode(String? code) {
    if (code == null) return 'No Preference';
    final berthMap = {
      'LB': 'Lower Berth',
      'MB': 'Middle Berth',
      'UB': 'Upper Berth',
      'SL': 'Side Lower',
      'SU': 'Side Upper',
    };
    return berthMap[code] ?? 'No Preference';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Traveller Details'),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isEditMode
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Edit Traveller Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _formConfig.title ?? 'Edit Traveller',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TravellerFormWidget(
                            config: _formConfig,
                            formKey: _formKey,
                            widgetKey: _widgetKey,
                            initialData: widget.traveller,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleSave,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Obx(() => _travellerController.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Update Traveller',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                    )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Add New Traveller Card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: ExpansionTile(
                    title: Text(
                      _formConfig.title ?? 'Add New Traveller',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    initiallyExpanded: _isExpanded,
                    onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TravellerFormWidget(
                          config: _formConfig,
                          formKey: _formKey,
                          widgetKey: _widgetKey,
                          initialData: widget.traveller,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handleSave,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Obx(() => _travellerController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Text(
                                    'Save Traveller',
                                    style: GoogleFonts.poppins(fontSize: 16),
                                  )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          
          // Saved Travellers List (only show if not in edit mode)
          if (!_isEditMode) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    'Saved Travellers',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() => Text(
                    '(${_travellerController.travellers.length})',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  )),
                ],
              ),
            ),
            
            // Travellers List
            Expanded(
              child: Obx(() {
                if (_travellerController.isLoading.value && _travellerController.travellers.isEmpty) {
                  return _buildShimmerLoading();
                }
                
                if (_travellerController.travellers.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => _travellerController.fetchTravelers(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No travelers added yet',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pull down to refresh',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () => _travellerController.fetchTravelers(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _travellerController.travellers.length,
                    itemBuilder: (context, index) {
                      final traveler = _travellerController.travellers[index];
                      return _buildTravelerCard(traveler, theme);
                    },
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildShimmerLoading() => ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 3,
      itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 14,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  
  Widget _buildTravelerCard(Map<String, dynamic> traveler, ThemeData theme) => Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          traveler['passengerName'] ?? traveler['firstname'] ?? 'No Name',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Age: ${traveler['passengerAge'] ?? traveler['age'] ?? 'N/A'}, ${traveler['passengerGender'] ?? 'N/A'}',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            if (traveler['passengerMobileNumber'] != null && 
                traveler['passengerMobileNumber'].toString().isNotEmpty &&
                traveler['passengerMobileNumber'] != '0000000000')
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Mobile: ${traveler['passengerMobileNumber']}',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            if (traveler['contact_email'] != null && traveler['contact_email'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Email: ${traveler['contact_email']}',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            if (traveler['address'] != null && traveler['address'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Address: ${traveler['address']}',
                  style: GoogleFonts.poppins(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (traveler['passengerBerthChoice'] != null && traveler['passengerBerthChoice'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Berth: ${traveler['passengerBerthChoice']}',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            if (traveler['passengerFoodChoice'] != null && traveler['passengerFoodChoice'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  'Food: ${traveler['passengerFoodChoice']}',
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () {
                final travelType = widget.travelType ?? TravelType.train;
                Get.to(() => TravellerDetailScreen(
                  traveller: traveler,
                  travelType: travelType,
                ))?.then((_) {
                  _travellerController.fetchTravelers();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete Traveler',
                  middleText: 'Are you sure you want to delete ${traveler['passengerName'] ?? traveler['firstname'] ?? 'this traveler'}? This action cannot be undone.',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () async {
                    Get.back();
                    final travellerId = traveler['id'] ?? traveler['passengerId'];
                    await _travellerController.deleteTraveler(travellerId);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
}