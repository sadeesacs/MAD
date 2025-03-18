import 'package:connect/Service%20Provider/screens/scheduled_jobs/widgets/scheduled_job_card.dart';
import 'package:flutter/material.dart';

import '../../widgets/connect_app_bar_sp.dart';
import '../../widgets/connect_nav_bar_sp.dart';

const Color darkGreen = Color(0xFF027335);
const Color appBarColor = Color(0xFFF1FAF1);
const Color white = Colors.white;

class ScheduledJobsScreen extends StatefulWidget {
  const ScheduledJobsScreen({super.key});

  @override
  _ScheduledJobsScreenState createState() => _ScheduledJobsScreenState();
}

class _ScheduledJobsScreenState extends State<ScheduledJobsScreen> {
  bool _hideNavBar = false;

  void _toggleNavBar() {
    setState(() {
      _hideNavBar = false; // Toggle the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Used directly
      appBar: const ConnectAppBarSP(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scheduled Jobs',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),

                // Job Cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2, // Replace with your actual data length
                  itemBuilder: (context, index) {
                    return ScheduledJobCard(
                      bookingId: '#6489303',
                      serviceType: 'Cleaning',
                      customerName: 'Leo Perera',
                      date: '2005-02-28',
                      time: '3 PM To 6 PM',
                      estimatedTotal: 'LKR 6000.00',
                    );
                  },
                ),
              ],
            ),
          ),


          Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              offset: _hideNavBar ? const Offset(0, 1.5) : const Offset(0, 0),
              child: ConnectNavBarSP(
                isHomeSelected: false,
                isToolsSelected: false,
                isCalenderSelected: true,
              ),
            ),
          ),
        ],
      ),

    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ScheduledJobsScreen(),
  ));
}