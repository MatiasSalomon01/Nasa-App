import 'dart:convert';

class EPICResponse {
  final String identifier;
  final String caption;
  final String image;
  late final String imageUrl;
  final String version;
  final CentroidCoordinates centroidCoordinates;
  final J2000Position dscovrJ2000Position;
  final J2000Position lunarJ2000Position;
  final J2000Position sunJ2000Position;
  final AttitudeQuaternions attitudeQuaternions;
  final DateTime date;
  final Coords coords;

  EPICResponse({
    required this.identifier,
    required this.caption,
    required this.image,
    required this.version,
    required this.centroidCoordinates,
    required this.dscovrJ2000Position,
    required this.lunarJ2000Position,
    required this.sunJ2000Position,
    required this.attitudeQuaternions,
    required this.date,
    required this.coords,
  });

  factory EPICResponse.fromJson(Map<String, dynamic> json) {
    var model = EPICResponse(
      identifier: json["identifier"],
      caption: json["caption"],
      image: json["image"],
      version: json["version"],
      centroidCoordinates: CentroidCoordinates.fromJson(
        json["centroid_coordinates"],
      ),
      dscovrJ2000Position: J2000Position.fromJson(
        json["dscovr_j2000_position"],
      ),
      lunarJ2000Position: J2000Position.fromJson(json["lunar_j2000_position"]),
      sunJ2000Position: J2000Position.fromJson(json["sun_j2000_position"]),
      attitudeQuaternions: AttitudeQuaternions.fromJson(
        json["attitude_quaternions"],
      ),
      date: DateTime.parse(json["date"]),
      coords: Coords.fromJson(json["coords"]),
    );

    model.imageUrl = buildImageUrl(model.image, model.date);

    return model;
  }

  static String buildImageUrl(String image, DateTime date) {
    var year = date.year;
    var month = date.month.toString().padLeft(2, '0');
    var day = date.day.toString().padLeft(2, '0');

    return 'https://epic.gsfc.nasa.gov/archive/natural/$year/$month/$day/jpg/$image.jpg';
  }

  Map<String, dynamic> toJson() => {
    "identifier": identifier,
    "caption": caption,
    "image": image,
    "version": version,
    "centroid_coordinates": centroidCoordinates.toJson(),
    "dscovr_j2000_position": dscovrJ2000Position.toJson(),
    "lunar_j2000_position": lunarJ2000Position.toJson(),
    "sun_j2000_position": sunJ2000Position.toJson(),
    "attitude_quaternions": attitudeQuaternions.toJson(),
    "date": date.toIso8601String(),
    "coords": coords.toJson(),
  };
}

class AttitudeQuaternions {
  final double q0;
  final double q1;
  final double q2;
  final double q3;

  AttitudeQuaternions({
    required this.q0,
    required this.q1,
    required this.q2,
    required this.q3,
  });

  factory AttitudeQuaternions.fromRawJson(String str) =>
      AttitudeQuaternions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttitudeQuaternions.fromJson(Map<String, dynamic> json) =>
      AttitudeQuaternions(
        q0: json["q0"]?.toDouble(),
        q1: json["q1"]?.toDouble(),
        q2: json["q2"]?.toDouble(),
        q3: json["q3"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {"q0": q0, "q1": q1, "q2": q2, "q3": q3};
}

class CentroidCoordinates {
  final double lat;
  final double lon;

  CentroidCoordinates({required this.lat, required this.lon});

  factory CentroidCoordinates.fromRawJson(String str) =>
      CentroidCoordinates.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CentroidCoordinates.fromJson(Map<String, dynamic> json) =>
      CentroidCoordinates(
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {"lat": lat, "lon": lon};
}

class Coords {
  final CentroidCoordinates centroidCoordinates;
  final J2000Position dscovrJ2000Position;
  final J2000Position lunarJ2000Position;
  final J2000Position sunJ2000Position;
  final AttitudeQuaternions attitudeQuaternions;

  Coords({
    required this.centroidCoordinates,
    required this.dscovrJ2000Position,
    required this.lunarJ2000Position,
    required this.sunJ2000Position,
    required this.attitudeQuaternions,
  });

  factory Coords.fromRawJson(String str) => Coords.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
    centroidCoordinates: CentroidCoordinates.fromJson(
      json["centroid_coordinates"],
    ),
    dscovrJ2000Position: J2000Position.fromJson(json["dscovr_j2000_position"]),
    lunarJ2000Position: J2000Position.fromJson(json["lunar_j2000_position"]),
    sunJ2000Position: J2000Position.fromJson(json["sun_j2000_position"]),
    attitudeQuaternions: AttitudeQuaternions.fromJson(
      json["attitude_quaternions"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "centroid_coordinates": centroidCoordinates.toJson(),
    "dscovr_j2000_position": dscovrJ2000Position.toJson(),
    "lunar_j2000_position": lunarJ2000Position.toJson(),
    "sun_j2000_position": sunJ2000Position.toJson(),
    "attitude_quaternions": attitudeQuaternions.toJson(),
  };
}

class J2000Position {
  final double x;
  final double y;
  final double z;

  J2000Position({required this.x, required this.y, required this.z});

  factory J2000Position.fromRawJson(String str) =>
      J2000Position.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory J2000Position.fromJson(Map<String, dynamic> json) => J2000Position(
    x: json["x"]?.toDouble(),
    y: json["y"]?.toDouble(),
    z: json["z"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {"x": x, "y": y, "z": z};
}
