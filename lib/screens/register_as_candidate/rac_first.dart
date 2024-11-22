import 'package:flutter/material.dart';

class RegisterCandidatePage extends StatefulWidget {
  const RegisterCandidatePage({super.key});

  @override
  State<RegisterCandidatePage> createState() => _RegisterCandidatePageState();
}

class _RegisterCandidatePageState extends State<RegisterCandidatePage> {
  String? selectedOption; // Holds the selected dropdown value

  final List<String> electionOptions = [
    'Election 1',
    'Election 2',
    'Election 3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Register as Candidate',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Stepper-like Progress Indicator
          Container(
            color: Colors.purple,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stepIcon(Icons.people, true),
                stepDivider(),
                stepIcon(Icons.notifications, false),
                stepDivider(),
                stepIcon(Icons.person, false),
                stepDivider(),
                stepIcon(Icons.share, false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Election Information Text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Election Information',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Dropdown for Election
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Election',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              value: selectedOption,
              items: electionOptions
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
          ),
          const Spacer(),
          // Next Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  if (selectedOption != null) {
                    // Navigate to the next step
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const NextPage(), // Replace with your next page widget
                      ),
                    );
                  } else {
                    // Show error if no option selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an election.'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Progress step icon widget
  Widget stepIcon(IconData icon, bool isActive) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive ? Colors.white : Colors.purple.shade300,
      child: Icon(
        icon,
        color: isActive ? Colors.purple : Colors.white,
        size: 20,
      ),
    );
  }

  // Divider between steps
  Widget stepDivider() {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: Colors.white,
      ),
    );
  }
}

// Dummy next page for navigation
class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Page'),
      ),
      body: const Center(
        child: Text('This is the next page.'),
      ),
    );
  }
}
