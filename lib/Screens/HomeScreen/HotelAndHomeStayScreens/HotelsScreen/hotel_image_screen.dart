import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seemytrip/Constants/colors.dart';
import 'package:seemytrip/Screens/Utills/common_text_widget.dart';

class HotelImageScreen extends StatelessWidget {
  final List<Map<String, String>> imageList;

  HotelImageScreen({
    Key? key,
    required List<Map<String, String>>? imageList,
  })  : imageList = imageList ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Hotel Images: $imageList');

    // Group images by name (if name is empty, group as "Other")
    Map<String, List<String>> categorized = {};
    for (var img in imageList) {
      final name = (img['name'] ?? '').trim().isEmpty ? 'Other' : img['name']!;
      final url = img['url'] ?? '';
      if (url.isEmpty) continue;
      categorized.putIfAbsent(name, () => []).add(url);
    }
    final categories = categorized.keys.toList();

    // Use RxString for selected category
    final RxString selectedCategory = (categories.isNotEmpty ? categories.first : '').obs;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: redCA0,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: white, size: 20),
        ),
        title: CommonTextWidget.PoppinsSemiBold(
          text: "Hotel Images",
          color: white,
          fontSize: 18,
        ),
      ),
      body: Obx(() {
        final filteredImages = selectedCategory.value.isEmpty
            ? imageList.map((img) => img['url'] ?? '').where((url) => url.isNotEmpty).toList()
            : categorized[selectedCategory.value] ?? [];

        return Column(
          children: [
            if (categories.isNotEmpty)
              Container(
                height: 48,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, idx) {
                    final cat = categories[idx];
                    return Obx(() => ChoiceChip(
                          label: Text(
                            cat,
                            style: TextStyle(
                              color: selectedCategory.value == cat ? white : black2E2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selected: selectedCategory.value == cat,
                          selectedColor: redCA0,
                          backgroundColor: Colors.grey[200],
                          onSelected: (_) => selectedCategory.value = cat,
                        ));
                  },
                ),
              ),
            Expanded(
              child: (filteredImages.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_not_supported_outlined, size: 48, color: grey717.withOpacity(0.5)),
                          SizedBox(height: 16),
                          Text(
                            filteredImages.isEmpty
                                ? 'No images available for this category'
                                : 'Images not available or failed to load',
                            style: TextStyle(
                              fontSize: 16,
                              color: grey717,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredImages.length,
                      itemBuilder: (context, index) {
                        final url = filteredImages[index];
                        if (url.isEmpty) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                backgroundColor: Colors.black,
                                insetPadding: EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: InteractiveViewer(
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: Colors.grey[300],
                                            height: 300,
                                            width: 300,
                                            child: Icon(Icons.broken_image, color: grey717, size: 60),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.white, size: 28),
                                        onPressed: () => Get.back(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: Icon(Icons.broken_image, color: grey717),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}