import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// สมมติว่า TripHome อยู่ในไฟล์นี้
import '../bloc/export_bloc.dart';
import 'trip_homs.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationBloc(),
      child: Scaffold(
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            switch (state.selectedIndex) {
              case 0:
                return TripHome();
              case 1:
                return GroupScreen();
              case 2:
                return MapScreen();
              case 3:
                return AboutScreen();
              default:
                return TripHome();
            }
          },
        ),
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // ทำให้แสดงข้อความใต้ไอคอนตลอดเวลา
              currentIndex: state.selectedIndex,
              backgroundColor: const Color.fromARGB(255, 227, 229, 228), // สีพื้นหลัง
              onTap: (index) {
                context
                    .read<BottomNavigationBloc>()
                    .add(ChangeBottomNavigation(index));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Group',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.location_on),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'About',
                ),
              ],
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0), // สีของไอเท็มที่ไม่ได้เลือก
              selectedItemColor: const Color.fromARGB(255, 125, 0, 250), // สีของไอเท็มที่เลือก
              selectedFontSize: 12, // ขนาดฟอนต์ของไอเท็มที่เลือก
              unselectedFontSize: 12, // ขนาดฟอนต์ของไอเท็มที่ไม่ได้เลือก
              iconSize: 24, // ขนาดไอคอน
            );
          },
        ),
      ),
    );
  }
}

class GroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Group Screen'));
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Map Screen'));
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('About Screen'));
  }
}
