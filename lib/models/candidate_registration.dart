import 'package:intl/intl.dart';

class CandidateRegistration {
  final int id;
  final String candName;
  final String electionTopic;
  final String status;
  final String createdAt;

  CandidateRegistration({
    required this.id,
    required this.candName,
    required this.electionTopic,
    required this.status,
    required this.createdAt,
  });

  factory CandidateRegistration.fromJson(Map<String, dynamic> json) {
    // Parse the date and format it to 'yyyy-MM-dd'
    final date = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return CandidateRegistration(
      id: json['id'] ?? 0,
      candName: json['candidate_name'] ?? 'Unknown Name',
      electionTopic: json['election_topic'] ?? 'Unknown Topic',
      status: json['status'] ?? 'pending',
      createdAt: formattedDate,
    );
  }
}
