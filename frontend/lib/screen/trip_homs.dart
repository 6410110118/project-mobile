import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/repositories/trip_repository.dart';
import 'package:frontend/screen/seach_page.dart';
import 'package:frontend/widgets/detail_page.dart';
import 'package:intl/intl.dart';

import '../bloc/export_bloc.dart';
import '../models/models.dart';

class TripHome extends StatefulWidget {
  @override
  _TripHomeState createState() => _TripHomeState();
}

class _TripHomeState extends State<TripHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TripBloc(tripRepository: TripRepository())
              ..add(FetchTripEvent()),
          ),
          
        ],
        child: BlocBuilder<TripBloc, TripState>(builder: (context, tripState) {
          if (tripState is TripLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (tripState is TripLoaded) {
            final List<Trip> trips = tripState.trips.cast<Trip>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 25.0 ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // User Profile with Username
                            BlocBuilder<GetMeBloc, GetMeState>(
                              builder: (context, userState) {
                                if (userState is GetMeLoaded) {
                                  return Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage:
                                            userState.user.imageData != null
                                                ? MemoryImage(
                                                    userState.user.imageData!)
                                                : AssetImage('assets/start.jpg')
                                                    as ImageProvider,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Hello ${userState.user.username}!', // Display username
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  );
                                } else if (userState is GetMeLoading) {
                                  return CircularProgressIndicator();
                                } else {
                                  return CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person),
                                  );
                                }
                              },
                            ),

                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchPage(trips: trips),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        // เพิ่ม SizedBox เพื่อขยับลงด้านล่าง
                        SizedBox(height: 10), // ปรับค่าตามที่ต้องการ
                      ],
                    ),
                  ),

                

                  // Story Menu
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _buildStoryItems(),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Recommend Trips Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Recommend trips',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Recommended Trips List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: List.generate(trips.length, (index) {
                        final trip = trips[index];
                        return _buildTripCard(trip);
                      }),
                    ),
                  ),
                ],
              ),
            );
          } else if (tripState is TripError) {
            return Center(child: Text(tripState.message));
          }
          return Center(child: Text('No trips found'));
        }),
      ),
    );
  }

  // Story Items
  List<Widget> _buildStoryItems() {
    List<Map<String, String>> stories = [
      {'image': 'assets/images/start.jpg'},
      {'image': 'assets/images/start.jpg'},
      {'image': 'assets/images/start.jpg'},
      {'image': 'assets/images/start.jpg'},
    ];

    return stories.map((story) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 90,
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(story['image']!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();
  }

  // Card for displaying each trip
  Widget _buildTripCard(Trip trip) {
    DateTime startTime = trip.starttime!;
    DateTime endTime = trip.endtime!;

    // Format date as needed
    String formattedStartTime = DateFormat('dd MMM yyyy').format(startTime);
    String formattedEndTime = DateFormat('dd MMM yyyy').format(endTime);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TripDetailPage(trip: trip),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trip Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                trip.imageUrl ?? 'https://via.placeholder.com/300',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripName ?? 'No Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$formattedStartTime - $formattedEndTime',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
