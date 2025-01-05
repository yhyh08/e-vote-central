class CandidateResult {
  final String name;
  final String position;
  final String job;
  final int voteCount;
  final double percentage;
  final String? image;

  CandidateResult({
    required this.name,
    required this.position,
    required this.job,
    required this.voteCount,
    required this.percentage,
    this.image,
  });

  factory CandidateResult.fromJson(Map<String, dynamic> json, String position) {
    return CandidateResult(
      name: json['candidate_name'] ?? '',
      position: position,
      job: json['job'] ?? '',
      voteCount: json['votes_count'] ?? 0,
      percentage: (json['percentage'] ?? 0).toDouble(),
      image: json['candidate_image'],
    );
  }
}
