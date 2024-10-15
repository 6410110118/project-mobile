import 'package:flutter/material.dart';
import 'package:frontend/widgets/seach_body.dart';

import '../models/models.dart';

class SearchPage extends StatefulWidget {
  final List<Trip> trips;

  SearchPage({required this.trips});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTrips = widget.trips.where((trip) {
      return trip.tripName
              ?.toLowerCase()
              .contains(_searchQuery.toLowerCase()) ??
          false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 86, 137),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
      ),
      body: SearchBody(
        trips: filteredTrips,
        onSearch: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
      ),
    );
  }
}
