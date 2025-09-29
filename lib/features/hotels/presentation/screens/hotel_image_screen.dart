// ignore_for_file: library_private_types_in_public_api, avoid_redundant_argument_values

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/hotel_image_controller.dart';

class HotelImageScreen extends StatefulWidget {

  const HotelImageScreen({
    required this.imageList, Key? key,
  }) : super(key: key);
  final List<Map<String, String>> imageList;

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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFD),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
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
                color: AppColors.redCA0.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.redCA0,
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
            color: isDark ? AppColors.textPrimaryDark : const Color(0xFF1A1A1A),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close_rounded, 
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF666666)
            ),
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
                            color: isSelected 
                                ? AppColors.redCA0 
                                : (isDark ? AppColors.cardDark : const Color(0xFFF5F5F5)),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: isSelected
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: AppColors.redCA0.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                          ),
                          child: Text(
                            category,
                            style: GoogleFonts.inter(
                              color: isSelected 
                                  ? Colors.white 
                                  : (isDark ? AppColors.textSecondaryDark : const Color(0xFF666666)),
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
                    ? _buildEmptyState(isDark)
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
                          return _buildImageItem(context, url, isDark);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageItem(BuildContext context, String imageUrl, bool isDark) => GestureDetector(
      onTap: () => _showFullScreenImage(context, imageUrl),
      child: Hero(
        tag: 'image_$imageUrl',
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: isDark 
                    ? AppColors.black262.withValues(alpha: 0.3)
                    : Colors.black.withOpacity(0.1),
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
                color: isDark ? AppColors.cardDark : const Color(0xFFF5F5F5),
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: AppColors.redCA0,
                    size: 40,
                  ),
                ),
              ),
              errorWidget: (BuildContext context, String url, Object error) => Container(
                color: isDark ? AppColors.cardDark : const Color(0xFFF5F5F5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.broken_image_rounded,
                        color: isDark ? AppColors.textSecondaryDark : const Color(0xFFCCCCCC), 
                        size: 40
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load',
                        style: GoogleFonts.inter(
                          color: isDark ? AppColors.textSecondaryDark : const Color(0xFF999999),
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
                      color: AppColors.redCA0,
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

  Widget _buildEmptyState(bool isDark) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: isDark ? AppColors.textSecondaryDark : const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 16),
          Text(
            'No photos available',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF666666),
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
                color: isDark ? AppColors.textSecondaryDark : const Color(0xFF999999),
              ),
            ),
          ),
        ],
      ),
    );
}