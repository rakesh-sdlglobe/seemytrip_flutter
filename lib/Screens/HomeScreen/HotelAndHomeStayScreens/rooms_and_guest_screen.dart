import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Controller/roomsGuest_controller.dart';
import 'package:seemytrip/Constants/colors.dart';

class RoomsAndGuestScreen extends StatefulWidget {
  final RxList<Map<String, dynamic>> roomGuestData;
  const RoomsAndGuestScreen({Key? key, required this.roomGuestData}) : super(key: key);

  @override
  State<RoomsAndGuestScreen> createState() => _RoomsAndGuestScreenState();
}

class _RoomsAndGuestScreenState extends State<RoomsAndGuestScreen> {
  late List<Map<String, dynamic>> localRooms;

  @override
  void initState() {
    super.initState();
    // Deep copy for local editing
    localRooms = widget.roomGuestData.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _addRoom() {
    setState(() {
      localRooms.add({
        "RoomNo": localRooms.length + 1,
        "Adults": 2,
        "Children": 0,
      });
    });
  }

  void _removeRoom(int index) {
    if (localRooms.length > 1) {
      setState(() {
        localRooms.removeAt(index);
        for (int i = 0; i < localRooms.length; i++) {
          localRooms[i]["RoomNo"] = i + 1;
        }
      });
    }
  }

  void _updateRoom(int index, {int? adults, int? children}) {
    setState(() {
      if (adults != null) localRooms[index]["Adults"] = adults;
      if (children != null) localRooms[index]["Children"] = children;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Rooms & Guests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 16),
          ...List.generate(localRooms.length, (i) {
            final room = localRooms[i];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Text("Room ${room["RoomNo"]}", style: TextStyle(fontWeight: FontWeight.w600)),
                    Spacer(),
                    Row(
                      children: [
                        Text("Adults"),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: room["Adults"] > 1
                              ? () => _updateRoom(i, adults: room["Adults"] - 1)
                              : null,
                        ),
                        Text("${room["Adults"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: room["Adults"] < 6
                              ? () => _updateRoom(i, adults: room["Adults"] + 1)
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Row(
                      children: [
                        Text("Children"),
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: room["Children"] > 0
                              ? () => _updateRoom(i, children: room["Children"] - 1)
                              : null,
                        ),
                        Text("${room["Children"]}", style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: room["Children"] < 4
                              ? () => _updateRoom(i, children: room["Children"] + 1)
                              : null,
                        ),
                      ],
                    ),
                    if (localRooms.length > 1)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeRoom(i),
                      ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _addRoom,
                icon: Icon(Icons.add),
                label: Text("Add Room"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: redCA0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(localRooms);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: redCA0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Done", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}