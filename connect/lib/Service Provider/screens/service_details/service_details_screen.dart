import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';

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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    service = Map<String, dynamic>.from(widget.service);
    _scrollController.addListener(_onScroll);
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

  void _toggleStatus() {
    setState(() {
      service['status'] =
      (service['status'] == 'Active') ? 'Inactive' : 'Active';
    });
  }

  void _editDescription(String newDesc) {
    setState(() {
      service['jobDescription'] = newDesc;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = (service['status'] == 'Active');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ConnectAppBarSP(),
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
                          borderRadius: BorderRadius.circular(8), // 10% rounded
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
                        service['serviceName'] ?? 'Service Name',
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                          color: Color(0xFF027335),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status indicator with popup to change status
                    GestureDetector(
                      onTap: () {
                        // Show status confirmation popup
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return StatusConfirmationPopup(
                              isCurrentlyActive: isActive,
                              onConfirm: () {
                                Navigator.of(context).pop();
                                _toggleStatus();
                              },
                              onCancel: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        );
                      },
                      child: StatusIndicator(isActive: isActive),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    service['coverImage'] ?? 'assets/images/cover_image/cleaning2.png',
                    width: double.infinity,
                    height: 250,
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
                        builder: (_) => EditServiceDetailsScreen(service: service),
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
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return EditJobDescriptionPopup(
                          initialValue: service['jobDescription'] ?? '',
                          onSubmit: (newDesc) {
                            Navigator.of(context).pop();
                            _editDescription(newDesc);
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Recent Jobs Card
                RecentJobsWidget(
                  jobs: service['recentJobs'] ??
                      [
                        {
                          'images': [
                            'assets/images/jobs/job1.png',
                            'assets/images/jobs/job2.png',
                          ],
                          'description': 'Sample recent job description goes here.',
                        },
                      ],
                  onAdd: () {
                    // Navigate to AddRecentJobScreen.
                    Navigator.push<Map<String, dynamic>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddRecentJobScreen(),
                      ),
                    ).then((newJob) {
                      if (newJob != null) {
                        // If new job is returned, add it to the service's 'recentJobs'
                        setState(() {
                          final existingJobs = service['recentJobs'] as List<Map<String, dynamic>>? ?? [];
                          existingJobs.add(newJob);
                          service['recentJobs'] = existingJobs;
                        });
                      }
                    });
                  },
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
}