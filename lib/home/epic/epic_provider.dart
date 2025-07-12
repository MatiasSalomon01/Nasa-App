import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_app/extensions/datetime.dart';
import 'package:nasa_app/home/epic/epic_response.dart';

class EPICProvider extends ChangeNotifier {
  List<EPICResponse> epics = [];
  List<DateTime> allowedDates = [];

  bool? isLoading;

  String? error;

  bool isAllowedDate(DateTime day) {
    return allowedDates.any(
      (f) => f.year == day.year && f.month == day.month && f.day == day.day,
    );
  }

  Future getAllowedDates() async {
    if (allowedDates.isNotEmpty) return;
    var parameters = {'api_key': dotenv.get('NASA_API_KEY')};

    var url = Uri.https('api.nasa.gov', '/EPIC/api/natural/all', parameters);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List<dynamic>;

      for (var map in list) {
        allowedDates.add(DateTime.parse(map["date"]));
      }
    } else {
      debugPrint(response.body);
    }

    allowedDates.sort();

    debugPrint(
      'Peticiones restantes: ${response.headers['x-ratelimit-remaining']}',
    );
  }

  Future getPictures({DateTime? datetime}) async {
    if (epics.isNotEmpty && datetime == null) return;
    isLoading = true;
    notifyListeners();

    var parameters = {'api_key': dotenv.get('NASA_API_KEY')};

    var date = datetime?.toDateQuery() ?? allowedDates.last.toDateQuery();

    var url = Uri.https(
      'api.nasa.gov',
      '/EPIC/api/natural/date/$date',
      parameters,
    );

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List<dynamic>;

      List<EPICResponse> x = [];
      for (var map in list) {
        var model = EPICResponse.fromJson(map);
        x.add(model);
      }

      epics = x;
      error = null;

      await precacheImages(epics.map((e) => e.imageUrl).toList());
    } else {
      debugPrint(response.body);
      error =
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['message'];
    }

    isLoading = false;
    notifyListeners();

    debugPrint(
      'Peticiones restantes: ${response.headers['x-ratelimit-remaining']}',
    );
  }

  Future precacheImages(List<String> imageUrls) async {
    final cacheManager = DefaultCacheManager();

    final urlsNoEnCache = <String>[];

    await Future.forEach(imageUrls, (String url) async {
      final fileInfo = await cacheManager.getFileFromCache(url);
      if (fileInfo == null) {
        urlsNoEnCache.add(url);
      }
    });

    if (urlsNoEnCache.isNotEmpty) {
      debugPrint('Descargando ${urlsNoEnCache.length} imágenes no cacheadas.');

      await Future.wait(
        urlsNoEnCache.map((url) => cacheManager.downloadFile(url)),
      );
    }
  }
}
