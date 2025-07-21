import 'package:flutter/material.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelDetailOverview extends StatefulWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailOverview({Key? key, required this.hotelDetail})
      : super(key: key);

  @override
  _HotelDetailOverviewState createState() => _HotelDetailOverviewState();
}

class _HotelDetailOverviewState extends State<HotelDetailOverview> {
  bool _isExpanded = false;
  final int _maxLinesCollapsed = 3;

  /// Removes HTML tags and entities from a given text.
  String _removeHtmlTags(String? text) {
    if (text == null) return "";

    text = text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'<p>'), '\n\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAllMapped(RegExp(r'<b>(.*?)</b>'), (match) => '### ${match[1]}')
        .replaceAll(RegExp(r'<[/]?p>'), '');

    return text.trim();
  }

  /// Formats a given text into a list of TextSpans for display.
  List<TextSpan> _formatText(String text) {
    final lines = text.split('\n');
    final spans = <TextSpan>[];

    for (var line in lines) {
      if (line.startsWith('### ')) {
        spans.add(
          TextSpan(
            text: line.substring(3) + '\n',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      } else if (line.isNotEmpty) {
        spans.add(
          TextSpan(
            text: line,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              letterSpacing: 0.1,
            ),
          ),
        );
      }
      if (line != lines.last) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final overviewText =
        _removeHtmlTags(widget.hotelDetail['Description']?.toString());

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: redCA0, size: 24),
              SizedBox(width: 12),
              Text(
                "Hotel Overview",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: black2E2,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: _formatText(overviewText),
                    ),
                    style: TextStyle(
                      color: black2E2,
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                    maxLines: _isExpanded ? null : _maxLinesCollapsed,
                    overflow: TextOverflow.fade,
                  ),
                  if (overviewText.split('\n').length > _maxLinesCollapsed)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: greyE8E.withOpacity(0.1)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _isExpanded ? 'Show Less' : 'Show More',
                            style: TextStyle(
                              color: redCA0,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
