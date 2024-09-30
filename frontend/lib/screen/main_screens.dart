import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/trip.dart';
import '../bloc/export_bloc.dart';

class MainScreen extends StatelessWidget {
  final List<Trip> trips;

  const MainScreen({Key? key, required this.trips}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 10),
                Text(
                  'Hello Shani!',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Implement Plan new trip action
              },
              child: Text('Plan new trip'),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Advanced Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Advanced search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            // Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text('สถานที่แนะนำ'),
                  onSelected: (bool value) {},
                ),
                FilterChip(
                  label: Text('สถานที่แนะนำ'),
                  onSelected: (bool value) {},
                ),
                FilterChip(
                  label: Text('สถานที่แนะนำ'),
                  onSelected: (bool value) {},
                ),
              ],
            ),
            SizedBox(height: 16),
            // Recommended Trips Title
            Text(
              'Recommend trips',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Trip List
            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('${trip.tripName} - ${trip.description}'),
                        subtitle: Text(
                          'Start: ${trip.starttime} - End: ${trip.endtime}',
                          
                          style: TextStyle(fontSize: 14),
                        ),

                        onTap: () {
                          // Implement Trip detail action
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Detail',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: Color.fromARGB(255, 125, 0, 250),
        // onTap: (index) {
        //   context.read<NavigationBloc>().add(PageSelected(index));
        // },
      ),
    );
  }
}
