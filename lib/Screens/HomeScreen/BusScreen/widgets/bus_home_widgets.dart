import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';

class TopBanner extends StatelessWidget {
  final VoidCallback onBackPressed;

  const TopBanner({Key? key, required this.onBackPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 155,
          width: Get.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [redCA0, Colors.red.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              const Positioned(
                left: 24,
                top: 68,
                child: Text(
                  "Book Bus Tickets\nAnywhere, Anytime",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),
              Positioned(
                right: 24,
                bottom: 0,
                child: Icon(Icons.directions_bus, 
                    color: Colors.white.withOpacity(0.2), size: 90),
              ),
            ],
          ),
        ),
        Positioned(
          top: 42,
          left: 12,
          child: InkWell(
            onTap: onBackPressed,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            ),
          ),
        ),
      ],
    );
  }
}

class TrustIndicator extends StatelessWidget {
  const TrustIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, color: redCA0, size: 20),
          SizedBox(width: 8),
          Text(
            'Trusted by ',
            style: TextStyle(color: redCA0, fontSize: 16),
          ),
          Text(
            '10 crore+ ',
            style: TextStyle(
              color: redCA0,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Indian travellers ',
            style: TextStyle(color: redCA0, fontSize: 16),
          ),
          Text('🇮🇳', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: redCA0.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: redCA0,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.percent, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Text(
            'Save upto ₹300* on Bus Bookings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: redCA0,
            ),
          ),
        ],
      ),
    );
  }
}

class PromoSection extends StatelessWidget {
  const PromoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [redCA0.withOpacity(0.08), Colors.red[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.red[100],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Save up to',
                  style: TextStyle(fontSize: 16, color: redCA0),
                ),
                Text(
                  '₹300*',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: redCA0,
                  ),
                ),
                Text(
                  'on your Bus Booking',
                  style: TextStyle(fontSize: 14, color: redCA0),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: redCA0, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'IX300',
                  style: TextStyle(
                    color: redCA0,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: redCA0,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Copy',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SpecialOffersHeader extends StatelessWidget {
  final VoidCallback onViewAll;

  const SpecialOffersHeader({Key? key, required this.onViewAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Special Offers',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: redCA0,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: redCA0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'View All',
                style: TextStyle(
                  color: redCA0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
