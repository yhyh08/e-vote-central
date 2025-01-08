import 'package:flutter/material.dart';

class RegisterNomination extends StatefulWidget {
  const RegisterNomination({super.key});

  @override
  State<RegisterNomination> createState() => _RegisterNominationState();
}

class _RegisterNominationState extends State<RegisterNomination> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final List<Map<String, String>> nominees = [];

  void addNominee() {
    if (emailController.text.isNotEmpty && reasonController.text.isNotEmpty) {
      setState(() {
        nominees.add({
          'email': emailController.text,
          'reason': reasonController.text,
        });
        emailController.clear();
        reasonController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields before adding a nominee.'),
        ),
      );
    }
  }

  void removeNominee(int index) {
    setState(() {
      nominees.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register as Candidate'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  stepIcon(Icons.how_to_vote, isActive: true),
                  stepDivider(),
                  stepIcon(Icons.manage_accounts_outlined),
                  stepDivider(),
                  stepIcon(Icons.person_outlined),
                  stepDivider(),
                  stepIcon(Icons.file_upload_outlined),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'Nomination Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // First Nominee Fields
              const Text('First Nominee'),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Add Nominee Button
              ElevatedButton.icon(
                onPressed: addNominee,
                icon: const Icon(Icons.add),
                label: const Text('Add Nominee'),
              ),

              const SizedBox(height: 20),

              // Display Nominees
              if (nominees.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nominees.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Email: ${nominees[index]['email']!}'),
                      subtitle: Text('Reason: ${nominees[index]['reason']!}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeNominee(index),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nominees.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Please add at least one nominee before proceeding.'),
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Proceeding to the next step...'),
                        ),
                      );
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Step Icon Widget
  Widget stepIcon(IconData icon, {bool isActive = false}) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: isActive ? Colors.purple : Colors.grey.shade300,
      child: Icon(
        icon,
        color: isActive ? Colors.white : Colors.grey,
      ),
    );
  }

  // Step Divider Widget
  Widget stepDivider() {
    return const Expanded(
      child: Divider(
        color: Colors.grey,
        thickness: 2,
      ),
    );
  }
}
