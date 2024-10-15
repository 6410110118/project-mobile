import 'package:flutter/material.dart';
import 'package:frontend/widgets/detail_page.dart';
import '../models/models.dart';

class SearchBody extends StatelessWidget {
  final List<Trip> trips;
  final ValueChanged<String> onSearch;

  SearchBody({required this.trips, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7F0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 32, 86, 137)),
                  hintText: 'ค้นหา...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                onChanged: (value) {
                  onSearch(value);
                },
              ),
            ),
          ),
          Expanded(
            child: trips.isNotEmpty
                ? ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final trip = trips[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 4,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  const Color.fromARGB(255, 32, 86, 137),
                              child: Text(
                                trip.tripName != null
                                    ? trip.tripName![0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24),
                              ),
                            ),
                            title: Text(
                              trip.tripName ?? 'No Name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 32, 86, 137)),
                            ),
                            subtitle: Text(
                              'Start: ${trip.starttime.toString()}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TripDetailPage(trip: trip),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'ไม่พบทริปที่ตรงกับคำค้นหา',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
