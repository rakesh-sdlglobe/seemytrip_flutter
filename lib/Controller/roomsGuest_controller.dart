import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RoomsGuestController extends GetxController {
  RxList<Map<String, String>> roomGuestData = <Map<String, String>>[
    {
      "text1": "Room 1",
      "text2": "2 Adults, 1 Child",
      "text3": "Edit",
    },
    {
      "text1": "Room 2",
      "text2": "1 Adult",
      "text3": "Edit",
    },
  ].obs;

  String get subtitleSummary {
    int totalRooms = roomGuestData.length;
    int totalAdults = 0;
    int totalChildren = 0;

    for (var room in roomGuestData) {
      String? text2 = room["text2"];
      if (text2 != null) {
        RegExp exp = RegExp(r'(\d+)\s*Adult');
        RegExp expChild = RegExp(r'(\d+)\s*Child');

        var match = exp.firstMatch(text2);
        if (match != null) {
          totalAdults += int.tryParse(match.group(1)!) ?? 0;
        }

        var matchChild = expChild.firstMatch(text2);
        if (matchChild != null) {
          totalChildren += int.tryParse(matchChild.group(1)!) ?? 0;
        }
      }
    }

    String summary = "$totalRooms Room${totalRooms > 1 ? 's' : ''}, $totalAdults Adult${totalAdults > 1 ? 's' : ''}";
    if (totalChildren > 0) {
      summary += ", $totalChildren Child${totalChildren > 1 ? 'ren' : ''}";
    }

    return summary;
  }
}
