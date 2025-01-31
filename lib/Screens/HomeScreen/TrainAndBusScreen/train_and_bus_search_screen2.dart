import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:makeyourtripapp/Constants/colors.dart';
import 'package:makeyourtripapp/Constants/font_family.dart';
import 'package:makeyourtripapp/Controller/travellerDetailController.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/review_booking_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/train_and_bus_contact_information_screen.dart';
import 'package:makeyourtripapp/Screens/HomeScreen/TrainAndBusScreen/traveller_detail_screen.dart';
import 'package:makeyourtripapp/Screens/Utills/common_text_widget.dart';
import 'package:makeyourtripapp/Screens/Utills/common_textfeild_widget.dart';
import 'package:makeyourtripapp/main.dart';
import 'package:intl/intl.dart';

class TrainAndBusSearchScreen2 extends StatefulWidget {
  final String? trainName;
  final String? trainNumber;
  final String? startStation;
  final String? endStation;
  final String fromStation;
  final String toStation;
  final String? seatClass;
  final double? price;
  final String? duration;
  final String? departureTime;
  final String? arrivalTime;
  final String? departure;
  final String? arrival;

  TrainAndBusSearchScreen2({
    Key? key,
    required this.trainName,
    required this.trainNumber,
    required this.startStation,
    required this.endStation,
    required this.fromStation,
    required this.toStation,
    required this.seatClass,
    required this.price,
    required this.duration,
    required this.departureTime,
    required this.arrivalTime,
    required this.departure,
    required this.arrival,
  }) : super(key: key);

  @override
  State<TrainAndBusSearchScreen2> createState() =>
      _TrainAndBusSearchScreen2State();
}

class _TrainAndBusSearchScreen2State extends State<TrainAndBusSearchScreen2> {
  final TravellerDetailController travellerDetailController =
      Get.put(TravellerDetailController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController promoCodeController = TextEditingController();
  String irctcUsername = '';
  List<String> selectedTravellers = [];

  // Function to format time from 24-hour to 12-hour format with AM/PM
  String formatTime(String time) {
    final DateFormat inputFormat = DateFormat("HH:mm");
    final DateFormat outputFormat = DateFormat("hh:mm a");
    final DateTime parsedTime = inputFormat.parse(time);
    return outputFormat.format(parsedTime);
  }


  @override
  Widget build(BuildContext context) {
    print('departure date: ${widget.departure}');
    print('arrival date: ${widget.arrival}');
    return Scaffold(
      backgroundColor: redF9E,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildBody(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: redCA0,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: true,
      leading: InkWell(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back, color: white, size: 20),
      ),
      title: CommonTextWidget.PoppinsSemiBold(
        text: "Train Search",
        color: white,
        fontSize: 18,
      ),
    );
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildTrainInfo(),
            SizedBox(height: 10),
            _buildIRCTCUsername(),
            SizedBox(height: 10),
            _buildTravellerDetails(),
            SizedBox(height: 10),
            _buildContactDetails(),
            SizedBox(height: 10),
            _buildOffersAndDiscounts(),
            SizedBox(height: 130),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainInfo() {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            _buildTrainHeader(),
            SizedBox(height: 20),
            _buildTrainSchedule(),
            SizedBox(height: 15),
            _buildTrainStations(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrainHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget.PoppinsSemiBold(
          text: widget.trainName ?? 'Unknown Train',
          color: black2E2,
          fontSize: 14,
        ),
        CommonTextWidget.PoppinsMedium(
          text: "#${widget.trainNumber ?? '0000'}",
          color: greyB8B,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildTrainSchedule() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildScheduleColumn(formatTime(widget.departureTime ?? '00:00'),
            widget.departure ?? ''),
        _buildDuration(),
        _buildScheduleColumn(
            formatTime(widget.arrivalTime ?? '00:00'), widget.arrival ?? ''),
      ],
    );
  }

  Widget _buildScheduleColumn(String time, String date) {
    return Column(
      children: [
        CommonTextWidget.PoppinsSemiBold(
          text: time,
          color: black2E2,
          fontSize: 14,
        ),
        CommonTextWidget.PoppinsMedium(
          text: date,
          color: greyB8B,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildDuration() {
    return Row(
      children: [
        Container(
          height: 2,
          width: 30,
          color: greyDBD,
        ),
        SizedBox(width: 15),
        CommonTextWidget.PoppinsMedium(
          text: widget.duration,
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
    );
  }

  Widget _buildTrainStations() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: widget.fromStation ?? 'Unknown Station',
          color: grey717,
          fontSize: 12,
        ),
        CommonTextWidget.PoppinsMedium(
          text: widget.toStation ?? 'Unknown Station',
          color: grey717,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildIRCTCUsername() {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: "IRCTC Username",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 10),
            _buildIRCTCUsernameField(),
            SizedBox(height: 15),
            _buildIRCTCOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildIRCTCUsernameField() {
    return InkWell(
      onTap: () async {
        final result = await Get.bottomSheet(
          TrainAndBusContactInformationScreen(),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
        if (result != null) {
          setState(() {
            irctcUsername = result;
          });
        }
      },
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: greyE2E,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: irctcUsername.isEmpty ? "USERNAME" : irctcUsername,
                    color: grey888,
                    fontSize: 12,
                  ),
                  SizedBox(height: 9.0),
                  if (irctcUsername.isEmpty)
                    CommonTextWidget.PoppinsMedium(
                      text: "Enter IRCTC Username",
                      color: grey888,
                      fontSize: 12,
                    ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: grey888, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIRCTCOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: "CREATE NEW IRCTC ACCOUNT",
          color: redCA0,
          fontSize: 12,
        ),
        SizedBox(height: 10),
        CommonTextWidget.PoppinsMedium(
          text: "FORGOT USERNAME",
          color: redCA0,
          fontSize: 12,
        ),
      ],
    );
  }

  Widget _buildTravellerDetails() {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: "Traveller Details",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 15),
            _buildSavedTravellers(),
            SizedBox(height: 15),
            _buildAddTravellerDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedTravellers() {
    final TravellerDetailController controller =
        Get.find<TravellerDetailController>();

    return Obx(
      () => Column(
        children: controller.travellers.map((traveller) {
          final isSelected = selectedTravellers.contains(traveller['name']);
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedTravellers.remove(traveller['name']);
                  } else {
                    selectedTravellers.add(traveller['name']);
                  }
                });
              },
              child: Container(
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: isSelected ? redCA0.withOpacity(0.2) : greyE2E,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextWidget.PoppinsMedium(
                            text: traveller['name'],
                            color: black2E2,
                            fontSize: 14,
                          ),
                          const SizedBox(height: 5),
                          CommonTextWidget.PoppinsMedium(
                            text:
                                "Age: ${traveller['age']}, Gender: ${traveller['gender']}",
                            color: grey717,
                            fontSize: 12,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle edit functionality here
                          print("Edit tapped for ${traveller['name']}");
                        },
                        child: Icon(Icons.edit, color: redCA0, size: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAddTravellerDetails() {
    return InkWell(
      onTap: () {
        Get.to(() => TravellerDetailScreen());
      },
      child: CommonTextWidget.PoppinsMedium(
        text: "+ TRAVELLER DETAILS",
        color: redCA0,
        fontSize: 12,
      ),
    );
  }

  Widget _buildContactDetails() {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: "Contact Details",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 15),
            _buildContactField("Email ID", "Eg. abc@gmail.com", emailController,
                TextInputType.emailAddress),
            SizedBox(height: 15),
            _buildContactField("Phone Number", "95********", phoneController,
                TextInputType.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildContactField(String label, String hintText,
      TextEditingController controller, TextInputType keyboardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonTextWidget.PoppinsMedium(
          text: label,
          color: grey717,
          fontSize: 12,
        ),
        SizedBox(height: 5),
        CommonTextFieldWidget.TextFormField4(
          hintText: hintText,
          controller: controller,
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildOffersAndDiscounts() {
    return Container(
      width: Get.width,
      color: white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.PoppinsSemiBold(
              text: "Offers & Discounts",
              color: black2E2,
              fontSize: 14,
            ),
            SizedBox(height: 20),
            _buildZeroCancellationFee(),
            SizedBox(height: 15),
            _buildPromoCodeField(),
          ],
        ),
      ),
    );
  }

  Widget _buildZeroCancellationFee() {
    return Row(
      children: [
        Radio(
          value: 1,
          groupValue: 1,
          onChanged: (value) {},
          activeColor: redCA0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextWidget.PoppinsRegular(
              text: "Zero Cancellation Fee",
              color: grey717,
              fontSize: 12,
            ),
            SizedBox(height: 7),
            CommonTextWidget.PoppinsRegular(
              text: "Save Rs. 50 on cancellation fee",
              color: grey717,
              fontSize: 12,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPromoCodeField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      cursorColor: black2E2,
      controller: promoCodeController,
      style: TextStyle(
        color: black2E2,
        fontSize: 14,
        fontFamily: FontFamily.PoppinsRegular,
      ),
      decoration: InputDecoration(
        hintText: "Enter promo code here",
        hintStyle: TextStyle(
          color: grey717,
          fontSize: 12,
          fontFamily: FontFamily.PoppinsRegular,
        ),
        suffixIcon: Padding(
          padding: EdgeInsets.all(14),
          child: CommonTextWidget.PoppinsMedium(
            color: redCA0,
            fontSize: 14,
            text: "APPLY",
          ),
        ),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.only(left: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: grey717, width: 1),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: Get.width,
              color: black2E2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceInfo(),
                    _buildContinueButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Column(
      children: [
        CommonTextWidget.PoppinsSemiBold(
          text: "₹ ${widget.price?.toString() ?? '0'}",
          color: white,
          fontSize: 16,
        ),
        CommonTextWidget.PoppinsMedium(
          text: "PER PERSON",
          color: white,
          fontSize: 10,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return MaterialButton(
      onPressed: () {
        Get.to(() => ReviewBookingScreen(
              trainName: widget.trainName ?? 'Unknown Train',
              trainNumber: widget.trainNumber ?? '0000',
              startStation: widget.startStation ?? 'Unknown Station',
              endStation: widget.endStation ?? 'Unknown Station',
              seatClass: widget.seatClass ?? 'Unknown Class',
              price: widget.price ?? 0.0,
            ));
      },
      height: 40,
      minWidth: 140,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      color: redCA0,
      child: CommonTextWidget.PoppinsSemiBold(
        fontSize: 16,
        text: "CONTINUE",
        color: white,
      ),
    );
  }
}
