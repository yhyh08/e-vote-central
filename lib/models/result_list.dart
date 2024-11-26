import 'package:flutter/material.dart';

import '../gen/assets.gen.dart';

class ResultList {
  final String resultTitle;
  final String resultPassDay;
  final ImageProvider<Object> resultImage;
  // final void Function()? onPressed;

  ResultList({
    required this.resultTitle,
    required this.resultPassDay,
    required this.resultImage,
    // required this.onPressed,
  });
}

final List<ResultList> results = [
  ResultList(
    resultTitle: 'Election 5',
    resultPassDay: '1 day ago',
    resultImage: Assets.images.logo.image().image,
  ),
  ResultList(
    resultTitle: 'Election 6',
    resultPassDay: '1 day ago',
    resultImage: Assets.images.logo.image().image,
  ),
];
