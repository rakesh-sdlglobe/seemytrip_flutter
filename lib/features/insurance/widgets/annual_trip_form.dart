import 'package:flutter/material.dart';

class AnnualTripForm extends StatefulWidget {
  final String? selectedCategory;
  final String? selectedCoverage;
  final String? selectedMembers;
  final TextEditingController policyStartDateController;
  final TextEditingController member1AgeController;
  final Function(String?) onCategoryChanged;
  final Function(String?) onCoverageChanged;
  final Function(String?) onMembersChanged;

  const AnnualTripForm({
    super.key,
    required this.selectedCategory,
    required this.selectedCoverage,
    required this.selectedMembers,
    required this.policyStartDateController,
    required this.member1AgeController,
    required this.onCategoryChanged,
    required this.onCoverageChanged,
    required this.onMembersChanged,
  });

  @override
  State<AnnualTripForm> createState() => _AnnualTripFormState();
}

class _AnnualTripFormState extends State<AnnualTripForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBanner(
          icon: Icons.calendar_month,
          text: "Annual Multi Trip Insurance - Year-round coverage for multiple journeys",
        ),
        const SizedBox(height: 32),
        LayoutBuilder(builder: (context, constraints) {
          bool isWide = constraints.maxWidth > 700;
          double itemWidth = isWide ? (constraints.maxWidth - 32) / 3 : constraints.maxWidth;

          return Wrap(
            spacing: 16,
            runSpacing: 24,
            children: [
              _buildPlanCategoryDropdown(itemWidth),
              _buildPlanCoverageDropdown(itemWidth),
              _buildPolicyStartDateField(itemWidth),
            ],
          );
        }),
        const SizedBox(height: 24),
        _buildMemberDetailsSection(),
      ],
    );
  }

  Widget _buildPlanCategoryDropdown(double width) {
    return SizedBox(
      width: width,
      child: _buildLabeledField(
        label: "Plan Category",
        child: DropdownButtonFormField<String>(
          value: widget.selectedCategory,
          items: ["Domestic Travel Policy", "International Travel Policy"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: widget.onCategoryChanged,
        ),
      ),
    );
  }

  Widget _buildPlanCoverageDropdown(double width) {
    return SizedBox(
      width: width,
      child: _buildLabeledField(
        label: "Plan Coverage",
        child: DropdownButtonFormField<String>(
          value: widget.selectedCoverage,
          items: ["WorldWide", "Asia Only", "Europe Only"]
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: widget.onCoverageChanged,
        ),
      ),
    );
  }

  Widget _buildPolicyStartDateField(double width) {
    return SizedBox(
      width: width,
      child: _buildLabeledField(
        label: "Policy Start Date",
        child: TextFormField(
          controller: widget.policyStartDateController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey),
          ),
          readOnly: true,
          onTap: () => _selectPolicyStartDate(context),
        ),
      ),
    );
  }

  Widget _buildMemberDetailsSection() {
    return LayoutBuilder(builder: (context, constraints) {
      bool isWide = constraints.maxWidth > 600;
      double termWidth = isWide ? constraints.maxWidth * 0.25 : constraints.maxWidth;
      double membersWidth = isWide ? constraints.maxWidth * 0.25 : constraints.maxWidth;

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
              style: TextStyle(fontWeight: FontWeight.bold),
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
            DropdownButtonFormField<String>(
              value: widget.selectedMembers,
              items: ["1", "2", "3", "4"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: widget.onMembersChanged,
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
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Member Ages",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF0A1E40),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Member 1",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 80,
                child: TextFormField(
                  controller: widget.member1AgeController,
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
    );
  }

  Widget _buildBanner({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0A1E40),
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  Widget _buildHelperText(List<String> lines) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map((line) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    line,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _selectPolicyStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        widget.policyStartDateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }
}
