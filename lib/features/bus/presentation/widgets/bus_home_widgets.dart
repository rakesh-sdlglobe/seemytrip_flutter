import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBanner extends StatelessWidget {

  const TopBanner({required this.onBackPressed, Key? key}) : super(key: key);
  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
      height: 200, // Slightly sleeker profile
      child: Stack(
        children: <Widget>[
          // Layer 1: Base Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFF5722) // Orange-red for dark theme
                    : const Color(0xFFCA0B0B), // Red for light theme
                  Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFFFF5722) // Orange-red for dark theme
                    : const Color(0xFFCA0B0B), // Red for light theme
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Layer 2: Decorative Abstract Shapes
          _buildDecorativeShapes(context),

          // Layer 3: Glassmorphism Effect with BackdropFilter
          ClipPath(
            clipper: WaveClipper(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),

          // Layer 4: UI Content (Button and Text)
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildGlassBackButton(),
                  const Spacer(),
                  _buildTitleText(),
                  const SizedBox(height: 30), // Adjust bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );

  /// A modern, frosted-glass style back button.
  Widget _buildGlassBackButton() => GestureDetector(
      onTap: onBackPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
          ),
        ),
      ),
    );

  /// The main title text with refined typography.
  Widget _buildTitleText() => RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 26,
          height: 1.3,
          shadows: <Shadow>[
            Shadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        children: const <InlineSpan>[
          TextSpan(
            text: 'Book Bus Tickets\n',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: 'Anywhere, Anytime',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );

  /// Adds subtle, layered circles for visual depth.
  Widget _buildDecorativeShapes(BuildContext context) => Stack(
      children: <Widget>[
        Positioned(
          top: -50,
          left: -80,
          child: CircleAvatar(
            radius: 100,
            backgroundColor: (Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFFF5722) // Orange-red for dark theme
              : const Color(0xFFCA0B0B)).withValues(alpha: 0.1), // Red for light theme
          ),
        ),
        Positioned(
          bottom: -100,
          right: -60,
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Colors.white.withValues(alpha: 0.07),
          ),
        ),
      ],
    );
}

// Custom clipper for a modern wave/curve effect.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path()
    ..lineTo(0, size.height * 0.75)
    ..lineTo(size.width, size.height * 0.6)
    ..lineTo(size.width, 0)
    ..close();

    final Offset firstControlPoint = Offset(size.width * 0.25, size.height * 0.9);
    final Offset firstEndPoint = Offset(size.width * 0.5, size.height * 0.7);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final Offset secondControlPoint = Offset(size.width * 0.75, size.height * 0.5);
    final Offset secondEndPoint = Offset(size.width, size.height * 0.6);
    path..quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy)

    ..lineTo(size.width, 0)
    ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
