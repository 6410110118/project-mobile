import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/export_bloc.dart';
import '../models/models.dart';
import '../repositories/trip_repository.dart';
 // Import TripRepository ที่คุณสร้าง

class NewTripPage extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController tripDescriptionController = TextEditingController();
  final TextEditingController tripLocationController = TextEditingController();
  final TripRepository tripRepository;

  // Controller สำหรับวันที่
  DateTime? startDate;
  DateTime? endDate;

  NewTripPage({Key? key, required this.tripRepository}) : super(key: key);

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      if (isStartDate) {
        startDate = picked;
      } else {
        endDate = picked;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripBloc(tripRepository: tripRepository),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Submit Trip'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<TripBloc, TripState>(
            listener: (context, state) {
              if (state is TripSubmitted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trip submitted successfully!')),
                );
              } else if (state is TripError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: BlocBuilder<TripBloc, TripState>(
              builder: (context, state) {
                if (state is TripSubmitting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                return Column(
                  children: [
                    TextField(
                      controller: tripNameController,
                      decoration: InputDecoration(labelText: 'Trip Name'),
                    ),
                    TextField(
                      controller: tripDescriptionController,
                      decoration: InputDecoration(labelText: 'Trip Description'),
                    ),
                    TextField(
                      controller: tripLocationController,
                      decoration: InputDecoration(labelText: 'Trip Location'),
                    ),
                    SizedBox(height: 20),



                    // ฟิลด์เลือก start_date
                    Row(
                      children: [
                        Text('Start Date:'),
                        Text(startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'No date selected'),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context, true), // เลือก start_date
                        ),
                      ],
                    ),

                    // ฟิลด์เลือก end_date
                    Row(
                      children: [
                        Text('End Date:'),
                        Text(endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'No date selected'),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context, false), // เลือก end_date
                        ),
                      ],
                    ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (startDate != null && endDate != null) {
                          final trip = Trip(
                            tripName: tripNameController.text,
                            description: tripDescriptionController.text,
                            address: tripLocationController.text,
                            starttime: startDate!,
                            endtime: endDate!,
      );
                          context.read<TripBloc>().add(SubmitTrip(trip));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select both start and end dates.')),
                          );  
                        }
                      },
                      child: Text('Submit Trip'),
                    ),

                    if (state is TripError)
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
