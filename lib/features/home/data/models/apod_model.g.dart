// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apod_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApodModel _$ApodModelFromJson(Map<String, dynamic> json) => ApodModel(
      date: json['date'] as String,
      explanation: json['explanation'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      hdurl: json['hdurl'] as String?,
      mediaType: json['media_type'] as String?,
      copyright: json['copyright'] as String?,
    );

Map<String, dynamic> _$ApodModelToJson(ApodModel instance) => <String, dynamic>{
      'date': instance.date,
      'explanation': instance.explanation,
      'title': instance.title,
      'url': instance.url,
      'hdurl': instance.hdurl,
      'copyright': instance.copyright,
      'media_type': instance.mediaType,
    };
