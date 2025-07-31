import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming you have your colors defined somewhere like this
const Color primaryColor = Color(0xFFCA0B0B);
const Color textColorPrimary = Color(0xFF2D2D2D);
const Color textColorSecondary = Color(0xFF666666);

class RoomsAndGuestScreen extends StatefulWidget {
  final RxList<Map<String, dynamic>> roomGuestData;
  const RoomsAndGuestScreen({Key? key, required this.roomGuestData})
      : super(key: key);

  @override
  State<RoomsAndGuestScreen> createState() => _RoomsAndGuestScreenState();
}

class _RoomsAndGuestScreenState extends State<RoomsAndGuestScreen> {
  // Use a local list for modifications within the bottom sheet
  late List<Map<String, dynamic>> _localRooms;
  final int _maxRooms = 5;

  @override
  void initState() {
    super.initState();
    // Create a deep copy to avoid modifying the original list until "Apply" is pressed
    _localRooms =
        widget.roomGuestData.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void _addRoom() {
    if (_localRooms.length < _maxRooms) {
      setState(() {
        _localRooms.add({
          "RoomNo": _localRooms.length + 1,
          "Adults": 2, // Default to 2 adults for a new room
          "Children": 0,
        });
      });
    }
  }

  void _removeRoom(int index) {
    // Ensure there's always at least one room
    if (_localRooms.length > 1) {
      setState(() {
        _localRooms.removeAt(index);
        // Re-number the remaining rooms
        for (int i = 0; i < _localRooms.length; i++) {
          _localRooms[i]["RoomNo"] = i + 1;
        }
      });
    }
  }

  void _updateGuestCount(int roomIndex, {int? adults, int? children}) {
    setState(() {
      if (adults != null) {
        _localRooms[roomIndex]["Adults"] = adults;
      }
      if (children != null) {
        _localRooms[roomIndex]["Children"] = children;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              "Rooms & Guests",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: textColorPrimary,
              ),
            ),
          ),
          const Divider(height: 1),
          // Room List - Made scrollable
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _localRooms.length,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              itemBuilder: (context, index) {
                return _buildRoomRow(index);
              },
              separatorBuilder: (context, index) => const Divider(height: 24),
            ),
          ),
          const Divider(height: 1),
          // Footer with action buttons
          _buildFooter(),
        ],
      ),
    );
  }

  // A widget for each room's configuration
  Widget _buildRoomRow(int index) {
    final room = _localRooms[index];
    final bool canRemoveRoom = _localRooms.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Room ${room["RoomNo"]}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColorPrimary,
              ),
            ),
            if (canRemoveRoom)
              TextButton.icon(
                onPressed: () => _removeRoom(index),
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Colors.red, size: 20),
                label:
                    const Text("Remove", style: TextStyle(color: Colors.red)),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Adults Counter
            Expanded(
              child: _CounterWidget(
                label: 'Adults',
                value: room["Adults"],
                minValue: 1, // A room must have at least 1 adult
                maxValue: 6,
                onChanged: (newValue) {
                  _updateGuestCount(index, adults: newValue);
                },
              ),
            ),
            const SizedBox(width: 16),
            // Children Counter
            Expanded(
              child: _CounterWidget(
                label: 'Children',
                value: room["Children"],
                minValue: 0,
                maxValue: 4,
                onChanged: (newValue) {
                  _updateGuestCount(index, children: newValue);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Footer containing the 'Add Room' and 'Apply' buttons
  Widget _buildFooter() {
    final bool canAddRoom = _localRooms.length < _maxRooms;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add Room Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: canAddRoom ? _addRoom : null,
              icon: const Icon(Icons.add_rounded),
              label: const Text("Add another room"),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
                disabledForegroundColor: Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                      color: canAddRoom
                          ? Colors.grey.shade300
                          : Colors.grey.shade200),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(result: _localRooms),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                "Apply",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// A reusable counter widget for a cleaner design
class _CounterWidget extends StatelessWidget {
  final String label;
  final int value;
  final int minValue;
  final int maxValue;
  final ValueChanged<int> onChanged;

  const _CounterWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minValue = 0,
    this.maxValue = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canDecrement = value > minValue;
    final bool canIncrement = value < maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: textColorSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Decrement Button
              IconButton(
                onPressed: canDecrement ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_rounded),
                color: primaryColor,
                disabledColor: Colors.grey.shade300,
              ),
              // Value
              Text(
                '$value',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: textColorPrimary,
                ),
              ),
              // Increment Button
              IconButton(
                onPressed: canIncrement ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add_rounded),
                color: primaryColor,
                disabledColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ],
    );
  }
}