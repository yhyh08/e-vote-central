import 'package:e_vote/network_utlis/api_constant.dart';
import 'package:e_vote/services/vote_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class VoteProvider extends ChangeNotifier {
  final Set<int> _votedCandidates = {};
  final Map<String, int> _positionVotes = {};

  VoteProvider(VoteService voteService);

  bool hasVotedFor(int candidateId) {
    return _votedCandidates.contains(candidateId);
  }

  bool hasVotedForPosition(String position) {
    return _positionVotes.containsKey(position);
  }

  Future<void> voteForCandidate(int candidateId, String position) async {
    if (hasVotedForPosition(position)) {
      return;
    }

    try {
      // Make API call to update vote count in Laravel backend
      final response = await http.post(
        Uri.parse('$serverApiUrl/candidate/$candidateId/vote'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add any authentication headers if needed
          // 'Authorization': 'Bearer ${your_token}',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update vote count: ${response.body}');
      }

      // Update local state
      _votedCandidates.add(candidateId);
      _positionVotes[position] = candidateId;

      notifyListeners();
    } catch (e) {
      print('Error voting for candidate: $e');
      rethrow;
    }
  }

  void clearVotes() {
    _votedCandidates.clear();
    _positionVotes.clear();
    notifyListeners();
  }
}
