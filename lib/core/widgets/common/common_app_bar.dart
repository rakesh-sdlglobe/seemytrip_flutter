import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class CommonAppBar extends StatelessWidget {

  const CommonAppBar({
    required this.title, 
    Key? key,
    this.subtitle,
    this.onBackPressed,
    this.backgroundColor = AppColors.redCA0, // Default red color
    this.textColor = Colors.white,
    this.showBackButton = true,
    this.action,
    this.height = 169, // Slightly increased from 140
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final Color textColor;
  final bool showBackButton;
  final Widget? action;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: height, // Use the provided height
      child: Stack(
        children: <Widget>[
          // Layer 1: Base Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  backgroundColor,
                  Color.lerp(backgroundColor, Colors.black, 0.2) ?? backgroundColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Layer 2: Decorative Abstract Shapes
          _buildDecorativeShapes(),

          // Layer 3: Glassmorphism Effect with BackdropFilter
          ClipPath(
            clipper: _WaveClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: textColor.withOpacity(0.08),
              ),
            ),
          ),

          // Layer 4: UI Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showBackButton) _buildGlassBackButton(context),
                      const Spacer(),
                      if (action != null) action!,
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTitleText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildGlassBackButton(BuildContext context) => GestureDetector(
        onTap: onBackPressed ?? () => Navigator.of(context).pop(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: textColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: textColor.withOpacity(0.2)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textColor,
                size: 20,
              ),
            ),
          ),
        ),
      );

  Widget _buildTitleText() => RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            height: 1.3,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          children: [
            TextSpan(
              text: '$title\n',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (subtitle != null)
              TextSpan(
                text: subtitle,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
              ),
          ],
        ),
      );

  Widget _buildDecorativeShapes() => Stack(
        children: [
          Positioned(
            top: -40,
            left: -60,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: textColor.withOpacity(0.1),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: textColor.withOpacity(0.07),
            ),
          ),
        ],
      );
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
      ..lineTo(0, size.height * 0.75)
      ..lineTo(size.width, size.height * 0.6)
      ..lineTo(size.width, 0)
      ..close();

    final Offset firstControlPoint = Offset(size.width * 0.25, size.height * 0.9);
    final Offset firstEndPoint = Offset(size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final Offset secondControlPoint = Offset(size.width * 0.75, size.height * 0.5);
    final Offset secondEndPoint = Offset(size.width, size.height * 0.6);
    path
      ..quadraticBezierTo(
        secondControlPoint.dx,
        secondControlPoint.dy,
        secondEndPoint.dx,
        secondEndPoint.dy,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
