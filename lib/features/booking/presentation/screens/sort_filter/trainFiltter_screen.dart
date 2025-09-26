import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/features/train/presentation/controllers/train_sort_and_filter_controller.dart';
import 'package:seemytrip/core/theme/app_colors.dart';

class TrainFilterScreen extends StatelessWidget {
  TrainFilterScreen({Key? key}) : super(key: key);

  final TrainSortAndFilterController filterController =
      Get.put(TrainSortAndFilterController());

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('Filter Trains',
                    style: TextStyle(color: Colors.black)),
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollBehavior().copyWith(overscroll: false),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle('Train Class'),
                            _horizontalFilter(
                              filterController,
                              ['1A', '2A', '3A', 'SL'],
                              (index) => filterController
                                  .toggleClass(['1A', '2A', '3A', 'SL'][index]),
                              filterController.selectedClasses,
                            ),
                            Divider(thickness: 1, color: AppColors.greyEEE),
                            // _sectionTitle("Quota"),
                            // _horizontalFilter(
                            //   filterController,
                            //   [ "Tatkal", "Premium Tatkal", "Ladies"],
                            //   (index) {
                            //     filterController.toggleQuota([
                            //       "Tatkal",
                            //       "Premium Tatkal",
                            //       "Ladies"
                            //     ][index]);
                            //   },
                            //   filterController.selectedQuotas,
                            // ),
                            // Divider(thickness: 1, color: greyEEE),
                            _sectionTitle('Departure Time'),
                            _horizontalFilter(
                              filterController,
                              ['earlyMorning', 'morning', 'midDay', 'night'],
                              (index) => filterController.toggleDepartureTime([
                                'earlyMorning',
                                'morning',
                                'midDay',
                                'night'
                              ][index]),
                              filterController.selectedDepartureTimes,
                            ),
                            Divider(thickness: 1, color: AppColors.greyEEE),
                            _sectionTitle('Arrival Time'),
                            _horizontalFilter(
                              filterController,
                              ['earlyMorning', 'morning', 'midDay', 'night'],
                              (index) => filterController.toggleArrivalTime([
                                'earlyMorning',
                                'morning',
                                'midDay',
                                'night'
                              ][index]),
                              filterController.selectedArrivalTimes,
                            ),
                            Divider(thickness: 1, color: AppColors.greyEEE),
                            _sectionTitle('Other Filters'),
                            _switchFilter(
                              'AC Trains',
                              filterController.isACFilterEnabled,
                              filterController.toggleACFilter,
                            ),
                            // _switchFilter(
                            //     "Tatkal",
                            //     filterController.isRefundable,
                            //     filterController.toggleRefundable),
                            SizedBox(height: 20),
                            _applyResetButtons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )));

  Widget _sectionTitle(String title) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 18, color: AppColors.grey717, fontWeight: FontWeight.bold),
      ),
    );

  Widget _horizontalFilter(
    TrainSortAndFilterController controller,
    List<String> options,
    Function(int) onTap,
    RxList<String> selectedOptions,
  ) => SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () => onTap(index),
            child: Obx(() => Container(
                  margin: EdgeInsets.only(right: 12),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: selectedOptions.contains(options[index])
                        ? AppColors.redCA0
                        : AppColors.white,
                    border: Border.all(
                      color: selectedOptions.contains(options[index])
                          ? AppColors.redCA0
                          : AppColors.grey717,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedOptions.contains(options[index])
                          ? AppColors.white
                          : AppColors.grey717,
                    ),
                  ),
                )),
          ),
      ),
    );

  Widget _switchFilter(String title, RxBool value, Function() onChanged) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, color: AppColors.grey717),
          ),
          Obx(() => Switch(
                value: value.value,
                onChanged: (val) => onChanged(),
                activeColor: AppColors.redCA0,
              )),
        ],
      ),
    );

  Widget _applyResetButtons() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () {
              filterController.resetFilters();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.greyEEE,
              padding: EdgeInsets.symmetric(horizontal: 34, vertical: 12),
            ),
            child: Text(
              'Reset',
              style: TextStyle(color: AppColors.black2E2),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              filterController.applyFilters([]);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.redCA0,
              padding: EdgeInsets.symmetric(horizontal: 34, vertical: 12),
            ),
            child: Text(
              'Apply',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
}
