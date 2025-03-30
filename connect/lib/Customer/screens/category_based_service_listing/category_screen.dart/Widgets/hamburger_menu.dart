import 'package:flutter/material.dart';
import 'package:connect/Customer/screens/Signup/profile_view.dart'; // Import Profile view screen

class Hamburgermenu extends StatelessWidget {
  const Hamburgermenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Set the background color of the drawer to white
      child: Container(
        color: Colors.white, // Set background color of the drawer to white
        child: Column(
          children: [
            // Drawer Header with profile picture and name (Remove const)
            SizedBox(
              height: 150, // Adjusted height of the header
              child: DrawerHeader(
                padding: EdgeInsets.all(0),  // Remove extra padding
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFF027335), // Green bottom border color
                      width: 2, // Border width
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Profile picture moved to the right
                    Padding(
                      padding: EdgeInsets.only(left: 15), // Adjusted padding to move it right
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/Menu_Icons/ProfilePicture.png'), // Replace with your image path
                        radius: 30, // Increased size of the profile picture
                      ),
                    ),
                    SizedBox(width: 20),  // Increased space between the profile picture and the name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                      children: [
                        // Increased padding above the text to move it down
                        SizedBox(height: 40), // Moved the text further down vertically
                        Row(
                          children: [
                            Text(
                              "Leo Perera",
                              style: TextStyle(
                                color: Colors.black, // Set text color to black
                                fontSize: 22, // Increased font size of the name
                              ),
                            ),
                            const SizedBox(width: 10), // Added more space between the name and the arrow
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF027335),
                                size: 22,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProfileViewScreen()), // Navigate to ProfileViewScreen
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // List of menu items with custom icons
            _buildMenuItem(context, 'Home.png', "Home", 20),
            _buildMenuItem(context, 'Services.png', "Services", 20),
            _buildMenuItem(context, 'Servicecategories.png', "Service Categories", 20),
            _buildMenuItem(context, 'Bookings.png', "Bookings", 20),
            _buildMenuItem(context, 'chats.png', "Chats", 20),
            _buildMenuItem(context, 'Notifications.png', "Notifications", 20),
            _buildMenuItem(context, 'settings.png', "Settings", 20),
            _buildMenuItem(context, 'support.png', "Support", 20),
            _buildMenuItem(context, 'logout.png', "Logout", 20),
          ],
        ),
      ),
    );
  }

  // Helper function to create a menu item with a custom icon (image)
  Widget _buildMenuItem(BuildContext context, String iconName, String title, double fontSize) {
    return ListTile(
      leading: Image.asset(
        'assets/images/Menu_Icons/$iconName', // Replace with the actual folder path and icon name
        width: 30,  // Increased the icon size
        height: 30,
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 15.0),  // Increased distance between text and icon
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20, // Increased the font size of the menu items
          ),
        ),
      ),
      onTap: () {
        // Implement navigation logic here
        Navigator.pop(context); // Close the drawer when an item is tapped
      },
    );
  }
}
