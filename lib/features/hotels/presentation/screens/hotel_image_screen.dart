import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:seemytrip/features/hotels/presentation/controllers/hotel_image_controller.dart';

import '../../../../core/utils/colors.dart';

class HotelImageScreen extends StatefulWidget {
  final List<Map<String, String>> imageList;

  const HotelImageScreen({
    Key? key,
    required this.imageList,
  }) : super(key: key);

  @override
  _HotelImageScreenState createState() => _HotelImageScreenState();
}

class _HotelImageScreenState extends State<HotelImageScreen> {
  late final HotelImageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(HotelImageController());
    controller.initializeImages(widget.imageList);
  }

  @override
  void dispose() {
    Get.delete<HotelImageController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE8E8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFFD32F2F),
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Hotel Gallery',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF666666)),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: GetBuilder<HotelImageController>(
        builder: (HotelImageController controller) {
          return Column(
            children: <Widget>[
              // Category Chips
              if (controller.categories.isNotEmpty)
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (BuildContext context, int idx) {
                      final String category = controller.categories[idx];
                      final bool isSelected = controller.selectedCategory.value == category;
                      return GestureDetector(
                        onTap: () => controller.selectCategory(category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFD32F2F) : const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: const Color(0x40D32F2F),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              color: isSelected ? Colors.white : const Color(0xFF666666),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              // Image Grid
              Expanded(
                child: controller.filteredImages.isEmpty
                    ? _buildEmptyState()
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: controller.filteredImages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String url = controller.filteredImages[index];
                          return _buildImageItem(context, url);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );

  Widget _buildImageItem(BuildContext context, String imageUrl) => GestureDetector(
      onTap: () => _showFullScreenImage(context, imageUrl),
      child: Hero(
        tag: 'image_$imageUrl',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, String url) => Container(
                color: Color(0xFFF5F5F5),
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: redCA0,
                    size: 40,
                  ),
                ),
              ),
              errorWidget: (BuildContext context, String url, Object error) => Container(
                color: Color(0xFFF5F5F5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.broken_image_rounded,
                          color: Color(0xFFCCCCCC), size: 40),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load',
                        style: GoogleFonts.inter(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: GestureDetector(
            onVerticalDragEnd: (DragEndDetails details) {
              if (details.primaryVelocity! > 100) {
                Navigator.of(context).pop();
              }
            },
            child: Center(
              child: Hero(
                tag: 'image_$imageUrl',
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  initialScale: PhotoViewComputedScale.contained,
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                  loadingBuilder: (BuildContext context, ImageChunkEvent? event) => Center(
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: redCA0,
                      size: 40,
                    ),
                  ),
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.broken_image_rounded,
                            color: Colors.white54, size: 60),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      barrierColor: Colors.black87,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildEmptyState() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            'No photos available',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'There are no images to display for this category',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
}