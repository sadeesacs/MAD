import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';
import '../../widgets/sp_hamburger_menu.dart';
import 'widgets/status_indicator.dart';
import 'widgets/service_detail_card.dart';
import 'widgets/job_description_card.dart';
import 'widgets/recent_jobs_widget.dart';
import 'popups/status_confirmation_popup.dart';
import 'popups/edit_job_description_popup.dart';
import 'edit_service_details_screen.dart';
import 'add_recent_job_screen.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  const ServiceDetailsScreen({
    super.key,
    required this.service,
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  bool _hideNavBar = false;
  double _lastOffset = 0.0;

  late Map<String, dynamic> service;
  List<Map<String, dynamic>> recentJobs = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    service = Map<String, dynamic>.from(widget.service);
    _scrollController.addListener(_onScroll);
    _fetchRecentJobs();
  }

  void _onScroll() {
    final offset = _scrollController.position.pixels;
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && offset > _lastOffset) {
      if (!_hideNavBar) setState(() => _hideNavBar = true);
    } else if (direction == ScrollDirection.forward && offset < _lastOffset) {
      if (_hideNavBar) setState(() => _hideNavBar = false);
    }
    _lastOffset = offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchRecentJobs() async {
    try {
      // Get updated service data to ensure we have the latest recentJobs array
      final serviceDoc = await FirebaseFirestore.instance
          .collection('services')
          .doc(service['id'])
          .get();

      if (serviceDoc.exists) {
        final updatedService = serviceDoc.data() as Map<String, dynamic>;
        // Update the local service data with the latest from Firestore
        service = {...service, ...updatedService};
      }

      final recentJobsRefs =
          (service['recentJobs'] as List<dynamic>?)?.cast<DocumentReference>() ?? [];

      // Clear existing jobs before fetching
      final fetchedRecentJobs = <Map<String, dynamic>>[];

      for (final ref in recentJobsRefs) {
        final docSnapshot = await ref.get();
        if (docSnapshot.exists) {
          final jobData = docSnapshot.data() as Map<String, dynamic>;
          fetchedRecentJobs.add(jobData);
        }
      }

      setState(() {
        recentJobs = fetchedRecentJobs;
      });

      print("Fetched ${recentJobs.length} recent jobs");
    } catch (e) {
      print("Error fetching recent jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = (service['status'] == 'Active');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
      endDrawer: const SPHamburgerMenu(),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for the back button + Service Title + Status Indicator Row
                Row(
                  children: [
                    // Back button: navigates back to previous screen
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
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
                    const SizedBox(width: 16),
                    // Service Title (using serviceName)
                    Expanded(
                      child: Text(
                        service['serviceName'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Color(0xFF027335),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status indicator with popup to change status
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => StatusConfirmationPopup(
                            isCurrentlyActive: isActive,
                            onConfirm: _toggleStatus,
                            onCancel: () => Navigator.pop(context),
                          ),
                        );
                      },
                      child: StatusIndicator(isActive: isActive),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Cover image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: service['coverImage'] != null &&
                      service['coverImage'].isNotEmpty
                      ? Image.file(
                    File(service['coverImage']),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/other/service_default_image.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                      : Image.asset(
                    'assets/images/other/service_default_image.png',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 30),

                // Service Detail Card
                ServiceDetailCard(
                  service: service,
                  onEdit: () {
                    // Navigate to EditServiceDetailsScreen and update service on return.
                    Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditServiceDetailsScreen(service: service),
                      ),
                    ).then((updatedService) {
                      if (updatedService != null) {
                        setState(() {
                          service = updatedService;
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 30),

                // Job Description Card
                JobDescriptionCard(
                  description: service['jobDescription'] ?? '',
                  onEdit: () {
                    // Show bottom sheet pop up for editing job description
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => EditJobDescriptionPopup(
                        initialValue: service['jobDescription'] ?? '',
                        onSubmit: _editDescription,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Recent Jobs Title + Add Icon
                Row(
                  children: [
                    const Text(
                      'Recent Jobs',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Color(0xFF027335),
                      ),
                    ),
                    const Spacer(),
                    // Inside the build method of ServiceDetailsScreen
                    InkWell(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddRecentJobScreen(
                              selectedServiceId: service['id'],
                            ),
                          ),
                        );

                        if (result != null) {
                          // Important: Refresh the jobs list
                          await _fetchRecentJobs();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Recent Jobs Card
                recentJobs.isEmpty
                    ? const Center(child: Text('No recent jobs available'))
                    : Column(
                  children: recentJobs.map((job) {
                    return _buildJobCard(job);
                  }).toList(),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

          // Nav bar with no highlighted icon
          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: const ConnectNavBarSP(
                isHomeSelected: false,
                isToolsSelected: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    final List<String> images = (job['images'] as List<dynamic>).cast<String>();
    final String desc = job['description'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF027335)),
        borderRadius: BorderRadius.circular(16), // 10% corners
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Two images side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: images.map((imgPath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(imgPath),
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/other/service_default_image.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Description
          Text(
            desc,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _toggleStatus() async {
    final newStatus = (service['status'] == 'Active') ? 'Inactive' : 'Active';
    setState(() {
      service['status'] = newStatus;
    });

    try {
      // Ensure the serviceProvider field contains a valid document reference
      final serviceProviderRef = service['serviceProvider'];
      if (serviceProviderRef is DocumentReference) {
        // Query the services collection to find the document with the matching serviceProvider
        final querySnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('serviceProvider', isEqualTo: serviceProviderRef)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the status field in the found document
          final docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('services')
              .doc(docId)
              .update({
            'status': newStatus,
          });
          Navigator.pop(context); // Close the confirmation dialog
        } else {
          print("Service document not found");
        }
      } else {
        print("Invalid serviceProvider reference");
      }
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  void _editDescription(String newDesc) async {
    setState(() {
      service['jobDescription'] = newDesc;
    });

    try {
      // Ensure the serviceProvider field contains a valid document reference
      final serviceProviderRef = service['serviceProvider'];
      if (serviceProviderRef is DocumentReference) {
        // Query the services collection to find the document with the matching serviceProvider
        final querySnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('serviceProvider', isEqualTo: serviceProviderRef)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update the jobDescription field in the found document
          final docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('services')
              .doc(docId)
              .update({
            'jobDescription': newDesc,
          });
        } else {
          print("Service document not found");
        }
      } else {
        print("Invalid serviceProvider reference");
      }
    } catch (e) {
      print("Error updating job description: $e");
    }
  }
}