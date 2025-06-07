import 'package:equatable/equatable.dart';

class NeoEntity extends Equatable {
  final String id;
  final String name;
  final String neoReferenceId;
  final bool isPotentiallyHazardous;
  final double estimatedDiameterMin;
  final double estimatedDiameterMax;
  final List<CloseApproachEntity> closeApproachData;

  const NeoEntity({
    required this.id,
    required this.name,
    required this.neoReferenceId,
    required this.isPotentiallyHazardous,
    required this.estimatedDiameterMin,
    required this.estimatedDiameterMax,
    required this.closeApproachData,
  });

  double get averageDiameter => (estimatedDiameterMin + estimatedDiameterMax) / 2;
  
  CloseApproachEntity? get nextCloseApproach {
    if (closeApproachData.isEmpty) return null;
    return closeApproachData.first;
  }

  @override
  List<Object> get props => [
    id,
    name,
    neoReferenceId,
    isPotentiallyHazardous,
    estimatedDiameterMin,
    estimatedDiameterMax,
    closeApproachData,
  ];
}

class CloseApproachEntity extends Equatable {
  final String closeApproachDate;
  final double relativeVelocity;
  final double missDistance;
  final String orbitingBody;

  const CloseApproachEntity({
    required this.closeApproachDate,
    required this.relativeVelocity,
    required this.missDistance,
    required this.orbitingBody,
  });

  @override
  List<Object> get props => [
    closeApproachDate,
    relativeVelocity,
    missDistance,
    orbitingBody,
  ];
}