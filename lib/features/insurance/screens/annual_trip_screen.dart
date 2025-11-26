import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/insurance_controller.dart';

class AnnualTripScreen extends StatelessWidget {
  final InsuranceController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  AnnualTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(
                icon: Icons.calendar_month,
                text: 'Annual Multi Trip Insurance - Year-round coverage for multiple journeys',
              ),
              const SizedBox(height: 32),
              _buildPlanCategoryField(),
              const SizedBox(height: 16),
              _buildPlanCoverageField(),
              const SizedBox(height: 16),
              _buildPolicyStartDateField(context),
              const SizedBox(height: 24),
              _buildMemberDetailsSection(),
              const SizedBox(height: 32),
              _buildSearchButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCategoryField() {
    return _buildLabeledField(
      label: 'Plan Category',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedCategory.value,
          items: ['Domestic Travel Policy', 'International Travel Policy']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
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
  }

  Widget _buildPlanCoverageField() {
    return _buildLabeledField(
      label: 'Plan Coverage',
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedCoverage.value,
          items: ['WorldWide', 'Asia Only', 'Europe Only']
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
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
  }

  Widget _buildPolicyStartDateField(BuildContext context) {
    return _buildLabeledField(
      label: 'Policy Start Date',
      child: TextFormField(
        controller: controller.departDateController,
        decoration: InputDecoration(
          hintText: 'Select policy start date',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, size: 20),
            onPressed: () => _selectDate(context, controller.departDateController),
          ),
        ),
        readOnly: true,
        onTap: () => _selectDate(context, controller.departDateController),
      ),
    );
  }

  Widget _buildMemberDetailsSection() {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 600;
      double termWidth = isWide ? constraints.maxWidth * 0.4 : constraints.maxWidth;
      double membersWidth = isWide ? constraints.maxWidth * 0.4 : constraints.maxWidth;

      return Wrap(
        spacing: 16,
        runSpacing: 24,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          _buildPolicyTermInfo(termWidth),
          _buildMembersDropdown(membersWidth),
          _buildMemberAgesSection(isWide ? (constraints.maxWidth * 0.4) : constraints.maxWidth),
        ],
      );
    });
  }

  Widget _buildPolicyTermInfo(double width) {
    return SizedBox(
      width: width,
      child: _buildLabeledField(
        label: "Policy Term (Days)",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: "365",
              readOnly: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildHelperText([
              "Annual Policy: Maximum 1 year (365 days)",
              "Policy End Date: 11/11/2026"
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersDropdown(double width) {
    return SizedBox(
      width: width,
      child: _buildLabeledField(
        label: "Insured Members",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => DropdownButtonFormField<String>(
                value: controller.selectedTravelers.value,
                items: ["1", "2", "3", "4"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedTravelers.value = value;
                  }
                },
              ),
            ),
            _buildHelperText([
              "Annual Multi Trip: Min age 1 year | Max age 70 years",
              "Coverage: Multiple trips within policy term"
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberAgesSection(double width) {
    return Builder(
      builder: (context) => SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Member Ages",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Member 1",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextFormField(
                    controller: controller.travelerAgeControllers[0],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            _buildHelperText([
              "Note: Ages must be in full years (minimum 1 year) for annual policies"
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return Builder(
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
  }

  Widget _buildBanner({required IconData icon, required String text}) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  }

  Widget _buildHelperText(List<String> lines) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: lines
              .map((line) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      line,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      final formattedDate =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      controller.text = formattedDate;
    }
  }
}
