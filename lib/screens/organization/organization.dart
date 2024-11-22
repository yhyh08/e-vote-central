import 'package:flutter/material.dart';

class OrganizationPage extends StatefulWidget {
  const OrganizationPage({super.key});

  @override
  State<OrganizationPage> createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  final List<Map<String, dynamic>> organizations = [
    {
      'name': 'Organization 1',
      'category': 'Category',
      'color': Colors.black,
      'status': '',
    },
    {
      'name': 'Organization 2',
      'category': 'Category',
      'color': Colors.blue,
      'status': '',
    },
    {
      'name': 'Organization 3',
      'category': 'Category',
      'color': Colors.pink,
      'status': '',
    },
    {
      'name': 'Organization 4',
      'category': 'Category',
      'color': Colors.orange,
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Organization',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Organization',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: organizations.length + 1, // +1 for the "Add" card
                itemBuilder: (context, index) {
                  if (index < organizations.length) {
                    final organization = organizations[index];
                    return OrganizationCard(
                      name: organization['name'],
                      category: organization['category'],
                      color: organization['color'],
                      status: organization['status'],
                    );
                  } else {
                    return AddOrganizationCard(
                      onTap: () {
                        // Handle add organization logic
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 4, // Assuming "Account" is the fifth tab
        onTap: (index) {
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: 'Election',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Result',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Apply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}

class OrganizationCard extends StatelessWidget {
  final String name;
  final String category;
  final Color color;
  final String status;

  const OrganizationCard({
    super.key,
    required this.name,
    required this.category,
    required this.color,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color,
              child: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            if (status.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.purple,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AddOrganizationCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddOrganizationCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 4,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
