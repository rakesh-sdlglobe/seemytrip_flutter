
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/common/cards/app_card.dart';
import '../../../../core/widgets/common/common_app_bar.dart';
import '../../../../core/widgets/lists_widget.dart';
import 'train_search_screen.dart';

// Temporary constants for spacing until theme is fully integrated
const double _kDefaultPadding = 16.0;
const double _kDefaultSpacing = 12.0;
const double _kCardRadius = 12.0;

class TrainScreen extends StatelessWidget {
  TrainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          CommonAppBar(
            title: 'Train',
            subtitle: 'Book Tickets Easily',
            onBackPressed: () => Get.back(),
            action: IconButton(
              icon: Icon(Icons.search, color: colorScheme.onSecondary),
              onPressed: () {},
            ),
          ),
          // Container(
          //   height: 180,
          //   width: double.infinity,
          //   margin: const EdgeInsets.symmetric(horizontal: _kDefaultPadding, vertical: _kDefaultSpacing),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(_kCardRadius * 2),
          //     color: colorScheme.surface,
          //     boxShadow: [
          //       BoxShadow(
          //         color: colorScheme.onSurface.withOpacity(0.1),
          //         blurRadius: 10,
          //         offset: const Offset(0, 4),
          //       ),
          //     ],
          //   ),
          //   child: Center(
          //     child: SvgPicture.asset(
          //       'assets/images/train_illustration.svg',
          //       width: 160,
          //       height: 160,
          //       colorFilter: ColorFilter.mode(
          //         colorScheme.primary.withOpacity(0.8),
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          const SizedBox(height: _kDefaultSpacing * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kDefaultPadding),
            child: Column(
              children: List.generate(
                Lists.bookBusAndTrainList.length,
                (int index) => Padding(
                  padding: const EdgeInsets.only(bottom: _kDefaultSpacing),
                  child: AppCard.withTitle(
                    color: colorScheme.surface,
                    onTap: () => Get.to(() => TrainSearchScreen()),
                    title: Lists.bookBusAndTrainList[index]['text'],
                    titleStyle: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    subtitle: 'Search and book your train tickets',
                    subtitleStyle: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    borderRadius: 12.0,
                    elevation: 2.0,
                    padding: const EdgeInsets.all(16.0),
                    margin: EdgeInsets.zero,
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            Lists.bookBusAndTrainList[index]['image'],
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(
                              colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Lists.bookBusAndTrainList[index]['text'],
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (Lists.bookBusAndTrainList[index]['subtitle'] != null)
                                Text(
                                  Lists.bookBusAndTrainList[index]['subtitle'],
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: _kDefaultSpacing * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Train Information Services',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: _kDefaultSpacing),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: _kDefaultSpacing,
                        crossAxisSpacing: _kDefaultSpacing,
                        childAspectRatio: 1.5,
                        mainAxisExtent: 100, // Fixed height for all grid items
                      ),
                      itemCount: Lists.trainAndBusInformationServiceList.length,
                      itemBuilder: (BuildContext context, int index) => AppCard(
                          color: colorScheme.surface,
                          onTap: () {},
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(_kDefaultSpacing),
                              child: Text(
                                Lists.trainAndBusInformationServiceList[index],
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurface,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                    );
                  },
                ),
              ],
            ),
          ),
            const SizedBox(height: _kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
