import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ADOPScreen extends StatefulWidget {
  const ADOPScreen({super.key});

  @override
  State<ADOPScreen> createState() => _ADOPScreenState();
}

class _ADOPScreenState extends State<ADOPScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () async => await context.read<ADOPProvider>().getPicture(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ADOPProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Astronomy Picture of the Day')),
      body: provider.isLoading || provider.adop == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1000),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  // alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: provider.adop!.url,
                          scale: 16 / 9,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        provider.adop!.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        provider.adop!.explanation,
                        textAlign: TextAlign.justify,
                      ),
                      Text('Published: ${provider.adop!.date.toString()}'),
                      Text(provider.adop!.copyright ?? ''),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class ADOPProvider extends ChangeNotifier {
  ADOPResponse? adop;

  bool isLoading = false;

  Future getPicture() async {
    if (adop != null) return;
    isLoading = true;
    notifyListeners();

    var url = Uri.https('api.nasa.gov', '/planetary/apod', {
      'api_key': dotenv.get('NASA_API_KEY'),
    });

    var response = await http.get(url);

    isLoading = false;
    adop = ADOPResponse.fromRawJson(response.body);
    notifyListeners();

    print('Peticiones restantes: ${response.headers['x-ratelimit-remaining']}');
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
