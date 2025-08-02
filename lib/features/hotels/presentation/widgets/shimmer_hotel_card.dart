import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHotelCard extends StatelessWidget {
  const ShimmerHotelCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  Container(
                    width: 200,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  // Location placeholder
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 150,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating placeholder
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 40,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price placeholder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 24,
                        color: Colors.white,
                      ),
                      Container(
                        width: 100,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
