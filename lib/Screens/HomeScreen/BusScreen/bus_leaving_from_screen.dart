import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';
import 'package:seemytrip/Screens/Utills/lists_widget.dart';

class Lists {
  // your existing code

  static List<String> busCities = [
    // Add your list of city names here, for example:
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    // ... add more cities as needed
  ];
}

class BusLeavingFromScreen extends StatefulWidget {
  const BusLeavingFromScreen({Key? key}) : super(key: key);

  @override
  State<BusLeavingFromScreen> createState() => _BusLeavingFromScreenState();
}

class _BusLeavingFromScreenState extends State<BusLeavingFromScreen> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = Lists.busCities;
    searchController.addListener(_filterCities);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterCities);
    searchController.dispose();
    super.dispose();
  }

  void _filterCities() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCities = Lists.busCities
          .where((city) => city.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.close, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Leaving From",
          color: white,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: " Search City",
                  prefixIcon: Icon(Icons.search, color: grey888),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredCities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CommonTextWidget.PoppinsMedium(
                      text: filteredCities[index],
                      color: black2E2,
                      fontSize: 16,
                    ),
                    onTap: () {
                      Get.back(result: filteredCities[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}