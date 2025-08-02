import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RoomsGuestController extends GetxController {
  // Dynamic room/guest data, default: 1 room, 2 adults, 0 children
  RxList<Map<String, dynamic>> roomGuestData = <Map<String, dynamic>>[
    {
      "RoomNo": 1,
      "Adults": 2,
      "Children": 0,
    }
  ].obs;

  String get subtitleSummary {
    int totalRooms = roomGuestData.length;
    int totalAdults = 0;
    int totalChildren = 0;

    for (var room in roomGuestData) {
      totalAdults += (room["Adults"] as int? ?? 0);
      totalChildren += (room["Children"] as int? ?? 0);
    }

    String summary = "$totalRooms Room${totalRooms > 1 ? 's' : ''}, $totalAdults Adult${totalAdults > 1 ? 's' : ''}";
    if (totalChildren > 0) {
      summary += ", $totalChildren Child${totalChildren > 1 ? 'ren' : ''}";
    }
    return summary;
  }

  void addRoom() {
    roomGuestData.add({
      "RoomNo": roomGuestData.length + 1,
      "Adults": 2,
      "Children": 0,
    });
  }

  void removeRoom(int index) {
    if (roomGuestData.length > 1) {
      roomGuestData.removeAt(index);
      // Re-number rooms
      for (int i = 0; i < roomGuestData.length; i++) {
        roomGuestData[i]["RoomNo"] = i + 1;
      }
    }
  }

  void updateRoom(int index, {int? adults, int? children}) {
    if (index >= 0 && index < roomGuestData.length) {
      if (adults != null) roomGuestData[index]["Adults"] = adults;
      if (children != null) roomGuestData[index]["Children"] = children;
      roomGuestData.refresh();
    }
  }

  void onDone(List<Map<String, dynamic>> updatedRooms) {
    roomGuestData.assignAll(updatedRooms);
  }
}
