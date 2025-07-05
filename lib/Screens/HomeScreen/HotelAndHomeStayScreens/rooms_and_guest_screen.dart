import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Constants/images.dart';
import 'package:seemytrip/Screens/Utills/common_button_widget.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class RoomsAndGuestScreen extends StatefulWidget {
  final List<Map<String, String>> roomGuestData;

  RoomsAndGuestScreen({Key? key, required this.roomGuestData}) : super(key: key);

  @override
  State<RoomsAndGuestScreen> createState() => _RoomsAndGuestScreenState();
}

class _RoomsAndGuestScreenState extends State<RoomsAndGuestScreen> {
  late List<Map<String, String>> roomGuestList;

  @override
  void initState() {
    super.initState();
    roomGuestList = widget.roomGuestData.map((room) => Map<String, String>.from(room)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: BoxDecoration(
        color: white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildInfoBanner(),
            const SizedBox(height: 20),
            _buildRoomGuestList(),
            _buildAddRoomButton(),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CommonButtonWidget.button(
                text: "DONE",
                onTap: () => Get.back(result: roomGuestList),
                buttonColor: redCA0,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 65,
      width: Get.width,
      decoration: BoxDecoration(
        color: redCA0,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: const Icon(Icons.close, color: white, size: 20),
            ),
            CommonTextWidget.PoppinsMedium(
              text: "Rooms & Guests",
              color: white,
              fontSize: 18,
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      height: 89,
      width: Get.width,
      color: redF9E.withOpacity(0.75),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        leading: Image.asset(manager, height: 35, width: 35),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Group booking made easy!",
          color: black2E2,
          fontSize: 15,
        ),
        subtitle: CommonTextWidget.PoppinsRegular(
          text: "Save More! Get exciting group booking deals for 5+ rooms.",
          color: grey717,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRoomGuestList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: roomGuestList.length,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemBuilder: (context, index) {
        final item = roomGuestList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Room title and subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonTextWidget.PoppinsMedium(
                    text: item["text1"] ?? '',
                    color: black2E2,
                    fontSize: 14,
                  ),
                  CommonTextWidget.PoppinsRegular(
                    text: item["text2"] ?? '',
                    color: grey717,
                    fontSize: 12,
                  ),
                ],
              ),
              // Edit and delete actions
              Row(
                children: [
                  // Edit Button
                  InkWell(
                    onTap: () => _showEditDialog(index),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: grey515.withOpacity(0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      child: Row(
                        children: [
                          CommonTextWidget.PoppinsSemiBold(
                            text: "Edit",
                            color: redCA0,
                            fontSize: 14,
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(arrowDownIcon, height: 12),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Delete Button
                  if (roomGuestList.length > 1)
                    InkWell(
                      onTap: () {
                        setState(() {
                          roomGuestList.removeAt(index);
                          _relabelRooms();
                        });
                      },
                      child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddRoomButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _addNewRoom,
          icon: const Icon(Icons.add_circle_outline, color: Colors.black),
          label: CommonTextWidget.PoppinsMedium(
            text: "Add Room",
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _addNewRoom() {
    int nextRoomNumber = roomGuestList.length + 1;
    setState(() {
      roomGuestList.add({
        "text1": "Room $nextRoomNumber",
        "text2": "2 Adults, 0 Children",
        "text3": "Edit",
        "adults": "2",
        "children": "0",
      });
    });
  }

  void _relabelRooms() {
    for (int i = 0; i < roomGuestList.length; i++) {
      roomGuestList[i]["text1"] = "Room ${i + 1}";
    }
  }

  void _showEditDialog(int index) {
    int adults = int.tryParse(roomGuestList[index]["adults"] ?? '2') ?? 2;
    int children = int.tryParse(roomGuestList[index]["children"] ?? '0') ?? 0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Room Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCounter("Adults", adults, (val) => adults = val),
            const SizedBox(height: 10),
            _buildCounter("Children", children, (val) => children = val),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              roomGuestList[index]["adults"] = adults.toString();
              roomGuestList[index]["children"] = children.toString();
              roomGuestList[index]["text2"] =
                  "$adults Adult${adults > 1 ? 's' : ''}, $children Child${children > 1 ? 'ren' : ''}";
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text("SAVE"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("CANCEL"),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int value, Function(int) onChanged) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (value > 0) {
                      setState(() {
                        value--;
                        onChanged(value);
                      });
                    }
                  },
                ),
                Text('$value'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      value++;
                      onChanged(value);
                    });
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
