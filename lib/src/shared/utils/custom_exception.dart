// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class CustomException implements Exception {
  final String message;
  final Map<String, dynamic> translations;
  CustomException({
    required this.message,
    required this.translations,
  });

  CustomException copyWith({
    String? message,
    Map<String, dynamic>? translations,
  }) {
    return CustomException(
      message: message ?? this.message,
      translations: translations ?? this.translations,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'translations': translations,
    };
  }

  factory CustomException.fromMap(Map<String, dynamic> map) {
    return CustomException(
      message: map['message'] as String,
      translations: Map<String, dynamic>.from(
          (map['translations'] as Map<String, dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomException.fromJson(String source) =>
      CustomException.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomException(message: $message, translations: $translations)';

  @override
  bool operator ==(covariant CustomException other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        mapEquals(other.translations, translations);
  }

  @override
  int get hashCode => message.hashCode ^ translations.hashCode;
}
