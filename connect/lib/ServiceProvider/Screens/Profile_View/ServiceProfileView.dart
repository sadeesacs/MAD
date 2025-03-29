import 'package:flutter/material.dart';
import 'package:connect/Customer/widgets/connect_app_bar.dart'; // Import your custom AppBar

class ServiceProfileViewScreen extends StatelessWidget {
  const ServiceProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ConnectAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Profile Title with Arrow (Move more to the right)
            // Back button and Title in a Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);  // Navigate back to previous screen
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F5E1), // Light green background
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      padding: const EdgeInsets.all(8), // Padding around the back button
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF027335), // Green color for the icon
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Adjust space between back button and title

                  // Title: Profile
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0), // Move the title left and right
                    child: const Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF027335)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Profile Image
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/Menu_Icons/ProfilePicture.png'),
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 20),

            // Name label and TextField
            const Text(
              "Name ",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),  // Label outside the text box
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Leo Perera",
                filled: true,
                fillColor: const Color(0xFFFFFFFF), // Set the background color of the text field
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Set the border radius
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Add your edit functionality here
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: const TextStyle(fontWeight: FontWeight.normal), // Text inside text box should not be bold
            ),
            const SizedBox(height: 20),

            // Email label and TextField
            const Text(
              "Email",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),  // Label outside the text box
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "Leoperera@gmail.com",
                filled: true,
                fillColor: const Color(0xFFF6FAF8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Add your edit functionality here
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: const TextStyle(fontWeight: FontWeight.normal), // Text inside text box should not be bold
            ),
            const SizedBox(height: 20),

            // Phone Number label and TextField
            const Text(
              "Phone Number",
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),  // Label outside the text box
            ),
            TextField(
              decoration: InputDecoration(
                hintText: "0715645349",
                filled: true,
                fillColor: const Color(0xFFF6FAF8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Add your edit functionality here
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              ),
              style: const TextStyle(fontWeight: FontWeight.normal), // Text inside text box should not be bold
            ),
            const SizedBox(height: 30),

            // Log Out Button
            ElevatedButton(
              onPressed: () {
                // Add log out functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF027335), // Green background
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Rounded corners
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(fontSize: 18, color: Colors.white),  // White text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
