import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Adjust these imports to your actual screen files
import '../../auth/login_screen.dart';
import '../screens/booking_history/booking_history.dart';
import '../screens/category_listing/category_screen.dart';
import '../screens/customer_chats/customer_chat_list_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/customer_profile_screen.dart';
import '../screens/service-listing/service_listing.dart';
import '../screens/upcoming_bookings/upcoming_bookings.dart'; // Make sure this path is correct for your login screen

class HamburgerMenu extends StatefulWidget {
  const HamburgerMenu({Key? key}) : super(key: key);

  @override
  State<HamburgerMenu> createState() => _SPHamburgerMenuState();
}

class _SPHamburgerMenuState extends State<HamburgerMenu> {
  User? user = FirebaseAuth.instance.currentUser;
  String userName = "User";
  String? profilePicUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      if (user == null || user!.email == null) {
        print('User or user email is null in SPHamburgerMenu');
        return;
      }

      // Try to get user by email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      // If no documents found by email, try with UID
      if (querySnapshot.docs.isEmpty) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user!.uid)
            .limit(1)
            .get();
      }

      // If still no document, try direct document lookup by UID
      if (querySnapshot.docs.isEmpty) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data()!;

          if (mounted) {
            setState(() {
              userName = userData['name'] ?? 'User';
              profilePicUrl = userData['profile_pic'];
            });
          }
        } else {
          // Use Firebase Auth data as fallback
          if (mounted) {
            setState(() {
              userName = user!.displayName ?? 'User';
              profilePicUrl = user!.photoURL;
            });
          }
        }
      } else {
        final userData = querySnapshot.docs.first.data();

        if (mounted) {
          setState(() {
            userName = userData['name'] ?? 'User';
            profilePicUrl = userData['profile_pic'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user data for SP hamburger menu: $e');

      // Use Firebase Auth data as fallback
      if (user != null && mounted) {
        setState(() {
          userName = user!.displayName ?? 'User';
          profilePicUrl = user!.photoURL;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _buildProfileImage() {
    if (profilePicUrl != null && profilePicUrl!.isNotEmpty) {
      if (profilePicUrl!.startsWith('/')) {
        // Local file path
        return ClipOval(
          child: Image.file(
            File(profilePicUrl!),
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/profile_pic/leo_perera.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      } else {
        // Network URL
        return ClipOval(
          child: Image.network(
            profilePicUrl!,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 50,
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/profile_pic/leo_perera.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      }
    }

    // Default fallback image
    return ClipOval(
      child: Image.asset(
        'assets/images/profile_pic/leo_perera.jpg',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double drawerWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: drawerWidth,
        height: double.infinity,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Profile Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  children: [
                    // Wrap image + name in GestureDetector
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CustomerProfileScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Profile Pic
                          isLoading
                              ? Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                            child: Center(child: CircularProgressIndicator()),
                          )
                              : _buildProfileImage(),
                          const SizedBox(width: 12),

                          // Name
                          Text(
                            isLoading ? "Loading..." : userName,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    // Close Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // close the drawer
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDFE9E3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF027335),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Separation line
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xFF027335),
              ),

              const SizedBox(height: 16),

              // Menu Items
              _buildMenuItem(
                icon: Icons.home_filled,
                label: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.construction,
                label: 'Services',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ServiceListingScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.dashboard,
                label: 'Service Categories',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CategoriesScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.calendar_today_outlined,
                label: 'Bookings',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const UpcomingBookingsScreen()),
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.message_outlined,
                label: 'Chats',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerChatListScreen()),
                  );
                },
              ),


              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder
                },
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                label: 'Support',
                onTap: () {
                  Navigator.pop(context);
                  // Placeholder
                },
              ),
              _buildMenuItem(
                icon: Icons.logout,
                label: 'Logout',
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF027335)),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500, // Medium
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
