import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insurance_controller.dart';

class SingleTripScreen extends StatelessWidget {
  final InsuranceController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SingleTripScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildBanner(
                icon: Icons.rocket_launch,
                text: 'Single Trip Insurance - One-time coverage for your journey',
              ),
              const SizedBox(height: 32),
              _buildPlanCategoryField(),
              const SizedBox(height: 16),
              _buildPlanCoverageField(),
              const SizedBox(height: 16),
              _buildDepartureDateField(context),
              const SizedBox(height: 16),
              _buildReturnDateField(context),
              const SizedBox(height: 16),
              _buildTravelersField(),
              const SizedBox(height: 16),
              _buildTripDurationField(),
              const SizedBox(height: 32),
              _buildSearchButton(),
            ],
          ),
        ),
      ),
    );

  Widget _buildPlanCategoryField() => _buildLabeledField(
      label: 'Plan Category',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedCategory.value,
          items: <String>['Domestic Travel Policy', 'International Travel Policy']
              .map((String e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.selectedCategory.value = value;
            }
          },
          decoration: const InputDecoration(
            hintText: 'Select plan category',
          ),
        ),
      ),
    );

  Widget _buildPlanCoverageField() => _buildLabeledField(
      label: 'Plan Coverage',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedCoverage.value,
          items: <String>['WorldWide', 'Asia Only', 'Europe Only']
              .map((String e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.selectedCoverage.value = value;
            }
          },
          decoration: const InputDecoration(
            hintText: 'Select plan coverage',
          ),
        ),
      ),
    );

  Widget _buildDepartureDateField(BuildContext context) => _buildLabeledField(
      label: 'Departure Date',
      child: TextFormField(
        controller: controller.departDateController,
        decoration: InputDecoration(
          hintText: 'Select departure date',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, size: 20),
            onPressed: () => _selectDate(context, controller.departDateController),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context, controller.departDateController),
      ),
    );

  Widget _buildReturnDateField(BuildContext context) => _buildLabeledField(
      label: 'Return Date',
      child: TextFormField(
        controller: controller.returnDateController,
        decoration: InputDecoration(
          hintText: 'Select return date',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, size: 20),
            onPressed: () => _selectReturnDate(context),
          ),
        ),
        readOnly: true,
        onTap: () => _selectReturnDate(context),
      ),
    );

  Widget _buildTravelersField() => _buildLabeledField(
      label: 'Number of Travelers',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedTravelers.value,
          items: <String>['1', '2', '3', '4', '5+']
              .map((String e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (String? value) {
            if (value != null) {
              controller.selectedTravelers.value = value;
            }
          },
          decoration: const InputDecoration(
            hintText: 'Select number of travelers',
          ),
        ),
      ),
    );

  Widget _buildTripDurationField() => _buildLabeledField(
      label: 'Trip Duration (Days)',
      child: TextFormField(
        controller: controller.tripDurationController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter trip duration in days',
        ),
        onChanged: (String value) {
          controller.updateTripDuration();
        },
      ),
    );

  Widget _buildSearchButton() => Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () {
            // Handle search
          },
          child: const Text(
            'SEARCH INSURANCE PLANS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );

  Widget _buildBanner({required IconData icon, required String text}) => Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Widget _buildLabeledField({required String label, required Widget child}) => Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      final String formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      controller.text = formattedDate;
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? firstDate = controller.departDateController.text.isNotEmpty
        ? controller.parseDate(controller.departDateController.text)
        : null;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      final String formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      controller.returnDateController.text = formattedDate;
    }
  }
}
