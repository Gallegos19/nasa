import '../../domain/entities/mars_photo_entity.dart';

class MarsPhotoModel extends MarsPhotoEntity {
  const MarsPhotoModel({
    required int id,
    required String imgSrc,
    required String earthDate,
    required int sol,
    required MarsRoverModel rover,
    required MarsCameraModel camera,
  }) : super(
    id: id,
    imgSrc: imgSrc,
    earthDate: earthDate,
    sol: sol,
    rover: rover,
    camera: camera,
  );

  factory MarsPhotoModel.fromJson(Map<String, dynamic> json) {
    return MarsPhotoModel(
      id: json['id'] as int,
      imgSrc: json['img_src'] as String,
      earthDate: json['earth_date'] as String,
      sol: json['sol'] as int,
      rover: MarsRoverModel.fromJson(json['rover'] as Map<String, dynamic>),
      camera: MarsCameraModel.fromJson(json['camera'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'img_src': imgSrc,
      'earth_date': earthDate,
      'sol': sol,
      'rover': (rover as MarsRoverModel).toJson(),
      'camera': (camera as MarsCameraModel).toJson(),
    };
  }
}

class MarsRoverModel extends MarsRoverEntity {
  const MarsRoverModel({
    required int id,
    required String name,
    required String landingDate,
    required String launchDate,
    required String status,
  }) : super(
    id: id,
    name: name,
    landingDate: landingDate,
    launchDate: launchDate,
    status: status,
  );

  factory MarsRoverModel.fromJson(Map<String, dynamic> json) {
    return MarsRoverModel(
      id: json['id'] as int,
      name: json['name'] as String,
      landingDate: json['landing_date'] as String,
      launchDate: json['launch_date'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'landing_date': landingDate,
      'launch_date': launchDate,
      'status': status,
    };
  }
}

class MarsCameraModel extends MarsCameraEntity {
  const MarsCameraModel({
    required int id,
    required String name,
    required String fullName,
    required int roverId,
  }) : super(
    id: id,
    name: name,
    fullName: fullName,
    roverId: roverId,
  );

  factory MarsCameraModel.fromJson(Map<String, dynamic> json) {
    return MarsCameraModel(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      roverId: json['rover_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'rover_id': roverId,
    };
  }
}
