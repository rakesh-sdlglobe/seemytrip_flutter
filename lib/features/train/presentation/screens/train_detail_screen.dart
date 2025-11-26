import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common_text_widget.dart';
import '../../../../main.dart';
import '../../../../shared/constants/font_family.dart';
import '../../../../shared/constants/images.dart';
import '../../../booking/presentation/screens/sort_filter/trainFiltter_screen.dart';
import '../controllers/train_detail_controller.dart';
import '../controllers/train_sort_and_filter_controller.dart';
import 'train_booking_screen.dart';
import 'train_modify_search_screen.dart';
import 'view_train_routes_screen.dart';

// ignore: must_be_immutable
class TrainDetailScreen extends StatefulWidget {

  TrainDetailScreen({
    required this.trains, required this.selectedDate, required this.fromStation, required this.toStation, Key? key,
  }) : super(key: key);
  final List<dynamic> trains;
  DateTime selectedDate;
  final String fromStation;
  final String toStation;

  @override
  State<TrainDetailScreen> createState() => _TrainDetailScreenState();
}

class _TrainDetailScreenState extends State<TrainDetailScreen> {
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
    final DateFormat inputFormat = DateFormat('HH:mm');
    final DateFormat outputFormat = DateFormat('hh:mm a');
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }

  Map<String, String> calculateArrival(
      Map<String, dynamic> train, DateTime selectedDate) {
    final DateFormat format = DateFormat('HH:mm');
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

    final DateFormat outputFormat = DateFormat('dd MMM, EE');
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
    final TrainDetailController controller = Get.put(TrainDetailController())
    ..setInitialSelectedIndex(widget.selectedDate);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              _buildDateSelector(controller),
              SizedBox(height: 10),
              _buildTrainList(),
              SizedBox(height: 70),
            ],
          ),
          _buildBottomFilterBar(context),
          if (isLoading)
            Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: AppColors.redCA0,
                size: 80,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) => Container(
      height: 120,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(busAndTrainImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 8),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ListTile(
            horizontalTitleGap: -5,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back, 
                color: Theme.of(context).iconTheme.color ?? AppColors.grey888, 
                size: 18
              ),
            ),
            title: CommonTextWidget.PoppinsRegular(
              text: '${widget.fromStation} To ${widget.toStation}',
              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
              fontSize: 14,
            ),
            subtitle: CommonTextWidget.PoppinsRegular(
              text: DateFormat('dd MMM, EEEE').format(widget.selectedDate),
              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
              fontSize: 11,
            ),
            trailing: InkWell(
              onTap: () {
                Get.to(() => TrainModifySearchScreen(
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
                  SizedBox(height: 8),
                  CommonTextWidget.PoppinsMedium(
                    text: 'Edit',
                    color: AppColors.redCA0,
                    fontSize: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  Widget _buildDateSelector(TrainDetailController controller) => Container(
      width: Get.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6.0, bottom: 6),
              child: Text(
                'Select Journey Date',
                style: TextStyle(
                  fontFamily: FontFamily.PoppinsSemiBold,
                  fontSize: 11,
                  color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: GetBuilder<TrainDetailController>(
                init: TrainDetailController(),
                builder: (controller) => ListView.builder(
                  controller: ScrollController(
                    initialScrollOffset: controller.selectedIndex.value * 70.0,
                  ),
                  itemCount:
                      TrainDetailController.trainAndBusDetailList1.length,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final date = widget.selectedDate.add(Duration(days: index));
                    final isSelected = controller.selectedIndex.value == index;
                    
                    return GestureDetector(
                      onTap: () async => await _onDateSelected(controller, index, date),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        width: 52,
                        decoration: BoxDecoration(
                          color: isSelected 
                            ? AppColors.redCA0.withOpacity(0.1) 
                            : Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey[800] 
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected 
                              ? AppColors.redCA0 
                              : Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[600]!
                                : Colors.grey[200]!,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('EEE').format(date),
                              style: TextStyle(
                                fontFamily: isSelected ? FontFamily.PoppinsSemiBold : FontFamily.PoppinsMedium,
                                fontSize: 10,
                                color: isSelected 
                                  ? AppColors.redCA0 
                                  : Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.redCA0 : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontFamily: isSelected ? FontFamily.PoppinsSemiBold : FontFamily.PoppinsMedium,
                                    fontSize: 13,
                                    color: isSelected 
                                      ? AppColors.white 
                                      : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              DateFormat('MMM').format(date),
                              style: TextStyle(
                                fontFamily: isSelected ? FontFamily.PoppinsSemiBold : FontFamily.PoppinsRegular,
                                fontSize: 8,
                                color: isSelected 
                                  ? AppColors.redCA0 
                                  : Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

  Future<void> _onDateSelected(
      TrainDetailController controller, int index, DateTime date) async {
    setState(() {
      controller.onIndexChange(index);
      controller.setSelectedDate(date);
      isLoading = true;
    });

    try {
      await controller.getTrains(
        widget.trains[0]['fromStnCode'],
        widget.trains[0]['toStnCode'],
        DateFormat('yyyy-MM-dd').format(date),
      );

      setState(() {
        widget.selectedDate = date;
        filteredTrains = filterController.applyFilters(controller.trains);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      Get.snackbar(
        'Error',
        'Failed to load trains. Please try again.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  Widget _buildTrainList() {
    filteredTrains.removeWhere((train) => train['availabilities'].isEmpty ||
          train['availabilities'].every((seat) => seat['totalFare'] == null));

    return filteredTrains.isNotEmpty
        ? Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: GetBuilder<TrainSortAndFilterController>(
                init: TrainSortAndFilterController(),
                builder: (controller) => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 12, top: 8),
                    itemCount: filteredTrains.length,
                    itemBuilder: (context, index) {
                      final train = filteredTrains[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10, left: 12, right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.05),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                // Handle train selection
                              },
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildTrainHeader(train),
                                    SizedBox(height: 8),
                                    _buildTrainTimings(train),
                                    SizedBox(height: 16),
                                    _buildTrainDistance(train),
                                    SizedBox(height: 16),
                                    _buildSeatAvailability(context, train),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.train_outlined,
                  color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[600] 
                    : Colors.grey[400],
                  size: 64,
                ),
                SizedBox(height: 16),
                Text(
                  'No Trains Available',
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsSemiBold,
                    fontSize: 18,
                    color: Theme.of(context).textTheme.headlineSmall?.color ?? Colors.grey[700],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'No trains found for the selected date and route.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FontFamily.PoppinsRegular,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey[600],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Refresh or modify search
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redCA0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Modify Search',
                    style: TextStyle(
                      fontFamily: FontFamily.PoppinsMedium,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildTrainHeader(Map<String, dynamic> train) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.redCA0.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.train_rounded,
                  color: AppColors.redCA0,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      train['trainName'] ?? 'N/A',
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsSemiBold,
                        color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.black2E2,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Train No: ${train['trainNumber'] ?? 'N/A'}, ${train['trainType'] ?? ''}',
                      style: TextStyle(
                        fontFamily: FontFamily.PoppinsRegular,
                        color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[600],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Text(
          train['trainClass'] ?? 'N/A',
          style: TextStyle(
            fontFamily: FontFamily.PoppinsMedium,
            color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
            fontSize: 14,
          ),
        ),
      ],
    );

  Widget _buildTrainTimings(Map<String, dynamic> train) {
    final arrival = calculateArrival(train, widget.selectedDate);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: formatTime(train['departureTime'] ?? '00:00'),
              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
              fontSize: 14,
            ),
            CommonTextWidget.PoppinsMedium(
              text: train['fromStnCode'] ?? 'N/A',
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
              fontSize: 14,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 2,
              width: 30,
              color: Theme.of(context).dividerColor,
            ),
            SizedBox(width: 15),
            CommonTextWidget.PoppinsMedium(
              text: train['duration'] ?? 'N/A',
              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
              fontSize: 11,
            ),
            SizedBox(width: 15),
            Container(
              height: 2,
              width: 30,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
        Column(
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: arrival['formattedArrivalTime'] ?? 'N/A',
              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.black2E2,
              fontSize: 14,
            ),
            CommonTextWidget.PoppinsMedium(
              text: train['toStnCode'] ?? 'N/A',
              color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.greyB8B,
              fontSize: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrainDistance(Map<String, dynamic> train) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: "Distance: ${train['distance'] ?? 'N/A'} km",
          color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey717,
          fontSize: 12,
        ),
        GestureDetector(
          onTap: () => Get.to(() => ViewTrainRoutes(
                trainNumber: train['trainNumber'],
                fromStation: widget.fromStation,
                toStation: widget.toStation,
              )),
          child: Text(
            'view Routes',
            style: TextStyle(
                color: AppColors.redCA0,
                fontSize: 13,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.redCA0),
          ),
        ),
      ],
    );

  Widget _buildSeatAvailability(
      BuildContext context, Map<String, dynamic> train) {
    final DateTime now = DateTime.now();
    filterController.applyFilters(widget.trains);

    DateTime? parseDate(String date) {
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
        print('Error parsing date: $date');
      }
      return null;
    }

    List<Widget> buildAvailabilityWidgets(List<dynamic> availabilityDayList) => availabilityDayList.map((availability) {
        final String availabilityDateString =
            availability['availablityDate'] ?? '';
        final DateTime? availabilityDate = parseDate(availabilityDateString);

        if (availabilityDate == null ||
            availabilityDate.year != widget.selectedDate.year ||
            availabilityDate.month != widget.selectedDate.month ||
            availabilityDate.day != widget.selectedDate.day) {
          return SizedBox.shrink();
        }

        // final bool isPastDate = now.isAfter(availabilityDate);

        // Define the availability status and color scheme
        String status = availability['availablityStatus'] ?? 'N/A';
        print('Status: $status');
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
          height: 23,
          margin: EdgeInsets.only(bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Availability status with icon and formatted seat data
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      getFormattedSeatsData(availability),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                    ),
                    ),
                  )
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
              color: AppColors.redCA0.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.redCA0, width: 1),
            ),
            child: Center(
              child: CommonTextWidget.PoppinsMedium(
                text: 'Train has already departed',
                color: AppColors.redCA0,
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
                      boxColor = Theme.of(context).brightness == Brightness.dark 
                        ? const Color.fromARGB(255, 26, 46, 26)
                        : const Color.fromARGB(255, 237, 250, 237);
                    } else if (availabilityStatus.contains('WL')) {
                      boxColor = Theme.of(context).brightness == Brightness.dark 
                        ? const Color.fromARGB(255, 46, 36, 26)
                        : const Color.fromARGB(255, 255, 246, 235);
                    } else if (availabilityStatus.contains('RAC')) {
                      boxColor = Theme.of(context).brightness == Brightness.dark 
                        ? const Color.fromARGB(173, 26, 36, 46)
                        : const Color.fromARGB(173, 216, 230, 255);
                    } else {
                      boxColor = Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[800]! 
                        : Colors.grey[300]!;
                    }
                  } else {
                    boxColor = Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[800]! 
                      : Colors.grey[300]!;
                  }

                  // Set color based on availability status
                  Color borderColor;
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
                      borderColor = Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey[600]! 
                        : Colors.grey[300]!;
                    }
                  } else {
                    borderColor = Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey[600]! 
                      : Colors.grey[300]!;
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

                  // Replace the commented availability filter section with this:
                  // Apply availability filter
                  if (filterController.isAvailabilityFilterEnabled.value) {
                    // Check if seat has availability data
                    if (seat['avlDayList'] == null ||
                        seat['avlDayList'].isEmpty ||
                        !seat['avlDayList'].any((avlDay) {
                          String status = avlDay['availablityStatus']
                                  ?.toString()
                                  .toUpperCase() ??
                              '';
                          // Only show if status contains AVAILABLE and doesn't contain RAC or WL
                          return status.contains('AVAILABLE') &&
                              !status.contains('RAC') &&
                              !status.contains('WL')&&
                              !status.contains('NOT AVAILABLE');
                        })) {
                      // Hide seat if not available or has RAC/WL status
                      return SizedBox.shrink();
                    }
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
                      seat['enqClass'] != 'SL' &&
                          ['1A', '2A', '3A', '3E', 'CC', 'EC']
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
                              'Seat Availability',
                              "Seat is available: ${seat['enqClass']}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              duration: Duration(seconds: 3),
                            );
                          }
                          Get.to(
                            () => TrainBookingScreen(
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
                              journeyDate: DateFormat('yyyyMMdd').format(widget.selectedDate),
                              jQuota: seat['quota'] ?? 'GN',
                              boardingStationCode: train['fromStnCode'],
                            ),
                          );
                        } else {
                          print("Seat is available: ${seat['enqClass']}");
                        }
                      },
                      child: Container(
                        width: 140,
                        decoration: BoxDecoration(
                          color: boxColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.25),
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
                                    text: seat['enqClass'] ?? 'N/A',
                                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                                    fontSize: 11,
                                  ),
                                  CommonTextWidget.PoppinsMedium(
                                    text: seat['totalFare'] != null
                                        ? "₹${seat['totalFare']}"
                                        : 'Regret',
                                    color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                                    fontSize: 11,
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
                                    fontSize: 9,
                                  ),
                                ),
                              // Build the availability widgets
                              ...buildAvailabilityWidgets(
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

  Widget _buildBottomFilterBar(BuildContext context) => Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
        child: Container(
          height: 60,
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.redCA0,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToggleButton('AC', filterController.isACFilterEnabled),
              _buildToggleButton(
                  'Availability', filterController.isAvailabilityFilterEnabled),
              _buildToggleButton(
                  'Tatkal', filterController.isTatkalFilterEnabled),
              GestureDetector(
                onTap: () {
                  showTrainFilterBottomSheet(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        slidersHorizontal,
                        height: 18,
                        width: 18,
                        colorFilter: ColorFilter.mode(AppColors.redCA0, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
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

  Widget _buildToggleButton(String text, RxBool toggleValue) => Obx(() => GestureDetector(
        onTap: () {
          toggleValue.value = !toggleValue.value;
          setState(() {
            filteredTrains = filterController.applyFilters(widget.trains);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: toggleValue.value
                ? AppColors.redCA0
                : Theme.of(context).cardColor,
            boxShadow: toggleValue.value
                ? [
                    BoxShadow(
                      color: AppColors.redCA0.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: toggleValue.value 
                ? Colors.white 
                : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
              fontSize: 14,
              fontFamily: FontFamily.PoppinsSemiBold,
            ),
          ),
        ),
      ));

  String getFormattedSeatsData(Map<String, dynamic> seat) {
    final String availabilityStatus =
        seat['availablityStatus'] ?? 'Not Available';
    final String availabilityType = seat['availablityType'] ?? '';

    // Check if the train has departed
    if (availabilityStatus.toUpperCase().contains('TRAIN DEPARTED')) {
      return 'DEPARTED';
    }

    if (availabilityType == '0' ||
        availabilityType == '4' ||
        availabilityType == '5') {
      return availabilityStatus.isEmpty ? 'Not Available' : availabilityStatus;
    } else if (availabilityType == '1' &&
        availabilityStatus.contains('AVAILABLE-')) {
      final int seats = int.tryParse(availabilityStatus.split('-')[1]) ?? 0;
      return 'AVL $seats';
    } else if (availabilityType == '2' && availabilityStatus.contains('RAC')) {
      final String racStatus = availabilityStatus.split('/').last.trim();
      final int seats =
          int.tryParse(racStatus.replaceAll(RegExp(r'\D'), '')) ?? 0;
      return 'RAC $seats';
    } else if (availabilityType == '3' && availabilityStatus.contains('WL')) {
      final String wlStatus = availabilityStatus.split('/').last;
      final int seats =
          int.tryParse(wlStatus.replaceAll(RegExp(r'\D'), '')) ?? 0;
      return 'WL $seats';
    } else {
      return 'Not Available';
    }
  }
}
