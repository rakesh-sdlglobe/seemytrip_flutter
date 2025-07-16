import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelDetailOverview extends StatefulWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailOverview({Key? key, required this.hotelDetail}) : super(key: key);

  @override
  _HotelDetailOverviewState createState() => _HotelDetailOverviewState();
}

class _HotelDetailOverviewState extends State<HotelDetailOverview> {
  bool _isExpanded = false;
  final int _maxLinesCollapsed = 3;

  String _removeHtmlTags(String text) {
    if (text == null) return "";
    
    // Remove common HTML tags
    text = text.replaceAll(RegExp(r'<[^>]*>'), '');
    // Replace HTML entities
    text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");
    
    return text.trim();
  }

  @override
  Widget build(BuildContext context) {
    // Access the description from the nested HotelDetail object
    final hotelDetail = widget.hotelDetail['HotelDetail'] ?? {};
    final overviewText = _removeHtmlTags(hotelDetail['description']?.toString() ?? "No overview available.");
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: redCA0, size: 20),
            SizedBox(width: 8),
            CommonTextWidget.PoppinsMedium(
              text: "Overview",
              color: black2E2,
              fontSize: 17,
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: greyE8E.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  overviewText,
                  style: TextStyle(
                    color: black2E2,
                    fontSize: 14,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: _isExpanded ? null : _maxLinesCollapsed,
                  overflow: TextOverflow.fade,
                ),
              ),
              if (overviewText.split('\n').length > _maxLinesCollapsed)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: greyE8E.withOpacity(0.3)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _isExpanded ? 'Show Less' : 'Show More',
                        style: TextStyle(
                          color: redCA0,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
