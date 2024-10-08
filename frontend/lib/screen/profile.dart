import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/widgets/Logout_popup.dart';
// นำเข้า LogoutDialog

class ProfilePage extends StatelessWidget {
  final ProfileRepository _getMeRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetMeBloc(_getMeRepository)
        ..add(FetchUserData()), // เพิ่มการเรียก event เพื่อ fetch ข้อมูล
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: BlocBuilder<GetMeBloc, GetMeState>(
          builder: (context, state) {
            if (state is GetMeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetMeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is GetMeLoaded) {
              final user = state.user;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Container(
                        padding: EdgeInsets.all(50.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: user.imageData != null
                                  ? MemoryImage(user.imageData!)
                                  : AssetImage('assets/start.jpg')
                                      as ImageProvider, // Fallback to placeholder if no image
                            ),
                            SizedBox(height: 20),
                            Text(
                              '${user.firstName} ${user.lastName}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Role: ${user.role}',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Email: ${user.email}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.edit),
                            label: Text('Edit Profile'),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 205, 188, 235),
                              padding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        
                        // เพิ่มปุ่ม Logout
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.logout),
                            label: Text('Logout'),
                            onPressed: () {
                              // แสดง LogoutDialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LogoutDialog();
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 205, 188, 235),
                              padding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
