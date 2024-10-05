import 'package:flutter/material.dart';
import 'package:frontend/widgets/detail_page.dart';
import '../models/models.dart';

class SearchBody extends StatelessWidget {
  final List<Trip> trips; // รับ trips จาก SearchPage
  final ValueChanged<String> onSearch; // ฟังก์ชันการค้นหา

  SearchBody({required this.trips, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ค้นหา',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (value) {
              onSearch(value); // เรียกใช้ฟังก์ชันค้นหา
            },
          ),
        ),
        Expanded(
          child: trips.isNotEmpty
              ? ListView.builder(
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return ListTile(
                      title: Text(trip.tripName ?? 'No Name'),
                      subtitle: Text(trip.starttime.toString()), // แสดงเวลาที่เริ่ม
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TripDetailPage(trip: trip),
                          ),
                        );
                      },
                    );
                  },
                )
              : Center(child: Text('ไม่พบทริปที่ตรงกับคำค้นหา')), // แสดงข้อความเมื่อไม่พบทริป
        ),
      ],
    );
  }
}
