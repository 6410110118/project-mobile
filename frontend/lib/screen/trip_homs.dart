import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/trip_repository.dart';

import '../bloc/export_bloc.dart';
import '../models/models.dart';

class TripHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // ไม่ใช้ AppBar เพื่อให้ layout เหมือนในภาพ
      body: BlocProvider(
        create: (context) =>
            TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        child: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TripLoaded) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ส่วนหัว: ทักทายผู้ใช้และปุ่ม Plan new trip
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
                          ElevatedButton(
                            onPressed: () {
                              // Action สำหรับปุ่ม Plan new trip
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Plan new trip'),
                          ),
                        ],
                      ),
                    ),

                    // ช่องค้นหาขั้นสูง
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Advanced search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // เมนูแบบ Story (เหมือนในภาพ)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        height: 150, // กำหนดความสูงของ Story list
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
                        children: List.generate(state.trips.length, (index) {
                          final trip = state.trips[index];
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
    return Card(
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
                  '10 Jun - 17 Jun 2023', // แสดงวันที่ทริป
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
    );
  }
}
