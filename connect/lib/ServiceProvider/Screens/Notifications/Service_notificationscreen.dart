import 'package:flutter/material.dart';
import 'package:connect/Customer/widgets/connect_app_bar.dart';
import 'package:connect/Customer/widgets/connect_nav_bar.dart'; // Custom bottom nav bar

class ServiceNotificationscreen extends StatelessWidget {
  const ServiceNotificationscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),  // Custom AppBar
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title: Notifications
            const Text(
              "Notifications",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF027335), // Green color
              ),
            ),
            const SizedBox(height: 30),

            // List of notifications (Placeholder notifications for now)
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Example notification count
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(15),
                      leading: Icon(Icons.notifications, color: Color(0xFF027335)),
                      title: Text('No need ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('This is a sample notification content for notification ${index + 1}.'),
                      trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF027335)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const ConnectNavBar(isHomeSelected: false),  // Custom Bottom Nav Bar
    );
  }
}
