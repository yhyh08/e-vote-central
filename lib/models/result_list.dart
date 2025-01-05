import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class ResultList {
  final String resultTitle;
  final ImageProvider<Object>? resultImage;
  final DateTime startDate;
  final DateTime endDate;
  final int electionId;

  ResultList({
    required this.resultTitle,
    this.resultImage,
    required this.startDate,
    required this.endDate,
    required this.electionId,
  });

  factory ResultList.fromJson(Map<String, dynamic> json) {
    return ResultList(
      resultTitle: json['election_topic'] ?? '',
      resultImage: Assets.images.logo.image().image,
      startDate: DateTime.parse(json['start_date'] ?? ''),
      endDate: DateTime.parse(json['end_date'] ?? ''),
      electionId: json['election_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'election_topic': resultTitle,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'election_id': electionId,
    };
  }
}
