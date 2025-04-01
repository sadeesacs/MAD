import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Leo Perera';
  String _email = 'Leoperera@gmail.com';
  String _phone = '0715645349';

  // For editing text
  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text  = _name;
    _emailController.text = _email;
    _phoneController.text = _phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      endDrawer: const SPHamburgerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: Back button + Title
              Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFE9E3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF027335),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title: "Profile"
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      color: Color(0xFF027335),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Centered Profile Pic + Camera icon
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // Circle avatar
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile_pic/leo_perera.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Camera icon overlay
                    GestureDetector(
                      onTap: _onChangeProfilePic,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE9E3),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF027335),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Name
              _buildLabel('Name'),
              const SizedBox(height: 8),
              _buildEditableTextField(
                controller: _nameController,
                hintText: 'Enter your name',
                onEditTap: () {
                },
              ),
              const SizedBox(height: 24),

              // Email
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildEditableTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                onEditTap: () {},
              ),
              const SizedBox(height: 24),

              // Phone Number
              _buildLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildEditableTextField(
                controller: _phoneController,
                hintText: 'Enter your phone number',
                onEditTap: () {},
              ),
              const SizedBox(height: 40),

              // Log Out button
              Center(
                child: ElevatedButton(
                  onPressed: _onLogOutPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF427E4E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onEditTap,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 16,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
        suffixIcon: GestureDetector(
          onTap: onEditTap,
          child: const Icon(
            Icons.edit,
            color: Colors.black,
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  void _onChangeProfilePic() {
    // Pick a new image from gallery?
  }

  void _onLogOutPressed() {
    debugPrint('Log out pressed');
  }
}