import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Constants/images.dart';
import 'package:makeyourtripapp/Controller/train_and_bus_detail_controller.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_modify_search_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_search_screen2.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/view_train_routes_screen.dart';
import 'package:makeyourtripapp/Screens/SortAndFilterScreen/trainFiltter_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/lists_widget.dart';
import 'package:makeyourtripapp/main.dart';

import '../../../Controller/train_sort_and_filter_controller.dart';

class TrainAndBusDetailScreen extends StatefulWidget {
  final List<dynamic> trains;
  final DateTime selectedDate;
  final String fromStation;
  final String toStation;

  TrainAndBusDetailScreen({
    Key? key,
    required this.trains,
    required this.selectedDate,
    required this.fromStation,
    required this.toStation,
  }) : super(key: key);

  @override
  State<TrainAndBusDetailScreen> createState() =>
      _TrainAndBusDetailScreenState();
}

class _TrainAndBusDetailScreenState extends State<TrainAndBusDetailScreen> {
  final TrainSortAndFilterController filterController =
      Get.put(TrainSortAndFilterController());

  late List<dynamic> filteredTrains;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      filteredTrains = filterController.applyFilters(widget.trains);
    });
  }

  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat("HH:mm");
    final DateFormat outputFormat = DateFormat("hh:mm a");
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  Map<String, String> calculateArrival(
      Map<String, dynamic> train, DateTime selectedDate) {
    final DateFormat format = DateFormat("HH:mm");
    final DateTime departure = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      int.parse(train['departureTime'].split(':')[0]),
      int.parse(train['departureTime'].split(':')[1]),
    );
    final List<String> durationParts = train['duration'].split(':');
    final int durationHours = int.parse(durationParts[0]);
    final int durationMinutes = int.parse(durationParts[1]);

    DateTime arrival = departure.add(
      Duration(hours: durationHours, minutes: durationMinutes),
    );

    final DateFormat outputFormat = DateFormat("dd MMM, EE");
    final String formattedArrivalDate = outputFormat.format(arrival);
    final String formattedArrivalTime = formatTime(format.format(arrival));

    return {
      'formattedArrivalDate': formattedArrivalDate,
      'formattedArrivalTime': formattedArrivalTime,
    };
  }

  // Function to show full-screen bottom sheet
  void showTrainFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TrainFilterScreen(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ).then((_) {
      // Refresh the UI after the bottom sheet is closed
      Get.forceAppUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TrainAndBusDetailController controller =
        Get.put(TrainAndBusDetailController());
    controller.setInitialSelectedIndex(widget.selectedDate);

    return Scaffold(
      backgroundColor: redF9E,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              _buildDateSelector(controller),
              SizedBox(height: 15),
              _buildTrainList(),
              SizedBox(height: 100),
            ],
          ),
          _buildBottomFilterBar(context),
          if (isLoading)
            Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(redCA0),
                strokeWidth: 3.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 145,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(busAndTrainImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 60, bottom: 10),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            horizontalTitleGap: -5,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back, color: grey888, size: 20),
            ),
            title: CommonTextWidget.PoppinsRegular(
              text: "${widget.fromStation} To ${widget.toStation}",
              color: black2E2,
              fontSize: 15,
            ),
            subtitle: CommonTextWidget.PoppinsRegular(
              text: DateFormat('dd MMM, EEEE').format(widget.selectedDate),
              color: grey717,
              fontSize: 12,
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => TrainAndBusModifySearchScreen(
                      startStation: widget.trains.isNotEmpty
                          ? widget.trains[0]['fromStnCode']
                          : 'N/A',
                      endStation: widget.trains.isNotEmpty
                          ? widget.trains[0]['toStnCode']
                          : 'N/A',
                      selectedDate: widget.selectedDate,
                    ));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(draw),
                  SizedBox(height: 10),
                  CommonTextWidget.PoppinsMedium(
                    text: "Edit",
                    color: redCA0,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(TrainAndBusDetailController controller) {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: redCA0,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: CommonTextWidget.PoppinsMedium(
                      text: DateFormat('MMM').format(widget.selectedDate),
                      color: white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                width: Get.width,
                child: GetBuilder<TrainAndBusDetailController>(
                  init: TrainAndBusDetailController(),
                  builder: (controller) => ListView.builder(
                    controller: ScrollController(
                      initialScrollOffset:
                          controller.selectedIndex.value * 60.0,
                    ),
                    itemCount: TrainAndBusDetailController
                        .trainAndBusDetailList1.length,
                    padding: EdgeInsets.only(left: 6),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final date =
                          widget.selectedDate.add(Duration(days: index));
                      return Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                controller.onIndexChange(index);
                                controller.setSelectedDate(date);
                                isLoading = true; // Start loading
                              });

                              // Fetch data
                              await controller.getTrains(
                                widget.trains[0]['fromStnCode'],
                                widget.trains[0]['toStnCode'],
                                DateFormat('yyyy-MM-dd').format(date),
                              );

                              setState(() {
                                filteredTrains = filterController
                                    .applyFilters(controller.trains);
                                isLoading = false; // Stop loading
                              });

                              Get.forceAppUpdate(); // Restart the page
                            },
                            child: Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  color: controller.selectedIndex.value == index
                                      ? redCA0
                                      : white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color:
                                        controller.selectedIndex.value == index
                                            ? redCA0
                                            : greyE2E,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Center(
                                    child: CommonTextWidget.PoppinsMedium(
                                      text: DateFormat('dd MMM, EEE')
                                          .format(date),
                                      color: controller.selectedIndex.value ==
                                              index
                                          ? white
                                          : grey717,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainList() {
    // final filteredTrains = filterController.applyFilters(widget.trains);
    filteredTrains.removeWhere((train) {
      return train['availabilities'].isEmpty ||
          train['availabilities'].every((seat) {
            return seat['totalFare'] == null;
          });
    });
    return (filteredTrains.isNotEmpty)
        ? Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: GetBuilder<TrainSortAndFilterController>(
                init: TrainSortAndFilterController(),
                builder: (controller) {
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: filteredTrains.length,
                    itemBuilder: (context, index) {
                      final train = filteredTrains[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Container(
                          width: Get.width,
                          color: white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 15),
                            child: Column(
                              children: [
                                _buildTrainHeader(train),
                                SizedBox(height: 20),
                                _buildTrainTimings(train),
                                SizedBox(height: 20),
                                _buildTrainDistance(train),
                                SizedBox(height: 20),
                                _buildSeatAvailability(context, train),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        : Column(
            children: [
              SizedBox(height: 170),
              Icon(
                Icons.train,
                color: grey717,
                size: 50,
              ),
              SizedBox(height: 20),
              Center(
                child: CommonTextWidget.PoppinsMedium(
                  text: "No trains available for the selected date",
                  color: grey717,
                  fontSize: 14,
                ),
              ),
            ],
          );
  }

  Widget _buildTrainHeader(Map<String, dynamic> train) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget.PoppinsSemiBold(
          text: train['trainName'] ?? 'N/A',
          color: black2E2,
          fontSize: 14,
        ),
        CommonTextWidget.PoppinsMedium(
          text: "#${train['trainNumber'] ?? 'N/A'}",
          color: greyB8B,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildTrainTimings(Map<String, dynamic> train) {
    final arrival = calculateArrival(train, widget.selectedDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: formatTime(train['departureTime']) ?? 'N/A',
              color: black2E2,
              fontSize: 14,
            ),
            CommonTextWidget.PoppinsMedium(
              text: train['fromStnCode'] ?? 'N/A',
              color: greyB8B,
              fontSize: 14,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 2,
              width: 30,
              color: greyDBD,
            ),
            SizedBox(width: 15),
            CommonTextWidget.PoppinsMedium(
              text: train['duration'] ?? 'N/A',
              color: grey717,
              fontSize: 12,
            ),
            SizedBox(width: 15),
            Container(
              height: 2,
              width: 30,
              color: greyDBD,
            ),
          ],
        ),
        Column(
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: arrival['formattedArrivalTime'] ?? 'N/A',
              color: black2E2,
              fontSize: 14,
            ),
            CommonTextWidget.PoppinsMedium(
              text: train['toStnCode'] ?? 'N/A',
              color: greyB8B,
              fontSize: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainDistance(Map<String, dynamic> train) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: "Distance: ${train['distance'] ?? 'N/A'} km",
          color: grey717,
          fontSize: 12,
        ),
        GestureDetector(
          onTap: () => Get.to(() => ViewTrainRoutes(
                trainNumber: train['trainNumber'],
                fromStation: widget.fromStation,
                toStation: widget.toStation,
              )),
          child: Text(
            "view Routes",
            style: TextStyle(
                color: redCA0,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget _buildSeatAvailability(
      BuildContext context, Map<String, dynamic> train) {
    final DateTime now = DateTime.now();
    filterController.applyFilters(widget.trains);

    DateTime? _parseDate(String date) {
      try {
        final parts = date.split('-');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        }
      } catch (e) {
        print("Error parsing date: $date");
      }
      return null;
    }

    List<Widget> _buildAvailabilityWidgets(List<dynamic> availabilityDayList) {
      return availabilityDayList.map((availability) {
        final String availabilityDateString =
            availability['availablityDate'] ?? '';
        final DateTime? availabilityDate = _parseDate(availabilityDateString);

        if (availabilityDate == null ||
            availabilityDate.year != widget.selectedDate.year ||
            availabilityDate.month != widget.selectedDate.month ||
            availabilityDate.day != widget.selectedDate.day) {
          return SizedBox.shrink();
        }

        final bool isPastDate = now.isAfter(availabilityDate);

        // Define the availability status and color scheme
        String status = availability['availablityStatus'] ?? 'N/A';
        print("Status: $status");
        Color statusColor;
        IconData statusIcon;

        if (status != 'N/A') {
          if (status.contains('AVAILABLE')) {
            statusColor = Colors.green;
            statusIcon = Icons.check_circle;
          } else if (status.contains('RAC')) {
            statusColor = Colors.blue;
            statusIcon = Icons.timer;
          } else if (status.contains('WL')) {
            statusColor = Colors.orange;
            statusIcon = Icons.hourglass_empty;
          } else {
            statusColor = Colors.grey;
            statusIcon = Icons.cancel;
          }
        } else {
          statusColor = Colors.grey;
          statusIcon = Icons.cancel;
        }

        return Container(
          height: 22,
          margin: EdgeInsets.only(bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Availability status with icon and formatted seat data
              Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 13,
                  ),
                  SizedBox(width: 4),
                  Text(
                    getFormattedSeatsData(availability),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),

              // Additional information (e.g., availability types and travel guarantee)
              // if (!isPastDate) ...[
              //   if (availability['availablityType'] == "1" ||
              //       availability['availablityType'] == "2")
              //     Row(
              //       children: [
              //         // Icon(
              //         //   Icons.check_circle,
              //         //   color: Colors.green,
              //         //   size: 16,
              //         // ),
              //         SizedBox(width: 4),
              //         Text(
              //           "Travel Guarantee",
              //           style: TextStyle(
              //             color: Colors.green,
              //             fontSize: 13,
              //           ),
              //         ),
              //       ],
              //     )
              //   else if (availability['availablityType'] == "3")
              //     Text(
              //       "50% chances",
              //       style: TextStyle(
              //         color: Colors.orange,
              //         fontSize: 12,
              //       ),
              //     ),
              // ],
            ],
          ),
        );
      }).toList();
    }

    final DateTime departureDateTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      int.parse(train['departureTime'].split(':')[0]),
      int.parse(train['departureTime'].split(':')[1]),
    );
    final bool isDeparted = now.isAfter(departureDateTime);

    return Column(
      children: [
        if (isDeparted)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Center(
              child: CommonTextWidget.PoppinsMedium(
                text: "Train has already departed",
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                train['availabilities']?.length ?? 0,
                (seatIndex) {
                  final seat = train['availabilities'][seatIndex];
                  final DateTime departureDateTime = DateTime(
                    widget.selectedDate.year,
                    widget.selectedDate.month,
                    widget.selectedDate.day,
                    int.parse(train['departureTime'].split(':')[0]),
                    int.parse(train['departureTime'].split(':')[1]),
                  );
                  final bool isDeparted = now.isAfter(departureDateTime);

                  // Set color based on availability status
                  Color boxColor;
                  String availabilityStatus = seat['avlDayList'] != null &&
                          seat['avlDayList'].isNotEmpty
                      ? seat['avlDayList'][0]['availablityStatus'] ?? 'N/A'
                      : 'N/A';
                  if (availabilityStatus != 'N/A') {
                    if (availabilityStatus.contains('AVAILABLE')) {
                      boxColor = const Color.fromARGB(255, 237, 250, 237);
                    } else if (availabilityStatus.contains('WL')) {
                      boxColor = const Color.fromARGB(255, 255, 246, 235);
                    } else if (availabilityStatus.contains('RAC')) {
                      boxColor = const Color.fromARGB(173, 216, 230, 255);
                    } else {
                      boxColor = Colors.grey[300]!;
                    }
                  } else {
                    boxColor = Colors.grey[300]!;
                  }

                  // Set color based on availability status
                  Color borderColor = Colors.grey[300]!;
                  String availabilityStatus2 = seat['avlDayList'] != null &&
                          seat['avlDayList'].isNotEmpty
                      ? seat['avlDayList'][0]['availablityStatus'] ?? 'N/A'
                      : 'N/A';
                  if (availabilityStatus2 != 'N/A') {
                    if (availabilityStatus2.contains('AVAILABLE')) {
                      borderColor = Colors.green;
                    } else if (availabilityStatus2.contains('WL')) {
                      borderColor = Colors.orange;
                    } else if (availabilityStatus2.contains('RAC')) {
                      borderColor = const Color.fromARGB(172, 51, 123, 248);
                    } else {
                      borderColor = Colors.grey[300]!;
                    }
                  } else {
                    borderColor = Colors.grey[300]!;
                  }

                  // Filter classes based on enqClass
                  if (filterController.selectedClasses.isNotEmpty &&
                      !filterController.selectedClasses
                          .contains(seat['enqClass'])) {
                    return SizedBox.shrink();
                  }

                  // Filter quotas based on selectedQuotas or Tatkal filter
                  if (filterController.isTatkalFilterEnabled.value) {
                    if (seat['quota'] != 'TQ') {
                      // Hide seat if Tatkal filter is enabled and it's not TQ
                      return SizedBox.shrink();
                    }
                  } else if (filterController.selectedQuotas.isNotEmpty &&
                      !filterController.selectedQuotas
                          .contains(seat['quota'])) {
                    // Hide seat if its quota is not in the selected quotas
                    return SizedBox.shrink();
                  }
                  

                  // Apply availability filter
                  // if (filterController.isAvailabilityFilterEnabled.value) {
                  //   if (seat['avlDayList']?.any((avlDayList) =>
                  //       avlDayList['availablityStatus']?.toUpperCase() ==
                  //       'AVAILABLE')) {
                  //     // Hide seat if filter is enabled and the availability status is not AVAILABLE-0010
                  //     return SizedBox.shrink();
                  //   }
                  // } else {
                  //   // If filter is not enabled, you can show the seat or apply other filters as needed
                  //   return SizedBox
                  //       .shrink(); // This can be adjusted based on other conditions
                  // }

                  // Apply AC filter and exclude SL
                  bool acMatch = !filterController.isACFilterEnabled.value ||
                      seat['enqClass'] != "SL" &&
                          ["1A", "2A", "3A", "3E", "CC", "EC"]
                              .contains(seat['enqClass']);
                  if (!acMatch) {
                    print('Excluded by AC filter: ${train['trainNumber']}');
                    return SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                      right: seatIndex < train['availabilities']?.length - 1
                          ? 15
                          : 0,
                    ),
                    child: InkWell(
                      onTap: () {
                        if (!isDeparted &&
                            availabilityStatus != 'N/A' &&
                            seat['totalFare'] != null) {
                          {
                            Get.snackbar(
                              "Seat Availability",
                              "Seat is available: ${seat['enqClass']}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          }
                          Get.to(
                            () => TrainAndBusSearchScreen2(
                              trainName: train['trainName'],
                              trainNumber: train['trainNumber'],
                              startStation: train['fromStnCode'],
                              endStation: train['toStnCode'],
                              fromStation: widget.fromStation,
                              toStation: widget.toStation,
                              seatClass: seat['enqClass'],
                              price:
                                  double.tryParse(seat['totalFare'].toString()),
                              duration: train['duration'],
                              departureTime: train['departureTime'],
                              arrivalTime: train['arrivalTime'],
                              departure: DateFormat('dd MMM, EE')
                                  .format(widget.selectedDate),
                              arrival: calculateArrival(train,
                                  widget.selectedDate)['formattedArrivalDate'],
                            ),
                          );
                        } else {
                          print("Seat is available: ${seat['enqClass']}");
                        }
                      },
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          color: boxColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 6,
                              offset: Offset(0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Seat class and fare
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CommonTextWidget.PoppinsMedium(
                                    text: seat['enqClass'] ?? "N/A",
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: seat['totalFare'] != null
                                        ? "\₹${seat['totalFare']}"
                                        : "Regret",
                                    color: Colors.black,
                                    fontSize: 13,
                                  ),
                                ],
                              ),
                              // SizedBox(height: 2),
                              // Quota type
                              if (seat['quota'] == 'TQ' ||
                                  seat['quota'] == 'PT' ||
                                  seat['quota'] == 'LD' ||
                                  seat['quota'] == 'GN' ||
                                  seat['quota'] == 'SS' ||
                                  seat['quota'] == 'HP')
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CommonTextWidget.PoppinsMedium(
                                    text: seat['quota'] == 'TQ'
                                        ? 'Tatkal'
                                        : seat['quota'] == 'PT'
                                            ? 'Premium Tatkal'
                                            : seat['quota'] == 'LD'
                                                ? 'Ladies'
                                                : '',
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              // Build the availability widgets
                              ..._buildAvailabilityWidgets(
                                  seat['avlDayList'] ?? []),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomFilterBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 12, right: 12),
        child: Container(
          height: 70,
          width: Get.width,
          decoration: BoxDecoration(
            color: redCA0,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToggleButton("AC", filterController.isACFilterEnabled),
              _buildToggleButton(
                  "Availability", filterController.isAvailabilityFilterEnabled),
              _buildToggleButton(
                  "Tatkal", filterController.isTatkalFilterEnabled),
              GestureDetector(
                onTap: () {
                  showTrainFilterBottomSheet(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        slidersHorizontal,
                        height: 20,
                        width: 20,
                        color: redCA0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Filter",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: FontFamily.PoppinsMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, RxBool toggleValue) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          toggleValue.value = !toggleValue.value;
          setState(() {
            filteredTrains = filterController.applyFilters(widget.trains);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: toggleValue.value
                ? const Color(0xFF1976D2)
                : const Color(0xFFEDEDED),
            boxShadow: toggleValue.value
                ? [
                    BoxShadow(
                      color: redCA0.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: toggleValue.value ? Colors.white : Colors.black87,
              fontSize: 14,
              fontFamily: FontFamily.PoppinsSemiBold,
            ),
          ),
        ),
      );
    });
  }

  String getFormattedSeatsData(Map<String, dynamic> seat) {
    final String availabilityStatus =
        seat['availablityStatus'] ?? 'Not Available';
    final String availabilityType = seat['availablityType'] ?? '';

    // Check if the train has departed
    if (availabilityStatus.toUpperCase().contains('TRAIN DEPARTED')) {
      return "DEPARTED";
    }

    if (availabilityType == "0" ||
        availabilityType == "4" ||
        availabilityType == "5") {
      return availabilityStatus.isEmpty ? "Not Available" : availabilityStatus;
    } else if (availabilityType == "1" &&
        availabilityStatus.contains('AVAILABLE-')) {
      final int seats = int.tryParse(availabilityStatus.split('-')[1]) ?? 0;
      return "AVL $seats";
    } else if (availabilityType == "2" && availabilityStatus.contains("RAC")) {
      final String racStatus = availabilityStatus.split('/').last.trim();
      final int seats =
          int.tryParse(racStatus.replaceAll(RegExp(r'\D'), '')) ?? 0;
      return "RAC $seats";
    } else if (availabilityType == "3" && availabilityStatus.contains("WL")) {
      final String wlStatus = availabilityStatus.split('/').last;
      final int seats =
          int.tryParse(wlStatus.replaceAll(RegExp(r'\D'), '')) ?? 0;
      return "WL $seats";
    } else {
      return "Not Available";
    }
  }
}
