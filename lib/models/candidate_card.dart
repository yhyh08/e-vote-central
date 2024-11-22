import 'package:flutter/material.dart';

class CandidateDetail {
  final String name;
  final String title;
  final String address;
  final ImageProvider<Object> candidateImage;

  CandidateDetail({
    required this.name,
    required this.title,
    required this.address,
    required this.candidateImage,
  });
}
