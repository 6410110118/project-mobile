import 'package:flutter/material.dart';

void main() {
  runApp(const TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Hello Shani!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB1A7D6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Plan new trip'),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Advanced search',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChoiceChip(
                    label: Text('What\'s near me'),
                    selected: false,
                  ),
                  ChoiceChip(
                    label: Text('Last search'),
                    selected: false,
                  ),
                  ChoiceChip(
                    label: Text('Shaffel for me'),
                    selected: false,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Upcoming trips',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const TripCard(
              imageUrl:
                  'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.state.gov%2Fcountries-areas%2Fjapan%2F&psig=AOvVaw3zJiAgbPN8PqyH7xWO9O6x&ust=1725705292845000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCKDz36mProgDFQAAAAAdAAAAABAE', // Replace with actual image URL
              tripName: 'Trip to Japan',
              date: '10 Jun - 17 Jun 2023',
            ),
            const TripCard(
              imageUrl:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeek9r1wNg5YW8nqQcKo99qt3qCoM0CtFnKA&s', // Replace with actual image URL
              tripName: 'Trip to London',
              date: '10 Jun - 17 Jun 2023',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Detail'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Group'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'About'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final String imageUrl;
  final String tripName;
  final String date;

  const TripCard(
      {super.key,
      required this.imageUrl,
      required this.tripName,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tripName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(date, style: const TextStyle(color: Colors.grey)),
                    ],
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
