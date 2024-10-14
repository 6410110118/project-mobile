import 'package:flutter/material.dart';
import 'package:frontend/widgets/seach_body.dart';

import '../models/models.dart';

class SearchPage extends StatefulWidget {
  final List<Trip> trips; // รายการทริปทั้งหมด

  SearchPage({required this.trips});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // กรองทริปตามคำค้นหา
    final filteredTrips = widget.trips.where((trip) {
      return trip.tripName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true, // จัดให้หัวข้ออยู่ตรงกลาง
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
        iconTheme: const IconThemeData(
          color: Colors.white, // เปลี่ยนสีของไอคอนลูกศรย้อนกลับเป็นสีขาว
        ),
        elevation: 0, // ไม่มีเงาใต้ AppBar
      ),
      body: SearchBody(
        trips: filteredTrips, // ส่งทริปที่กรองแล้ว
        onSearch: (query) {
          setState(() {
            _searchQuery = query; // อัปเดตคำค้นหา
          });
        },
      ),
    );
  }
}
