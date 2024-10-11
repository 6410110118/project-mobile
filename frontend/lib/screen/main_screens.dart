import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/repositories/trip_repository.dart';
import 'package:frontend/screen/group_page.dart';
import 'package:frontend/screen/new_trip.dart';
import 'package:frontend/screen/profile.dart';
import 'package:frontend/screen/trip_homs.dart';
import 'package:frontend/screen/trip_list_page.dart';
import '../bloc/export_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(
            create: (context) => GetMeBloc(ProfileRepository())
              ..add(FetchUserData())), // เรียกใช้งาน GetMeBloc
      ],
      child: Scaffold(
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            switch (state.selectedIndex) {
              case 0:
                return TripHome();
              case 1:
                return BlocBuilder<GetMeBloc, GetMeState>(
                  builder: (context, userState) {
                    if (userState is GetMeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (userState is GetMeError) {
                      return Center(child: Text('Error: ${userState.message}'));
                    } else if (userState is GetMeLoaded) {
                      // เช็คว่า user เป็น Leader หรือไม่
                      if (userState.user.role == 'Leader') {
                        return NewTripPage(tripRepository: TripRepository());
                      } else {
                        return const TripListPage(); // แสดงรายการ Trip ที่ Leader สร้างไว้
                      }
                    }
                    return const Center(child: const Text('No user data available.'));
                  },
                );
              case 2:
                return GroupScreen();
              case 3:
                return ProfilePage();
              default:
                return TripHome();
            }
          },
        ),
        bottomNavigationBar:
            BlocBuilder<GetMeBloc, GetMeState>(builder: (context, userState) {
          return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
            builder: (context, state) {
              String secondLabel = 'Create'; // ค่าเริ่มต้น
              if (userState is GetMeLoaded && userState.user.role != 'Leader') {
                secondLabel =
                    'Trip List'; // เปลี่ยนเป็น Trip List เมื่อไม่ใช่ Leader
              }

              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: state.selectedIndex,
                backgroundColor: const Color.fromARGB(255, 227, 229, 228),
                onTap: (index) {
                  context
                      .read<BottomNavigationBloc>()
                      .add(ChangeBottomNavigation(index));
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.add),
                    label: secondLabel, // ใช้ตัวแปร secondLabel ที่อัปเดตแล้ว
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.group_add),
                    label: 'Group',
                  ),
                  const BottomNavigationBarItem(
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
          );
        }),
      ),
    );
  }
}
