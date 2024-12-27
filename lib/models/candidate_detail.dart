class CandidateDetail {
  final int id;
  final String name;
  final String gender;
  final String position;
  final String email;
  final String phone;
  final String nationality;
  final String religion;
  final String job;
  final String dob;
  final String biography;
  final String manifesto;
  final String image;
  int votes;

  CandidateDetail({
    required this.id,
    required this.name,
    required this.gender,
    required this.position,
    required this.email,
    required this.phone,
    required this.nationality,
    required this.religion,
    required this.job,
    required this.dob,
    required this.biography,
    required this.manifesto,
    required this.image,
    this.votes = 0,
  });

  CandidateDetail.fromJson(Map<String, dynamic> json)
      : id = json['candidate_id'] ?? 0,
        name = json['candidate_name'] ?? '',
        gender = json['candidate_gender'] ?? '',
        position = json['position'] ?? '',
        email = json['candidate_email'] ?? '',
        phone = json['candidate_phone'] ?? '',
        nationality = json['nationality'] ?? '',
        religion = json['religion'] ?? '',
        job = json['job'] ?? '',
        dob = json['candidate_dob'] ?? '',
        biography = json['short_biography'] ?? '',
        manifesto = json['manifesto'] ?? '',
        image = json['candidate_image'] ?? '',
        votes = 0;
}
