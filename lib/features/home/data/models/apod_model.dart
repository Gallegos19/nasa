import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/apod_entity.dart';

part 'apod_model.g.dart';

@JsonSerializable()
class ApodModel extends ApodEntity {
  @JsonKey(name: 'media_type')
  final String? mediaType;

  const ApodModel({
    required String date,
    required String explanation,
    required String title,
    required String url,
    String? hdurl,
    this.mediaType,
    String? copyright,
  }) : super(
    date: date,
    explanation: explanation,
    title: title,
    url: url,
    hdurl: hdurl,
    mediaType: mediaType,
    copyright: copyright,
  );

  factory ApodModel.fromJson(Map<String, dynamic> json) => _$ApodModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApodModelToJson(this);

  factory ApodModel.fromEntity(ApodEntity entity) {
    return ApodModel(
      date: entity.date,
      explanation: entity.explanation,
      title: entity.title,
      url: entity.url,
      hdurl: entity.hdurl,
      mediaType: entity.mediaType,
      copyright: entity.copyright,
    );
  }
}
