import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/vote_provider.dart';
import '../../../services/vote_service.dart';

class ElectionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoteProvider(
        VoteService(), // Initialize your VoteService here
      ),
      child: Scaffold(
          // Your existing ElectionDetail screen content
          // Now CandidateProfile will have access to VoteProvider
          ),
    );
  }
}
