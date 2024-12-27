// import 'package:flutter/material.dart';

// import '../gen/assets.gen.dart';

class CandidateDetail {
  final int id;
  final String name;
  final String gender;
  final String position;
  final String email;
  final String image;

  CandidateDetail.fromJson(Map<String, dynamic> json)
      : id = json['candidate_id'] ?? 0,
        name = json['candidate_name'] ?? '',
        gender = json['candidate_gender'] ?? '',
        position = json['position'] ?? '',
        email = json['candidate_email'] ?? '',
        image = json['candidate_image'] ?? '';
}
