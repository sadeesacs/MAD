import 'dart:io';
import 'package:connect/auth/login_screen.dart';
import 'package:connect/util/profile_screen_functions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../Service Provider/widgets/connect_app_bar_sp.dart';
import '../../../Service Provider/widgets/sp_hamburger_menu.dart';
import '../../widgets/profile_screen/editable_text_field.dart';
import '../../widgets/profile_screen/profile_label.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<CustomerProfileScreen> {
  AuthService authService = AuthService();

  User? user = FirebaseAuth.instance.currentUser;
  File? _selectedImage;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _nameEditable = false;
  bool _emailEditable = false;
  bool _phoneEditable = false;
  String? _profilePicUrl;
  String? _localProfileImagePath;

  // For editing text
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _checkLocalProfileImage();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (user == null || user!.email == null) {
        print('User or user email is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in properly')),
        );
        return;
      }

      print('Fetching user data for email: ${user!.email}');

      // Try to get user by email
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user!.email)
          .limit(1)
          .get();

      // If no documents found by email, try with UID
      if (querySnapshot.docs.isEmpty) {
        print('No user found by email, trying with UID: ${user!.uid}');
        querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user!.uid)
            .limit(1)
            .get();
      }

      // If still no document, try direct document lookup by UID
      if (querySnapshot.docs.isEmpty) {
        print('Trying direct document lookup with UID: ${user!.uid}');
        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data()!;
          print('Found user data by direct lookup: ${userData['name']}');

          setState(() {
            _nameController.text = userData['name'] ?? '';
            _emailController.text = userData['email'] ?? user!.email ?? '';
            _phoneController.text = userData['phoneNumber'] ?? '';
            _profilePicUrl = userData['profile_pic'];
          });
        } else {
          print('No user document found by any method');
          // Use Firebase Auth data as fallback
          setState(() {
            _nameController.text = user!.displayName ?? '';
            _emailController.text = user!.email ?? '';
            _phoneController.text = user!.phoneNumber ?? '';
            _profilePicUrl = user!.photoURL;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found in database')),
          );
        }
      } else {
        final userData = querySnapshot.docs.first.data();
        print('Found user data by query: ${userData['name']}');

        setState(() {
          _nameController.text = userData['name'] ?? '';
          _emailController.text = userData['email'] ?? user!.email ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _profilePicUrl = userData['profile_pic'];
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );

      // Use Firebase Auth data as fallback
      if (user != null) {
        setState(() {
          _nameController.text = user!.displayName ?? '';
          _emailController.text = user!.email ?? '';
          _phoneController.text = user!.phoneNumber ?? '';
          _profilePicUrl = user!.photoURL;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkLocalProfileImage() async {
    try {
      if (user != null && user!.email != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = "${user!.email}_profile_image.png".replaceAll('.', '_');
        final localImagePath = '${directory.path}/$fileName';

        final file = File(localImagePath);

        if (await file.exists()) {
          setState(() {
            _localProfileImagePath = localImagePath;
            _selectedImage = file;
          });
        }
      }
    } catch (e) {
      print('Error checking local profile image: $e');
    }
  }

  Future<void> _updateUserData({bool updateName = false, bool updatePhone = false, bool updateImage = false}) async {
    if (user == null || user!.email == null) {
      print('User or user email is null, aborting update');
      return;
    }

    if (updateName && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty')),
      );
      return;
    }

    if (updatePhone) {
      final phoneRegex = RegExp(r'^(?:\+94|0)?(?:7[0-9]{8})$');
      if (!phoneRegex.hasMatch(_phoneController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid phone number')),
        );
        return;
      }
    }

    setState(() {
      _isSaving = true;
    });

    try {
      String? imagePath;

      if (updateImage && _selectedImage != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = "${user!.email}_profile_image.png".replaceAll('.', '_');
        final profilePicDir = Directory('${directory.path}/profile_pic');
        if (!await profilePicDir.exists()) {
          await profilePicDir.create(recursive: true);
        }

        final localImagePath = '${profilePicDir.path}/$fileName';
        await _selectedImage!.copy(localImagePath);
        imagePath = localImagePath;
      }

      // Try to get user document by UID first
      final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update existing document
        Map<String, dynamic> updates = {};

        if (updateName) {
          updates['name'] = _nameController.text.trim();
        }

        if (updatePhone) {
          updates['phoneNumber'] = _phoneController.text.trim();
        }

        if (updateImage && imagePath != null) {
          updates['profile_pic'] = imagePath;
        }

        if (updates.isNotEmpty) {
          await docRef.update(updates);

          // Update state variables
          if (updateImage && imagePath != null) {
            setState(() {
              _profilePicUrl = imagePath;
              _localProfileImagePath = imagePath;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile picture updated successfully')),
            );
          } else if (updateName) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Name updated successfully')),
            );
          } else if (updatePhone) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Phone number updated successfully')),
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      } else {
        // Try to find by email as fallback
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> updates = {};

          if (updateName) {
            updates['name'] = _nameController.text.trim();
          }

          if (updatePhone) {
            updates['phoneNumber'] = _phoneController.text.trim();
          }

          if (updateImage && imagePath != null) {
            updates['profile_pic'] = imagePath;
          }

          if (updates.isNotEmpty) {
            await querySnapshot.docs.first.reference.update(updates);

            if (updateImage && imagePath != null) {
              setState(() {
                _profilePicUrl = imagePath;
                _localProfileImagePath = imagePath;
              });
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          }
        } else {
          print('No user document found in Firestore');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User profile not found in database')),
          );
        }
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _onChangeProfilePic() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });

        // Update profile image immediately after selection
        _updateUserData(updateImage: true);
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              Row(
                children: [
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
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipOval(
                      child: _selectedImage != null
                          ? Image.file(
                        _selectedImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                          : (_profilePicUrl != null && _profilePicUrl!.isNotEmpty)
                          ? ((_profilePicUrl!.startsWith('/'))
                          ? Image.file(
                        File(_profilePicUrl!),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/profile_pic/leo_perera.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                          : Image.network(
                        _profilePicUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/profile_pic/leo_perera.jpg',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          );
                        },
                      ))
                          : Image.asset(
                        'assets/images/profile_pic/leo_perera.jpg',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
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
              const ProfileLabel(label: 'Name'),
              const SizedBox(height: 8),
              EditableTextField(
                controller: _nameController,
                hintText: 'Enter your name',
                isEditable: _nameEditable,
                onEditTap: () {
                  // If turning off edit mode, update the name
                  if (_nameEditable) {
                    _updateUserData(updateName: true);
                  }
                  setState(() {
                    _nameEditable = !_nameEditable;
                  });
                },
              ),
              const SizedBox(height: 24),
              const ProfileLabel(label: 'Email'),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black,
                ),
                enabled: false,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 24),
              const ProfileLabel(label: 'Phone Number'),
              const SizedBox(height: 8),
              EditableTextField(
                controller: _phoneController,
                hintText: 'Enter your phone number',
                isEditable: _phoneEditable,
                onEditTap: () {
                  // If turning off edit mode, update the phone number
                  if (_phoneEditable) {
                    _updateUserData(updatePhone: true);
                  }
                  setState(() {
                    _phoneEditable = !_phoneEditable;
                  });
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () => authService.signOut(context),
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
}