import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class CandidateResult {
  final String name;
  final String position;
  final String job;
  final int voteCount;
  final ImageProvider<Object>? image;

  CandidateResult({
    required this.name,
    required this.position,
    required this.job,
    required this.voteCount,
    this.image,
  });

  factory CandidateResult.fromJson(Map<String, dynamic> json, String position) {
    return CandidateResult(
      name: json['candidate_name'] ?? '',
      position: position,
      job: json['job'] ?? '',
      voteCount: json['votes_count'] ?? 0,
      image: Assets.images.voteday.image().image,
    );
  }
}
