import 'package:flutter/material.dart';
import '../../core/widgets/common/buttons/text_button.dart';
import '../../core/widgets/common/cards/app_card.dart';
import '../../core/widgets/shared/app_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppAppBar(
        title: 'SeeMyTrip',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );

  Widget _buildBody(BuildContext context) => SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16.0),
          _buildSearchBar(context),
          const SizedBox(height: 24.0),
          _buildPopularDestinations(context),
          const SizedBox(height: 24.0),
          _buildTravelDeals(context),
          const SizedBox(height: 24.0),
          _buildCallToAction(context),
        ],
      ),
    );

  Widget _buildSearchBar(BuildContext context) => AppCard(
      onTap: () {
        // Handle search tap
      },
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8.0),
          Text(
            'Where do you want to go?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );

  Widget _buildPopularDestinations(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Destinations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButtonX(
              text: 'See All',
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildDestinationCard(
                context,
                'Paris',
                'France',
                'https://example.com/paris.jpg',
              ),
              const SizedBox(width: 12.0),
              _buildDestinationCard(
                context,
                'Tokyo',
                'Japan',
                'https://example.com/tokyo.jpg',
              ),
              const SizedBox(width: 12.0),
              _buildDestinationCard(
                context,
                'New York',
                'USA',
                'https://example.com/nyc.jpg',
              ),
            ],
          ),
        ),
      ],
    );

  Widget _buildDestinationCard(
    BuildContext context,
    String city,
    String country,
    String imageUrl,
  ) => AppCard(
      width: 150,
      padding: EdgeInsets.zero,
      onTap: () {
        // Navigate to destination details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for image
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
            ),
            child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  city,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  country,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  Widget _buildTravelDeals(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Best Travel Deals',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12.0),
        AppCard(
          onTap: () {
            // Navigate to deal details
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder for deal image
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Center(child: Icon(Icons.image, size: 40, color: Colors.grey)),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Summer Vacation Special',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16.0, color: Colors.grey),
                  const SizedBox(width: 4.0),
                  Text(
                    'Bali, Indonesia',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.0),
                  ),
                  const Spacer(),
                  Text(
                    '\$599',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

  Widget _buildCallToAction(BuildContext context) => Column(
      children: [
        const Text(
          'Ready for your next adventure?',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        TextButtonX(
          text: 'Explore Destinations',
          onPressed: () {
            // Navigate to explore page
          },
        ),
        const SizedBox(height: 8.0),
        TextButtonX(
          text: 'View All Deals',
          onPressed: () {
            // Navigate to deals page
          },
        ),
      ],
    );
}
