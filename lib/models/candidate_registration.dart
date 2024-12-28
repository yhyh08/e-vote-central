class CandidateRegistration {
  final int id;
  final String candName;
  final String electionTopic;
  final String status;
  final DateTime createdAt;

  CandidateRegistration({
    required this.id,
    required this.candName,
    required this.electionTopic,
    required this.status,
    required this.createdAt,
  });

  String get formattedDate {
    return '${createdAt.difference(DateTime.now()).inDays.abs()} days ago';
  }

  factory CandidateRegistration.fromJson(Map<String, dynamic> json) {
    return CandidateRegistration(
      id: json['id'] ?? 0,
      candName: json['candidate_name'] ?? 'Unknown Name',
      electionTopic: json['election_topic'] ?? 'Unknown Topic',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
