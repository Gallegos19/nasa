import '../../domain/entities/neo_entity.dart';

class NeoModel extends NeoEntity {
  const NeoModel({
    required String id,
    required String name,
    required String neoReferenceId,
    required bool isPotentiallyHazardous,
    required double estimatedDiameterMin,
    required double estimatedDiameterMax,
    required List<CloseApproachModel> closeApproachData,
  }) : super(
    id: id,
    name: name,
    neoReferenceId: neoReferenceId,
    isPotentiallyHazardous: isPotentiallyHazardous,
    estimatedDiameterMin: estimatedDiameterMin,
    estimatedDiameterMax: estimatedDiameterMax,
    closeApproachData: closeApproachData,
  );

  factory NeoModel.fromJson(Map<String, dynamic> json) {
    // Parse estimated diameter
    final diameter = json['estimated_diameter'] as Map<String, dynamic>? ?? {};
    final kmDiameter = diameter['kilometers'] as Map<String, dynamic>? ?? {};
    
    final diameterMin = (kmDiameter['estimated_diameter_min'] as num?)?.toDouble() ?? 0.0;
    final diameterMax = (kmDiameter['estimated_diameter_max'] as num?)?.toDouble() ?? 0.0;

    // Parse close approach data
    final approachList = json['close_approach_data'] as List<dynamic>? ?? [];
    final approaches = approachList
        .map((item) => CloseApproachModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return NeoModel(
      id: json['id'] as String,
      name: json['name'] as String,
      neoReferenceId: json['neo_reference_id'] as String,
      isPotentiallyHazardous: json['is_potentially_hazardous_asteroid'] as bool,
      estimatedDiameterMin: diameterMin,
      estimatedDiameterMax: diameterMax,
      closeApproachData: approaches,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'neo_reference_id': neoReferenceId,
      'is_potentially_hazardous_asteroid': isPotentiallyHazardous,
      'estimated_diameter': {
        'kilometers': {
          'estimated_diameter_min': estimatedDiameterMin,
          'estimated_diameter_max': estimatedDiameterMax,
        }
      },
      'close_approach_data': closeApproachData
          .map((approach) => (approach as CloseApproachModel).toJson())
          .toList(),
    };
  }
}

class CloseApproachModel extends CloseApproachEntity {
  const CloseApproachModel({
    required String closeApproachDate,
    required double relativeVelocity,
    required double missDistance,
    required String orbitingBody,
  }) : super(
    closeApproachDate: closeApproachDate,
    relativeVelocity: relativeVelocity,
    missDistance: missDistance,
    orbitingBody: orbitingBody,
  );

  factory CloseApproachModel.fromJson(Map<String, dynamic> json) {
    // Parse velocity - CORREGIDO
    final velocity = json['relative_velocity'] as Map<String, dynamic>? ?? {};
    final velocityValue = double.tryParse(velocity['kilometers_per_hour']?.toString() ?? '0') ?? 0.0;

    // Parse distance - CORREGIDO
    final distance = json['miss_distance'] as Map<String, dynamic>? ?? {};
    final distanceValue = double.tryParse(distance['kilometers']?.toString() ?? '0') ?? 0.0;

    return CloseApproachModel(
      closeApproachDate: json['close_approach_date'] as String,
      relativeVelocity: velocityValue,
      missDistance: distanceValue,
      orbitingBody: json['orbiting_body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'close_approach_date': closeApproachDate,
      'relative_velocity': {
        'kilometers_per_hour': relativeVelocity.toString(),
      },
      'miss_distance': {
        'kilometers': missDistance.toString(),
      },
      'orbiting_body': orbitingBody,
    };
  }
}