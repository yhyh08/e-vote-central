import 'package:flutter/material.dart';

class Candidate {
  final String name;
  final String role;
  final ImageProvider<Object> image;
  final int votes;
  final int percentage;

  Candidate({
    required this.name,
    required this.role,
    required this.image,
    required this.votes,
    required this.percentage,
  });
}
