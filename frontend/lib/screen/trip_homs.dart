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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        ),

      ],
      child: Scaffold(
        appBar: null,
        body: BlocBuilder<TripBloc, TripState>(builder: (context, tripState) {
          if (tripState is TripLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (tripState is TripLoaded) {
            final List<Trip> trips = List<Trip>.from(tripState.trips);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(trips),
                  SizedBox(height: 20),
                  _buildStorySection(),
                  SizedBox(height: 20),
                  _buildRecommendedTripsHeader(),
                  SizedBox(height: 10),
                  _buildRecommendedTripsList(trips),
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

  Widget _buildHeader(List<Trip> trips) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<GetMeBloc, GetMeState>(builder: (context, userState) {
            if (userState is GetMeLoaded) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: userState.user.imageData != null
                        ? MemoryImage(userState.user.imageData!)
                        : AssetImage('assets/start.jpg') as ImageProvider,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Hello ${userState.user.username}!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          }),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage(trips: trips)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 150,
        child: ListView(scrollDirection: Axis.horizontal, children: _buildStoryItems()),
      ),
    );
  }

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

  Widget _buildRecommendedTripsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Recommend trips',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildRecommendedTripsList(List<Trip> trips) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: List.generate(trips.length, (index) {
          final trip = trips[index];
          return _buildTripCard(trip);
        }),
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    DateTime startTime = trip.starttime!;
    DateTime endTime = trip.endtime!;
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
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(trip.imageUrl!),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.tripName!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Start: $formattedStartTime'),
                  Text('End: $formattedEndTime'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TripBloc>(context).add(JoinTripEvent(trip: trip));
                    },
                    child: Text('Join Trip'),
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
