import 'package:equatable/equatable.dart';

class MarsPhotoEntity extends Equatable {
  final int id;
  final String imgSrc;
  final String earthDate;
  final int sol;
  final MarsRoverEntity rover;
  final MarsCameraEntity camera;

  const MarsPhotoEntity({
    required this.id,
    required this.imgSrc,
    required this.earthDate,
    required this.sol,
    required this.rover,
    required this.camera,
  });

  @override
  List<Object> get props => [id, imgSrc, earthDate, sol, rover, camera];
}

class MarsRoverEntity extends Equatable {
  final int id;
  final String name;
  final String landingDate;
  final String launchDate;
  final String status;

  const MarsRoverEntity({
    required this.id,
    required this.name,
    required this.landingDate,
    required this.launchDate,
    required this.status,
  });

  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object> get props => [id, name, landingDate, launchDate, status];
}

class MarsCameraEntity extends Equatable {
  final int id;
  final String name;
  final String fullName;
  final int roverId;

  const MarsCameraEntity({
    required this.id,
    required this.name,
    required this.fullName,
    required this.roverId,
  });

  @override
  List<Object> get props => [id, name, fullName, roverId];
}