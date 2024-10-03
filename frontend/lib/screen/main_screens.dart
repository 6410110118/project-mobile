import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/group_page.dart';
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
        bottomNavigationBar: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: state.selectedIndex,
              backgroundColor: const Color.fromARGB(255, 227, 229, 228),
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
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              selectedItemColor: const Color.fromARGB(255, 125, 0, 250),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              iconSize: 24,
            );
          },
        ),
      ),
    );
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
