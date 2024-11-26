import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class CandidateDetail {
  final String name;
  final String role;
  final String address;
  final ImageProvider<Object> candidateImage;
  final int? countVote;
  final int? percentage;

  CandidateDetail({
    required this.name,
    required this.role,
    required this.address,
    required this.candidateImage,
    this.countVote,
    this.percentage,
  });
}

final List<CandidateDetail> candidates = [
  CandidateDetail(
    name: 'Daniel Jackson',
    role: 'Software Engineer',
    address: '1789 North Street, San Antonio, TX 78201',
    candidateImage: Assets.images.voteday.image().image,
  ),
  CandidateDetail(
    name: 'Christina Eng',
    role: 'Teacher',
    address: '1789 North Street, San Antonio, TX 78201',
    candidateImage: Assets.images.voteday.image().image,
  ),
];
