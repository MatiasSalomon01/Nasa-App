import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ADOPProvider extends ChangeNotifier {
  ADOPResponse? adop;

  bool isLoading = false;

  String? date;

  Future getPicture({String? date}) async {
    isLoading = true;
    this.date = date;
    notifyListeners();

    var parameters = {'api_key': dotenv.get('NASA_API_KEY')};

    if (date != null) {
      parameters.addAll({'date': date});
    }

    var url = Uri.https('api.nasa.gov', '/planetary/apod', parameters);

    var response = await http.get(url);

    print(response.body);

    adop = ADOPResponse.fromRawJson(response.body);
    isLoading = false;
    notifyListeners();

    debugPrint(
      'Peticiones restantes: ${response.headers['x-ratelimit-remaining']}',
    );
  }
}

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
    copyright: json["copyright"],
    date: DateTime.parse(json["date"]),
    explanation: json["explanation"],
    hdurl: json["hdurl"],
    mediaType: json["media_type"],
    serviceVersion: json["service_version"],
    title: json["title"],
    url: json["url"],
  );
}
