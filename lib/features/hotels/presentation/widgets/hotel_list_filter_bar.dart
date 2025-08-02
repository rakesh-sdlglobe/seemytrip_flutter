import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/features/hotels/presentation/controllers/hotel_filter_controller.dart';
import 'package:seemytrip/core/widgets/lists_widget.dart' as custom_lists;

class HotelListFilterBar extends StatelessWidget {
  final HotelFilterController filterCtrl;
  final List<Map<String, dynamic>> hotels;

  const HotelListFilterBar({
    Key? key,
    required this.filterCtrl,
    required this.hotels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(width: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(right: 19, top: 1, bottom: 10),
              shrinkWrap: true,
              itemCount: custom_lists.Lists.hotelList1.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(right: 5),
                child: Obx(() {
                  final filterType = custom_lists.Lists.hotelList1[index]["filterType"] ?? '';
                  final filterText = custom_lists.Lists.hotelList1[index]["text"] ?? '';
                  return InkWell(
                    onTap: () {
                      filterCtrl.selectedFilter.value = filterType;
                      filterCtrl.applyFilter(filterType, hotels);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: filterCtrl.selectedFilter.value == filterType
                            ? redCA0.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: filterCtrl.selectedFilter.value == filterType
                              ? redCA0
                              : greyE2E,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        child: Row(
                          children: [
                            Text(
                              filterText,
                              style: TextStyle(
                                color: filterCtrl.selectedFilter.value == filterType
                                    ? redCA0
                                    : grey717,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 7),
                            Icon(Icons.arrow_drop_down, color: filterCtrl.selectedFilter.value == filterType
                                ? redCA0
                                : grey717),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(width: 16),
          InkWell(
            onTap: () {
              // You can move the filter bottom sheet logic here if you want
              // or keep it in the main screen for more control.
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: redCA0.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.filter_alt, color: redCA0, size: 22),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}

