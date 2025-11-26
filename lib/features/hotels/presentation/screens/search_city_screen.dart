import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controllers/hotel_controller.dart';
import 'hotel_and_home_stay_tab_screen.dart';

// --- Design Tokens --- (Now using theme-aware colors)
// These constants will be replaced with theme-aware alternatives throughout the file

// --- Spacing ---
const double defaultRadius = 16.0;
const double defaultPadding = 20.0;
const double itemSpacing = 12.0;

// --- Typography --- (Will be replaced with theme-aware styles)

// --- Animation Durations ---
const Duration defaultAnimationDuration = Duration(milliseconds: 300);



class SearchCityScreen extends StatelessWidget {
  SearchCityScreen({Key? key}) : super(key: key);

  final SearchCityController controller = Get.put(SearchCityController());
  final TextEditingController textController = TextEditingController();

  /// Shows a modern bottom sheet search modal with smooth animations
  void _showSearchModal(BuildContext context) {
    textController.text = controller.searchText.value;
    final ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (BuildContext context) => AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          child: DraggableScrollableSheet(
            initialChildSize: 0.92,
            minChildSize: 0.5,
            maxChildSize: 0.98,
            snap: true,
            builder: (_, ScrollController scrollController) => Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    // Drag Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    // Header with title and close button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Search Destination',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 24),
                            onPressed: () => Navigator.pop(context),
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildSearchTextField(context),
                    ),

                    const SizedBox(height: 8),

                    // Results or Empty State
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return _buildLoadingState(context);
                        }
                        
                        final RxList<City> list = controller.filteredCities;
                        if (list.isEmpty) {
                          return _buildEmptyState(context);
                        }

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 12, bottom: 24),
                          itemCount: list.length,
                          itemBuilder: (_, int index) =>
                              _buildSearchResultTile(context, list[index]),
                        );
                      }),
                    ),
                  ],
                ),
              ),
          ),
        ),
    );
  }

  // Loading state widget
  Widget _buildLoadingState(BuildContext context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching destinations...',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Current Location Card
              _buildOptionTile(
                context: context,
                icon: Icons.my_location_rounded,
                title: 'Use Current Location',
                subtitle: 'Find places near you',
                onTap: () {
                  // Location permission and logic
                },
              ),
              
              // Selected City Card
              _buildOptionTile(
                context: context,
                icon: Icons.location_city_rounded,
                title: 'Destination',
                subtitle: controller.selectedCity.value?.toString() ??
                    'Search for a city or hotel',
                onTap: () => _showSearchModal(context),
                showClearButton: controller.selectedCity.value != null,
                onClear: () => controller.selectedCity.value = null,
              ),
              
              const SizedBox(height: 8),

              // Recent Searches Section
              Obx(() {
                final bool hasRecentSearches = controller.recentSearches.isNotEmpty;
                return hasRecentSearches
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 24,
                          //     vertical: 12,
                          //   ),
                          //   child: Text(
                          //     'Recent Searches',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w600,
                          //       color: textPrimary,
                          //     ),
                          //   ),
                          // ),
                          _buildRecentSearchChips(context),
                          const SizedBox(height: 8),
                        ],
                      )
                    : const SizedBox.shrink();
              }),

              // Popular Destinations Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Text(
                  'Popular Destinations',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ),
              
              // Popular Destinations Grid
              _buildPopularDestinations(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );

  // Popular Destinations Grid
  Widget _buildPopularDestinations() {
    final List<Map<String, String>> popularDestinations = <Map<String, String>>[
      <String, String>{'city': 'Mumbai', 'country': 'India'},
      <String, String>{'city': 'Goa', 'country': 'India'},
      <String, String>{'city': 'Delhi', 'country': 'India'},
      <String, String>{'city': 'Bangalore', 'country': 'India'},
      <String, String>{'city': 'Jaipur', 'country': 'India'},
      <String, String>{'city': 'Kerala', 'country': 'India'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: popularDestinations.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, String> destination = popularDestinations[index];
        return _buildDestinationCard(
          context,
          destination['city']!,
          destination['country']!,
        );
      },
    );
  }
  
  // Destination Card
  Widget _buildDestinationCard(BuildContext context, String city, String country) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final City cityObj =
              City(id: city.toLowerCase(), name: city, country: country);
          controller.selectCity(cityObj);
          Get.to(() => HotelAndHomeStayTabScreen());
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              // Background Image Placeholder (Replace with actual image)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey[700]
                    : Colors.grey.shade100,
                ),
              ),
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // City Name
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      country,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  /// Builds a modern AppBar with a clean design and search functionality
  AppBar _buildAppBar(BuildContext context) => AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.5,
      shadowColor: Theme.of(context).shadowColor.withOpacity(0.05),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey[800]
              : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
            size: 18,
          ),
        ),
        onPressed: () => Get.back(),
        splashRadius: 24,
      ),
      title: Text(
        'Search City',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
      ),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey[800]
                : const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 20,
            ),
          ),
          onPressed: () {
            // Handle filter button press
          },
          splashRadius: 24,
        ),
        const SizedBox(width: 8),
      ],
    );

  /// A modern, customizable option tile with smooth hover effects
  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showClearButton = false,
    VoidCallback? onClear,
  }) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Builder(
                      builder: (BuildContext context) {
                        if (showClearButton) {
                          return Obx(() {
                            final City? selectedCity = controller.selectedCity.value;
                            return Text(
                              selectedCity?.toString() ?? subtitle,
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context).textTheme.bodySmall?.color,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          });
                        }
                        return Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (showClearButton)
                IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    size: 20,
                  ),
                  onPressed: onClear,
                  splashRadius: 20,
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
            ],
          ),
        ),
      ),
    );

  /// Builds a modern horizontal list of recent search chips
  Widget _buildRecentSearchChips(BuildContext context) => Obx(() {
      final RxList<City> recents = controller.recentSearches;
      if (recents.isEmpty) return const SizedBox.shrink();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20, right: 20),
              scrollDirection: Axis.horizontal,
              itemCount: recents.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, int i) {
                final City city = recents[i];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.selectCity(city);
                      Get.to(() => HotelAndHomeStayTabScreen());
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[800]
                          : const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.history_rounded,
                            size: 16,
                            color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            city.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });

  /// A clean search text field for the modal.
  Widget _buildSearchTextField(BuildContext context) => Obx(
      () => TextField(
        controller: textController,
        onChanged: (String value) => controller.searchText.value = value,
        autofocus: true,
        style: TextStyle(
          fontSize: 16, 
          height: 1.4,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: 'Search for a city or hotel',
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Icon(
              Icons.search_rounded,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
              size: 24,
            ),
          ),
          suffixIcon: controller.searchText.isNotEmpty
              ? AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    key: ValueKey(controller.searchText),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                      size: 22,
                    ),
                    onPressed: () {
                      textController.clear();
                      controller.searchText.value = '';
                      FocusScope.of(Get.context!).unfocus();
                    },
                    splashRadius: 20,
                  ),
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.grey[800]
            : Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
      ),
    );

  /// A modern tile for search results with smooth animations
  Widget _buildSearchResultTile(BuildContext context, City city) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          controller.selectCity(city);
          Get.back(); // Close the modal
          Get.to(() => HotelAndHomeStayTabScreen());
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
        highlightColor: Theme.of(context).primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _highlightedText(context, city.name, controller.searchText.value),
                    if (city.country.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        city.country,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );

  /// A rich text widget that bolds the matching search query.
  RichText _highlightedText(BuildContext context, String text, String query) {
    if (query.isEmpty) {
      return RichText(
          text: TextSpan(
              text: text,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color, 
                  fontWeight: FontWeight.w500)));
    }
    final int matches = text.toLowerCase().indexOf(query.toLowerCase());
    if (matches == -1) {
      return RichText(
          text: TextSpan(
              text: text,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color, 
                  fontWeight: FontWeight.w500)));
    }

    final String beforeMatch = text.substring(0, matches);
    final String match = text.substring(matches, matches + query.length);
    final String afterMatch = text.substring(matches + query.length);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color, 
          fontFamily: 'Poppins'
        ),
        children: <InlineSpan>[
          TextSpan(text: beforeMatch),
          TextSpan(
              text: match,
              style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }


  /// A modern empty state widget with animations
  Widget _buildEmptyState(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: controller.searchText.value.isEmpty
                  ? Icon(
                      Icons.explore_rounded,
                      size: 80,
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                    )
                  : Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Theme.of(context).brightness == Brightness.dark 
                        ? Colors.grey.shade600
                        : Colors.grey.shade300,
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.searchText.value.isEmpty
                  ? 'Where to next?'
                  : 'No results found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.headlineSmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              controller.searchText.value.isEmpty
                  ? 'Search for cities, hotels, or areas to find your perfect stay.'
                  : 'We couldn\'t find any matches for "${controller.searchText.value}"',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (controller.searchText.value.isNotEmpty) ...<Widget>[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  textController.clear();
                  controller.searchText.value = '';
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Clear search',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
}
