import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryView extends StatelessWidget {

  const GalleryView({
    Key? key,
    required this.images,
    required this.initialIndex,
  }) : super(key: key);
  final List<String> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '${initialIndex + 1}/${images.length}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: BouncingScrollPhysics(),
        builder: (BuildContext context, int index) => PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          ),
        itemCount: images.length,
        loadingBuilder: (BuildContext context, ImageChunkEvent? event) => Center(
          child: LoadingAnimationWidget.dotsTriangle(
            color: Colors.red,
            size: 24,
          ),
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
}