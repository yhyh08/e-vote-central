/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/logohoritext.png
  AssetGenImage get logohoritext =>
      const AssetGenImage('assets/images/logohoritext.png');

  /// File path: assets/images/sitelogo.png
  AssetGenImage get sitelogo =>
      const AssetGenImage('assets/images/sitelogo.png');

  /// File path: assets/images/userlogo.jpg
  AssetGenImage get userlogo =>
      const AssetGenImage('assets/images/userlogo.jpg');

  /// File path: assets/images/voteday.jpg
  AssetGenImage get voteday => const AssetGenImage('assets/images/voteday.jpg');

  /// File path: assets/images/voteday1.jpg
  AssetGenImage get voteday1 =>
      const AssetGenImage('assets/images/voteday1.jpg');

  /// List of all assets
  List<AssetGenImage> get values =>
      [logo, logohoritext, sitelogo, userlogo, voteday, voteday1];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/eye_close.svg
  String get eyeClose => 'assets/svg/eye_close.svg';

  /// File path: assets/svg/eye_open.svg
  String get eyeOpen => 'assets/svg/eye_open.svg';

  /// List of all assets
  List<String> get values => [eyeClose, eyeOpen];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
