import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        // foregroundColor: Colors.teal,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // CircleAvatar showing my initials
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.teal,
              child: Text(
                'AC',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Awongu Agabi Therese-Claire',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Student ID: LMUI250709',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 4),

            Text(
              'Software Engineering',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Bio section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About Me',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // ← CHANGE TO YOUR REAL 2-3 SENTENCE BIO
            const Text(
              'I am a creative tech enthusiast, entrepreneur, and digital marketer passionate about innovation, branding '
                  'and problem-solving. As the co-founder and Head of Marketing & Social Media at Pikup,'
                  'I enjoy building impactful solutions and connecting with people through creative strategies.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),

            const SizedBox(height: 24),

            // Goals section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Goals This Semester',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            _goalTile('1. Get a good GPA'),
            _goalTile('2. Build at least two personal Flutter projects'),
            _goalTile('3. Enhance my machine learning skills'),
          ],
        ),
      ),
    );
  }

  // Helper method that builds one goal row
  Widget _goalTile(String goal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(goal, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}