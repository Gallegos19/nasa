// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeoModel _$NeoModelFromJson(Map<String, dynamic> json) => NeoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      neoReferenceId: json['neo_reference_id'] as String,
      isPotentiallyHazardous: json['is_potentially_hazardous_asteroid'] as bool,
      estimatedDiameter: json['estimated_diameter'] as Map<String, dynamic>,
      closeApproachData: (json['close_approach_data'] as List<dynamic>)
          .map((e) => CloseApproachModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NeoModelToJson(NeoModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'neo_reference_id': instance.neoReferenceId,
      'is_potentially_hazardous_asteroid': instance.isPotentiallyHazardous,
      'estimated_diameter': instance.estimatedDiameter,
      'close_approach_data': instance.closeApproachData,
    };

CloseApproachModel _$CloseApproachModelFromJson(Map<String, dynamic> json) =>
    CloseApproachModel(
      closeApproachDate: json['close_approach_date'] as String,
      relativeVelocityMap: json['relative_velocity'] as Map<String, dynamic>,
      missDistanceMap: json['miss_distance'] as Map<String, dynamic>,
      orbitingBody: json['orbiting_body'] as String,
    );

Map<String, dynamic> _$CloseApproachModelToJson(CloseApproachModel instance) =>
    <String, dynamic>{
      'close_approach_date': instance.closeApproachDate,
      'relative_velocity': instance.relativeVelocityMap,
      'miss_distance': instance.missDistanceMap,
      'orbiting_body': instance.orbitingBody,
    };
