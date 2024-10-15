import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screen/main_screens.dart';
import '../bloc/export_bloc.dart';
import '../models/models.dart';
import '../repositories/trip_repository.dart';

class NewTripPage extends StatelessWidget {
  final TextEditingController tripNameController = TextEditingController();
  final TextEditingController tripDescriptionController =
      TextEditingController();
  final TextEditingController tripLocationController = TextEditingController();
  final TripRepository tripRepository;

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
          title: const Text(
            'Create New Trip',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 32, 86, 137),
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: const Color(0xFFF6F7F0),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<TripBloc, TripState>(
            listener: (context, state) {
              if (state is TripSubmitted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip submitted successfully!')),
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
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 30, 23, 105),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: tripNameController,
                      label: 'Trip Name',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: tripDescriptionController,
                      label: 'Trip Description',
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      controller: tripLocationController,
                      label: 'Trip Location',
                    ),
                    const SizedBox(height: 20),
                    _buildDateField(
                      context,
                      label: 'Start Date',
                      dateText: startDate != null
                          ? startDate!.toLocal().toString().split(' ')[0]
                          : 'No date selected',
                      onPressed: () async {
                        await _selectDate(context, true);
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      context,
                      label: 'End Date',
                      dateText: endDate != null
                          ? endDate!.toLocal().toString().split(' ')[0]
                          : 'No date selected',
                      onPressed: () async {
                        await _selectDate(context, false);
                        (context as Element).markNeedsBuild();
                      },
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 32, 86, 137),
                          elevation: 4,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
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
                              const SnackBar(
                                  content: Text(
                                      'Please select a start and end date.')),
                            );
                          }
                        },
                        child: const Text(
                          'Submit Trip',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    if (state is TripError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF707070), width: 1.5),
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF6F7F0),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color.fromARGB(255, 32, 86, 137),
            fontSize: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context,
      {required String label,
      required String dateText,
      required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF707070),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xFFF6F7F0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: $dateText',
            style: const TextStyle(
              color: Color.fromARGB(255, 32, 86, 137),
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            color: const Color.fromARGB(255, 32, 86, 137),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
