import 'package:equatable/equatable.dart';

class ApodEntity extends Equatable {
  final String date;
  final String explanation;
  final String title;
  final String url;
  final String? hdurl;
  final String? mediaType;
  final String? copyright;

  const ApodEntity({
    required this.date,
    required this.explanation,
    required this.title,
    required this.url,
    this.hdurl,
    this.mediaType,
    this.copyright,
  });

  bool get isVideo => mediaType == 'video';
  bool get isImage => mediaType == 'image' || mediaType == null;
  String get displayUrl => hdurl ?? url;

  @override
  List<Object?> get props => [
    date,
    explanation,
    title,
    url,
    hdurl,
    mediaType,
    copyright,
  ];
}