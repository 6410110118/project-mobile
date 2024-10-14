
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
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // ปรับสีฟอนต์เป็นสีขาว
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 32, 86, 137), // สีหลักของแอป
      ),
      backgroundColor: const Color(0xFFF6F7F0), // สีพื้นหลังเบจอ่อน
      body: BlocListener<GetMeBloc, GetMeState>(
        listener: (context, state) {
          if (state is ImageUploadLoading) {
            // แสดง progress indicator หรือ dialog ที่นี่
          } else if (state is ImageUploaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded successfully!')),
            );
          } else if (state is ImageUploadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: BlocBuilder<GetMeBloc, GetMeState>(
          builder: (context, state) {
            if (state is GetMeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetMeError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is GetMeLoaded) {
              final user = state.user;
              return _buildProfileContent(context, user);
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileCard(user),
          const Spacer(), // ดันปุ่มไปด้านล่างของหน้าจอ
          _buildActionButtons(context, user),
        ],
      ),
    );
  }

  Widget _buildProfileCard(UserModel user) {
    return Container(
      width: double.infinity, // ขยายเต็มความกว้างของหน้าจอ
      padding: const EdgeInsets.symmetric(vertical: 105.0, horizontal: 30.0), // ลด padding ทางด้านบน-ล่าง
      margin: const EdgeInsets.symmetric(horizontal: 16.0), // เพิ่ม margin ขอบซ้ายขวา
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.imageData != null
                ? MemoryImage(user.imageData!)
                : const AssetImage('assets/start.jpg') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 32, 86, 137),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Role: ${user.role}',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${user.email}',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, UserModel user) {
    return Column(
      children: [
        _buildProfileButton(
          icon: Icons.edit,
          label: 'Edit Profile',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(user: user),
              ),
            ).then((_) {
              BlocProvider.of<GetMeBloc>(context).add(FetchUserData());
            });
          },
        ),
        const SizedBox(height: 15), // เพิ่มระยะห่างระหว่างปุ่ม
        _buildProfileButton(
          icon: Icons.lock,
          label: 'Change Password',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ),
            ).then((_) {
              BlocProvider.of<GetMeBloc>(context).add(FetchUserData());
            });
          },
        ),
        const SizedBox(height: 15), // เพิ่มระยะห่างระหว่างปุ่ม
        _buildProfileButton(
          icon: Icons.photo,
          label: 'Upload Image',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return UploadImagePopup();
              },
            );
          },
        ),
        const SizedBox(height: 15), // เพิ่มระยะห่างระหว่างปุ่ม
        _buildProfileButton(
          icon: Icons.logout,
          label: 'Logout',
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => LogoutDialog(),
            );
          },
          color: Colors.redAccent,
        ),
      ],
    );
  }

  Widget _buildProfileButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color color = const Color.fromARGB(255, 32, 86, 137),
  }) {
    return SizedBox(
      width: double.infinity, // ขยายปุ่มเต็มจอ
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
