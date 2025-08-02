import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/hotel_controller.dart';
import 'hotel_and_home_stay_tab_screen.dart';

// --- Design Tokens ---
const Color primaryColor = Color(0xFFCA0B0B);
const Color primaryLight = Color(0xFFFFEBEE);
const Color surfaceColor = Color(0xFFF8F9FA);
const Color surfaceElevated = Color(0xFFFFFFFF);
const Color textPrimary = Color(0xFF1A1A1A);
const Color textSecondary = Color(0xFF666666);
const Color borderColor = Color(0xFFEEEEEE);

// --- Spacing ---
const double defaultRadius = 16.0;
const double defaultPadding = 20.0;
const double itemSpacing = 12.0;

// --- Typography ---
final TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: textPrimary,
  letterSpacing: -0.5,
);

final TextStyle subtitleStyle = TextStyle(
  fontSize: 14,
  color: textSecondary,
  height: 1.4,
);

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
                        color: Colors.grey.shade400,
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
                      child: _buildSearchTextField(),
                    ),

                    const SizedBox(height: 8),

                    // Results or Empty State
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return _buildLoadingState();
                        }
                        
                        final RxList<City> list = controller.filteredCities;
                        if (list.isEmpty) {
                          return _buildEmptyState();
                        }

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(top: 12, bottom: 24),
                          itemCount: list.length,
                          itemBuilder: (_, int index) =>
                              _buildSearchResultTile(list[index]),
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
  Widget _buildLoadingState() => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching destinations...',
            style: subtitleStyle.copyWith(
              color: textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: surfaceElevated,
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
                icon: Icons.my_location_rounded,
                title: 'Use Current Location',
                subtitle: 'Find places near you',
                onTap: () {
                  // Location permission and logic
                },
              ),
              
              // Selected City Card
              _buildOptionTile(
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
                          _buildRecentSearchChips(),
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
                    color: textPrimary,
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
          destination['city']!,
          destination['country']!,
        );
      },
    );
  }
  
  // Destination Card
  Widget _buildDestinationCard(String city, String country) => Material(
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
                  color: Colors.grey.shade100,
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
      backgroundColor: surfaceElevated,
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.05),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: textPrimary,
            size: 18,
          ),
        ),
        onPressed: () => Get.back(),
        splashRadius: 24,
      ),
      title: Text(
        'Search City',
        style: headingStyle.copyWith(fontSize: 22),
      ),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: textPrimary,
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
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
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
                                color: textSecondary,
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
                            color: textSecondary,
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
                  icon: const Icon(
                    Icons.close_rounded,
                    color: textSecondary,
                    size: 20,
                  ),
                  onPressed: onClear,
                  splashRadius: 20,
                )
              else
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: textSecondary,
                ),
            ],
          ),
        ),
      ),
    );

  /// Builds a modern horizontal list of recent search chips
  Widget _buildRecentSearchChips() => Obx(() {
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
                color: textPrimary,
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
                        color: surfaceColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.history_rounded,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            city.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textPrimary,
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
  Widget _buildSearchTextField() => Obx(
      () => TextField(
        controller: textController,
        onChanged: (String value) => controller.searchText.value = value,
        autofocus: true,
        style: const TextStyle(fontSize: 16, height: 1.4),
        decoration: InputDecoration(
          hintText: 'Search for a city or hotel',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade600,
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
                      color: Colors.grey.shade600,
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
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: primaryColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
        ),
      ),
    );

  /// A modern tile for search results with smooth animations
  Widget _buildSearchResultTile(City city) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          controller.selectCity(city);
          Get.back(); // Close the modal
          Get.to(() => HotelAndHomeStayTabScreen());
        },
        borderRadius: BorderRadius.circular(12),
        splashColor: primaryColor.withOpacity(0.1),
        highlightColor: primaryColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _highlightedText(city.name, controller.searchText.value),
                    if (city.country.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        city.country,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );

  /// A rich text widget that bolds the matching search query.
  RichText _highlightedText(String text, String query) {
    if (query.isEmpty) {
      return RichText(
          text: TextSpan(
              text: text,
              style: const TextStyle(
                  color: textPrimary, fontWeight: FontWeight.w500)));
    }
    final int matches = text.toLowerCase().indexOf(query.toLowerCase());
    if (matches == -1) {
      return RichText(
          text: TextSpan(
              text: text,
              style: const TextStyle(
                  color: textPrimary, fontWeight: FontWeight.w500)));
    }

    final String beforeMatch = text.substring(0, matches);
    final String match = text.substring(matches, matches + query.length);
    final String afterMatch = text.substring(matches + query.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: textSecondary, fontFamily: 'Poppins'),
        children: <InlineSpan>[
          TextSpan(text: beforeMatch),
          TextSpan(
              text: match,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: textPrimary)),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }

  /// A header for different sections on the main screen.
  Padding _buildSectionHeader(String title, String assetName) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(assetName,
              colorFilter:
                  const ColorFilter.mode(textSecondary, BlendMode.srcIn),
              width: 16),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );

  /// A modern empty state widget with animations
  Widget _buildEmptyState() => Center(
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
                      color: Colors.grey.shade300,
                    )
                  : Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
            ),
            const SizedBox(height: 24),
            Text(
              controller.searchText.value.isEmpty
                  ? 'Where to next?'
                  : 'No results found',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPrimary,
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
                color: Colors.grey.shade600,
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
                  backgroundColor: primaryColor,
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
