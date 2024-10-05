import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocProvider(
        create: (context) =>
            TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TripLoaded) {
              // ตรวจสอบให้แน่ใจว่า trips เป็น List<Trip>
              final List<Trip> trips = state.trips.cast<Trip>();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ส่วนหัว
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                                child: Icon(Icons.person),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Hello Shani!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                    trips: trips,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // ปุ่มค้นหา
                    

                    SizedBox(height: 20),

                    // เมนูแบบ Story
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

                    // หัวข้อ Recommend trips
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Recommend trips',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // รายการทริปที่แนะนำ
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
            } else if (state is TripError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No trips found'));
          },
        ),
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

  // Card สำหรับแสดงทริปแต่ละทริป
  Widget _buildTripCard(Trip trip) {
    DateTime startTime = trip.starttime!;
    DateTime endTime = trip.endtime!;

    // กำหนดรูปแบบวันที่ที่ต้องการ
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
            // รูปภาพของทริป
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$formattedStartTime - $formattedEndTime',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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
