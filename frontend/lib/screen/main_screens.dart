import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/export_bloc.dart';
import '../models/home.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripBloc()..add(LoadTrips()), // โหลดทริปเมื่อเปิดหน้า Home
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trips Home'),
        ),
        body: BlocBuilder<TripBloc, TripState>(
          builder: (context, state) {
            if (state is TripLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TripLoaded) {
              return ListView.builder(
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  final trip = state.trips[index];
                  return TripItem(trip: trip); // สร้าง ListTile แต่ละทริป
                },
              );
            } else if (state is TripError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('No trips available'));
          },
        ),
      ),
    );
  }
}

class TripItem extends StatelessWidget {
  final Trip trip;

  const TripItem({Key? key, required this.trip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.network(trip.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(trip.tripName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('End time: ${trip.endtime}'),
            BlocBuilder<TripBloc, TripState>(
              builder: (context, state) {
                return Row(
                  children: [
                    // เช็คสถานะเวลาหมดของทริป
                    ElevatedButton(
                      onPressed: () {
                        context.read<TripBloc>().add(CheckTripStatus(trip.id));
                      },
                      child: Text('Check Status'),
                    ),
                    // แสดงผลสถานะ
                    if (state is TripLateStatus)
                      Text(state.isLate ? 'Trip is late' : 'Trip is on time'),

                    // เช็คบทบาทผู้ใช้ในทริป
                    ElevatedButton(
                      onPressed: () {
                        context.read<TripBloc>().add(CheckTripRole(trip.id));
                      },
                      child: Text('Check Role'),
                    ),
                    // แสดงผลบทบาท
                    if (state is TripRoleStatus)
                      Text(state.isLeader ? 'Leader' : 'Participant'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}