import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/vote_service.dart';

class VoteProvider extends ChangeNotifier {
  final Set<int> _votedCandidates = {};
  final Map<String, int> _positionVotes = {};
  final VoteService _voteService;

  VoteProvider(this._voteService) {
    loadVoteStatus();
  }

  bool hasVotedFor(int candidateId) {
    return _votedCandidates.contains(candidateId);
  }

  bool hasVotedForPosition(String position) {
    return _positionVotes.containsKey(position);
  }

  Future<void> loadVoteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final votedList = prefs.getStringList('voted_candidates') ?? [];
    _votedCandidates.addAll(votedList.map(int.parse));

    final positionData = prefs.getString('position_votes') ?? '{}';
    final Map<String, dynamic> positionMap = json.decode(positionData);
    _positionVotes
        .addAll(positionMap.map((key, value) => MapEntry(key, value as int)));
    notifyListeners();
  }

  Future<void> voteForCandidate(int candidateId, String position) async {
    if (hasVotedForPosition(position)) {
      throw Exception('You have already voted for this position');
    }

    if (hasVotedFor(candidateId)) {
      throw Exception('You have already voted for this candidate');
    }

    try {
      final success = await _voteService.incrementVoteCount(candidateId);

      if (success) {
        _votedCandidates.add(candidateId);
        _positionVotes[position] = candidateId;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('voted_candidates',
            _votedCandidates.map((id) => id.toString()).toList());
        await prefs.setString('position_votes', json.encode(_positionVotes));

        notifyListeners();
      } else {
        throw Exception('Failed to record vote');
      }
    } catch (e) {
      print('Error voting for candidate: $e');
      rethrow;
    }
  }

  Future<void> clearVotes() async {
    _votedCandidates.clear();
    _positionVotes.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('voted_candidates');
    await prefs.remove('position_votes');

    notifyListeners();
  }

  List<int> getVotedCandidates() {
    return _votedCandidates.toList();
  }

  Map<String, int> getPositionVotes() {
    return Map.from(_positionVotes);
  }
}
