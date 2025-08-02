import 'package:flutter/material.dart';
import 'package:seemytrip/core/utils/colors.dart';
import 'package:seemytrip/core/widgets/common_text_widget.dart';

class HotelDetailAttractions extends StatelessWidget {
  final Map<String, dynamic> hotelDetail;

  const HotelDetailAttractions({Key? key, required this.hotelDetail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.place_outlined, color: redCA0, size: 20),
            SizedBox(width: 8),
            CommonTextWidget.PoppinsMedium(
              text: "Nearby Attractions",
              color: black2E2,
              fontSize: 17,
            ),
          ],
        ),
        SizedBox(height: 10),
        hotelDetail['Attractions'] != null &&
                hotelDetail['Attractions'] is List &&
                (hotelDetail['Attractions'] as List).isNotEmpty
            ? Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: greyE8E),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...((hotelDetail['Attractions'] as List).map<Widget>((attr) {
                      final String plainText = attr
                          .toString()
                          .replaceAll(RegExp(r'<[^>]*>'), '')
                          .replaceAll('&nbsp;', ' ')
                          .replaceAll('&amp;', '&')
                          .replaceAll('&rsquo;', "'")
                          .replaceAll('&quot;', '"')
                          .replaceAll('&ndash;', '-')
                          .replaceAll('&mdash;', '—')
                          .replaceAll('&hellip;', '…')
                          .replaceAll('&lsquo;', "'")
                          .replaceAll('&ldquo;', '"')
                          .replaceAll('&rdquo;', '"')
                          .replaceAll('&lt;', '<')
                          .replaceAll('&gt;', '>')
                          .replaceAll('&apos;', "'")
                          .replaceAll('&eacute;', 'é')
                          .replaceAll('&ocirc;', 'ô')
                          .replaceAll('&agrave;', 'à')
                          .replaceAll('&aacute;', 'á')
                          .replaceAll('&uuml;', 'ü')
                          .replaceAll('&ouml;', 'ö')
                          .replaceAll('&iacute;', 'í')
                          .replaceAll('&oacute;', 'ó')
                          .replaceAll('&uacute;', 'ú')
                          .replaceAll('&egrave;', 'è')
                          .replaceAll('&ecirc;', 'ê')
                          .replaceAll('&euml;', 'ë')
                          .replaceAll('&ccedil;', 'ç')
                          .replaceAll('&ntilde;', 'ñ')
                          .replaceAll('&amp;', '&');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: redCA0),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                plainText,
                                style: TextStyle(
                                  color: black2E2,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList())
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  "No nearby attractions listed.",
                  style: TextStyle(
                    color: grey717,
                    fontSize: 14,
                  ),
                ),
              ),
      ],
    );
  }
}
