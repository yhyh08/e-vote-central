import 'package:flutter/material.dart';

class Experience {
  final IconData? icon;
  final String companyName;
  final String position;
  final String duration;
  final List<String> skills;

  Experience({
    this.icon,
    required this.companyName,
    required this.position,
    required this.duration,
    required this.skills,
  });
}
