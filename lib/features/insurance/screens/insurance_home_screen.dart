import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/insurance_controller.dart';
import 'single_trip_screen.dart';
import 'annual_trip_screen.dart';

class InsuranceHomePage extends StatefulWidget {
  const InsuranceHomePage({super.key});

  @override
  State<InsuranceHomePage> createState() => _InsuranceHomePageState();
}

class _InsuranceHomePageState extends State<InsuranceHomePage>
    with SingleTickerProviderStateMixin {
  final InsuranceController controller = Get.put(InsuranceController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Insurance'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.iconTheme?.color ?? Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.appBarTheme.iconTheme?.color ?? Colors.white,
          unselectedLabelColor: (theme.appBarTheme.iconTheme?.color ?? Colors.white).withOpacity(0.7),
          indicatorColor: theme.appBarTheme.iconTheme?.color ?? Colors.white,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.rocket_launch, size: 20),
              text: 'Single Trip',
            ),
            Tab(
              icon: Icon(Icons.calendar_month, size: 20),
              text: 'Annual Multi Trip',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Single Trip Tab
          SingleTripScreen(),

          // Annual Multi Trip Tab
          AnnualTripScreen(),
        ],
      ),
    );
  }
}
