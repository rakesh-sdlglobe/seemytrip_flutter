import 'package:get/get.dart';

class HotelImageController extends GetxController {
  final RxString selectedCategory = 'All Photos'.obs;
  final RxMap<String, List<String>> categorizedImages = <String, List<String>>{}.obs;
  final RxList<String> allImages = <String>[].obs;
  final RxList<String> categories = <String>[].obs;

  void initializeImages(List<Map<String, String>> imageList) {
    categorizedImages.clear();
    allImages.clear();
    
    for (var img in imageList) {
      final name = (img['name'] ?? '').trim().isEmpty ? 'All Photos' : img['name']!;
      final url = img['url'] ?? '';
      if (url.isEmpty) continue;
      
      if (!categorizedImages.containsKey(name)) {
        categorizedImages[name] = [];
      }
      categorizedImages[name]!.add(url);
      allImages.add(url);
    }
    
    // Update categories list
    categories.value = ['All Photos']..addAll(
      categorizedImages.keys.where((key) => key != 'All Photos').toList()
    );
    
    // Trigger UI update
    update();
  }

  List<String> get filteredImages => selectedCategory.value == 'All Photos'
      ? allImages
      : categorizedImages[selectedCategory.value] ?? [];

  void selectCategory(String category) {
    selectedCategory.value = category;
    update();
  }
}
