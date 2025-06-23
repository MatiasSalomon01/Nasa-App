import 'dart:convert';

class ADOPResponse {
  final String? copyright;
  final DateTime date;
  final String explanation;
  final String hdurl;
  final String mediaType;
  final String serviceVersion;
  final String title;
  final String url;

  ADOPResponse({
    required this.date,
    required this.explanation,
    required this.hdurl,
    required this.mediaType,
    required this.serviceVersion,
    required this.title,
    required this.url,
    this.copyright,
  });

  factory ADOPResponse.fromRawJson(String str) =>
      ADOPResponse.fromJson(json.decode(str));

  factory ADOPResponse.fromJson(Map<String, dynamic> json) => ADOPResponse(
    copyright: json["copyright"]?.toString().replaceAll('\n', ''),
    date: DateTime.parse(json["date"]),
    explanation: json["explanation"],
    hdurl: json["hdurl"],
    mediaType: json["media_type"],
    serviceVersion: json["service_version"],
    title: json["title"],
    url: json["url"],
  );
}
