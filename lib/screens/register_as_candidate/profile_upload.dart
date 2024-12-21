import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.purple, // Use your theme color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Update Profile Card
              Card(
                color: Colors.purple.shade50, // Light purple background
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.purple.shade400,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Fill in your personal information to vote',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          // Navigate to Update Profile screen
                        },
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            color: Colors.purple.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List of Options
              ListTile(
                leading: const Icon(Icons.person_outline, color: Colors.purple),
                title: const Text('Personal details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Personal Details screen
                },
              ),
              const Divider(),

              ListTile(
                leading:
                    const Icon(Icons.business_outlined, color: Colors.purple),
                title: const Text('Organization'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Organization screen
                },
              ),
              const Divider(),

              ListTile(
                leading:
                    const Icon(Icons.language_outlined, color: Colors.purple),
                title: const Text('Languages'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to Languages screen
                },
              ),
              const Divider(),

              // Sign Out Button
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Handle sign-out logic
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
