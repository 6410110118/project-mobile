import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/repositories/join_request_repository.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/repositories/trip_repository.dart';
import 'package:frontend/screen/join_request_page.dart';
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
        RepositoryProvider(create: (_) => JoinRequestRepository()),
        BlocProvider(create: (context) => BottomNavigationBloc()),
        BlocProvider(
          create: (context) =>
              GetMeBloc(ProfileRepository())..add(FetchUserData()),
        ),
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
                      if (userState.user.role == 'Leader') {
                        return NewTripPage(tripRepository: TripRepository());
                      } else {
                        return TripListPage();
                      }
                    }
                    return const Center(child: Text('No user data available.'));
                  },
                );
              case 2:
                return GroupScreen();
              case 3:
                return ProfilePage();
              case 4:
                return JoinRequestsPage(
                  joinRequestRepository: JoinRequestRepository(),
                );
              default:
                return TripHome();
            }
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BlocBuilder<GetMeBloc, GetMeState>(
      builder: (context, userState) {
        return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (context, state) {
            String secondLabel = 'Create';
            bool isLeader = false;

            if (userState is GetMeLoaded) {
              isLeader = userState.user.role == 'Leader';
              if (!isLeader) {
                secondLabel = 'Trip List';
              }
            }

            final items = [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.add),
                label: secondLabel,
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.group_add),
                label: 'Group',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'About',
              ),
            ];

            // Add the 'Requests' item to the bottom navigation bar if the user is a leader
            if (isLeader) {
              items.add(
                const BottomNavigationBarItem(
                  icon: Icon(Icons.request_page),
                  label: 'Requests',
                ),
              );
            }

            int currentIndex = state.selectedIndex;
            if (currentIndex < 0 || currentIndex >= items.length) {
              currentIndex = 0; // Ensures we always have a valid index
            }

// If currentIndex exceeds the number of items, reset it to 0
            if (currentIndex >= items.length) {
              currentIndex = 0; // This will ensure no out-of-range errors occur
            }

            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                context.read<BottomNavigationBloc>().add(
                      ChangeBottomNavigation(index),
                    );
              },
              items: items,
              unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
              selectedItemColor: const Color.fromARGB(255, 125, 0, 250),
            );
          },
        );
      },
    );
  }
}
