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
          create: (context) =>
              TripBloc(tripRepository: TripRepository())..add(FetchTripEvent()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7F0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 32, 86, 137),
          title: const Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<TripBloc, TripState>(builder: (context, tripState) {
          if (tripState is TripLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (tripState is TripLoaded) {
            final List<Trip> trips = List<Trip>.from(tripState.trips);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(trips),
                  const SizedBox(height: 20),
                  _buildStorySection(),
                  const SizedBox(height: 20),
                  _buildRecommendedTripsHeader(),
                  const SizedBox(height: 10),
                  _buildRecommendedTripsList(trips),
                ],
              ),
            );
          } else if (tripState is TripError) {
            return Center(child: Text(tripState.message));
          }
          return const Center(child: Text('No trips found'));
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
                        : const AssetImage('assets/start.jpg') as ImageProvider,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    'Hello ${userState.user.username}!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 32, 86, 137),
                    ),
                  ),
                ],
              );
            } else if (userState is GetMeLoading) {
              return const CircularProgressIndicator();
            } else {
              return const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              );
            }
          }),
          IconButton(
            icon: const Icon(Icons.search, color: Color.fromARGB(255, 32, 86, 137)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPage(trips: trips)),
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
      child: SizedBox(
        height: 150,
        child: ListView(
            scrollDirection: Axis.horizontal, children: _buildStoryItems()),
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
          width: 120,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(story['image']!),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildRecommendedTripsHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Recommend Trips',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 32, 86, 137),
        ),
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
        margin: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  trip.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 270,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.tripName!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$formattedStartTime – $formattedEndTime',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
