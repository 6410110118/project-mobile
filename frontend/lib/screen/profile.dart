
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/widgets/upload_image_popup.dart';

import 'package:frontend/bloc/export_bloc.dart';
import 'package:frontend/repositories/profile_repository.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screen/change_password.dart';
import 'package:frontend/screen/edit_profile_page.dart';
import 'package:frontend/widgets/logout_popup.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetMeBloc>(context).add(FetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: BlocListener<GetMeBloc, GetMeState>(
        listener: (context, state) {
          if (state is ImageUploadLoading) {
            // แสดง progress indicator หรือ dialog ที่นี่
          } else if (state is ImageUploaded) {
            // แสดงข้อความว่าการอัปโหลดสำเร็จ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image uploaded successfully!')),
            );
          } else if (state is ImageUploadFailure) {
            // แสดงข้อความข้อผิดพลาด
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<GetMeBloc, GetMeState>(
          builder: (context, state) {
            if (state is GetMeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is GetMeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is GetMeLoaded) {
              final user = state.user;
              return _buildProfileContent(context, user);
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildProfileCard(user),
          Spacer(),
          _buildActionButtons(context, user),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserModel user) {
    return Padding(
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
                  : AssetImage('assets/start.jpg') as ImageProvider,
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
              style: TextStyle(fontSize: 16),
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
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel user) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: Icon(Icons.edit),
            label: Text('Edit Profile'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: user),
                ),
              ).then((_) {
                // โหลดข้อมูลใหม่หลังจากกลับมาที่ ProfilePage
                BlocProvider.of<GetMeBloc>(context).add(FetchUserData());
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 205, 188, 235),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: Icon(Icons.lock),
            label: Text('Change Password'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordPage(),
                ),
              ).then((_) {
                // โหลดข้อมูลใหม่หลังจากกลับมาที่ ProfilePage
                BlocProvider.of<GetMeBloc>(context).add(FetchUserData());
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 205, 188, 235),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        // ปุ่มสำหรับการเลือกและอัปโหลดภาพ
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: Icon(Icons.photo),
            label: Text('Upload Image'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return UploadImagePopup(); // เรียกใช้ UploadImagePopup
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 205, 188, 235),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ElevatedButton.icon(
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => LogoutDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 205, 188, 235),
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
