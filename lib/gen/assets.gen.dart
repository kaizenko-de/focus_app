// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/dashboard.png
  AssetGenImage get dashboard =>
      const AssetGenImage('assets/images/dashboard.png');

  /// File path: assets/images/dissatisfied.png
  AssetGenImage get dissatisfied =>
      const AssetGenImage('assets/images/dissatisfied.png');

  /// File path: assets/images/journal.png
  AssetGenImage get journal => const AssetGenImage('assets/images/journal.png');

  /// File path: assets/images/neutral.png
  AssetGenImage get neutral => const AssetGenImage('assets/images/neutral.png');

  /// File path: assets/images/routine_add.png
  AssetGenImage get routineAdd =>
      const AssetGenImage('assets/images/routine_add.png');

  /// File path: assets/images/routines.png
  AssetGenImage get routines =>
      const AssetGenImage('assets/images/routines.png');

  /// File path: assets/images/satisfied.png
  AssetGenImage get satisfied =>
      const AssetGenImage('assets/images/satisfied.png');

  /// File path: assets/images/settings.png
  AssetGenImage get settings =>
      const AssetGenImage('assets/images/settings.png');

  /// File path: assets/images/suppliments.png
  AssetGenImage get suppliments =>
      const AssetGenImage('assets/images/suppliments.png');

  /// File path: assets/images/very_dissatified.png
  AssetGenImage get veryDissatified =>
      const AssetGenImage('assets/images/very_dissatified.png');

  /// File path: assets/images/verysatisfied.png
  AssetGenImage get verysatisfied =>
      const AssetGenImage('assets/images/verysatisfied.png');

  /// List of all assets
  List<AssetGenImage> get values => [
    dashboard,
    dissatisfied,
    journal,
    neutral,
    routineAdd,
    routines,
    satisfied,
    settings,
    suppliments,
    veryDissatified,
    verysatisfied,
  ];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/gradient_line.svg
  String get gradientLine => 'assets/svg/gradient_line.svg';

  /// File path: assets/svg/star.svg
  String get star => 'assets/svg/star.svg';

  /// List of all assets
  List<String> get values => [gradientLine, star];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

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
    FilterQuality filterQuality = FilterQuality.medium,
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

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
