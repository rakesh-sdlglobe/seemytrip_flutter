import 'package:flutter/material.dart';

class TravelClassAndTravelerSelector extends StatefulWidget {
  final String travelClass;
  final int travelers;
  final Function(String) onClassChanged;
  final Function(int) onTravelerCountChanged;

  TravelClassAndTravelerSelector({
    Key? key,
    required this.travelClass,
    required this.travelers,
    required this.onClassChanged,
    required this.onTravelerCountChanged,
  }) : super(key: key);

  @override
  _TravelClassAndTravelerSelectorState createState() =>
      _TravelClassAndTravelerSelectorState();
}

class _TravelClassAndTravelerSelectorState
    extends State<TravelClassAndTravelerSelector> {
  late String currentTravelClass;
  late int currentTravelers;

  @override
  void initState() {
    super.initState();
    currentTravelClass = widget.travelClass;
    currentTravelers = widget.travelers;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                color: Colors.redAccent, // Header color
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Class and Travelers",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text color
                ),
              ),
            ),
            SizedBox(height: 20), // Space after header
            DropdownButtonFormField<String>(
              value: currentTravelClass,
              isExpanded: true, // Expand to fill dialog width
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200], // Light grey background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border
                ),
              ),
              items: <String>['Economy', 'Business', 'First Class']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    currentTravelClass = newValue;
                  });
                  widget.onClassChanged(newValue);
                }
              },
            ),
            SizedBox(height: 20), // Space after dropdown
            Text(
              "Number of Travelers:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600, // Semi-bold for emphasis
                color: Colors.black54, // Subtle color for description
              ),
            ),
            SizedBox(height: 10), // Space before travelers counter
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentTravelers > 1) {
                      setState(() {
                        currentTravelers--;
                      });
                      widget.onTravelerCountChanged(currentTravelers);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    padding: EdgeInsets.all(12), // Button color
                  ),
                  child: Icon(Icons.remove),
                ),
                SizedBox(width: 20), // Space between buttons
                Text(
                  currentTravelers.toString(),
                  style: TextStyle(fontSize: 24), // Larger font for count
                ),
                SizedBox(width: 20), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentTravelers++;
                    });
                    widget.onTravelerCountChanged(currentTravelers);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    padding: EdgeInsets.all(12), // Button color
                  ),
                  child: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20), // Space before close button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.blueAccent, // Color for close button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
