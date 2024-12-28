import 'package:e_vote/network_utlis/api_constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VoteService {
  Future<bool> incrementVoteCount(int candidateId) async {
    try {
      final response = await http.post(
        Uri.parse('$serverApiUrl/candidate/$candidateId/vote'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Add any auth headers if needed
          // 'Authorization': 'Bearer $token',
        },
      );

      // Print response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update vote count: ${response.body}');
      }

      final data = json.decode(response.body);
      return data['success'] ?? false;
    } catch (e) {
      print('Error in VoteService: $e');
      rethrow;
    }
  }
}
