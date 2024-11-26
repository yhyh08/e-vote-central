import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class CandidateResult {
  final String name;
  final String role;
  final ImageProvider<Object> image;
  final int votes;
  final int percentage;

  CandidateResult({
    required this.name,
    required this.role,
    required this.image,
    required this.votes,
    required this.percentage,
  });
}

List<CandidateResult> candidates = [
  CandidateResult(
    name: "Daniel Chengi",
    role: "Software Engineer",
    image: Assets.images.voteday.image().image,
    votes: 250,
    percentage: 83,
  ),
  CandidateResult(
    name: "Taylor Selene",
    role: "Software Engineer",
    image: Assets.images.voteday.image().image,
    votes: 50,
    percentage: 17,
  ),
];
