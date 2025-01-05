import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class ResultList {
  final String resultTitle;
  final ImageProvider<Object>? resultImage;
  final DateTime startDate;
  final DateTime endDate;

  ResultList({
    required this.resultTitle,
    this.resultImage,
    required this.startDate,
    required this.endDate,
  });

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      resultTitle: json['election_topic'] ?? '',
      resultImage: Assets.images.logo.image().image,
      startDate: DateTime.parse(json['start_date'] ?? ''),
      endDate: DateTime.parse(json['end_date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'election_topic': resultTitle,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
