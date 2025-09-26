import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelDetailOverview extends StatefulWidget {

  const HotelDetailOverview({Key? key, required this.hotelDetail}) : super(key: key);
  final Map<String, dynamic> hotelDetail;

  @override
  _HotelDetailOverviewState createState() => _HotelDetailOverviewState();
}

class _HotelDetailOverviewState extends State<HotelDetailOverview> {
  bool _isExpanded = false;
  final int _maxLinesCollapsed = 3;

  /// Removes HTML tags and entities from a given text.
  String _removeHtmlTags(String? text) {
    if (text == null) return "";

    return text
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'<p>'), '\n\n')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAllMapped(RegExp(r'<b>(.*?)</b>'), (match) => '### ${match[1]}')
        .replaceAll(RegExp(r'<[/]?p>'), '')
        .trim();
  }

  /// Formats a given text into a list of TextSpans for display.
  List<TextSpan> _formatText(String text, BuildContext context) {
    final lines = text.split('\n');
    final spans = <TextSpan>[];

    for (var line in lines) {
      if (line.startsWith('### ')) {
        spans.add(
          TextSpan(
            text: '${line.substring(3)}\n',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        );
      } else if (line.isNotEmpty) {
        spans.add(
          TextSpan(
            text: line,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.6,
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
    final overviewText = _removeHtmlTags(widget.hotelDetail['Description']?.toString());
    final formattedText = _formatText(overviewText, context);
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: overviewText,
        style: GoogleFonts.poppins(
          fontSize: 14, 
          height: 1.6, 
          color: Theme.of(context).textTheme.bodyMedium?.color
        ),
      ),
      maxLines: _maxLinesCollapsed,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 64);

    final needsReadMore = textPainter.didExceedMaxLines;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.deepPurple.withOpacity(0.2)
                      : Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline, 
                    size: 20, 
                    color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.deepPurple[300]
                      : Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Overview',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Content text
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  height: 1.6,
                ),
                children: formattedText,
              ),
              maxLines: _isExpanded ? null : _maxLinesCollapsed,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            
            // Read More/Less button
            if (needsReadMore) const SizedBox(height: 12),
            if (needsReadMore) 
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? 'Read Less' : 'Read More',
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? const Color(0xFFFF5722) // Orange-red for dark theme
                        : const Color(0xFFCA0B0B), // Red for light theme
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
