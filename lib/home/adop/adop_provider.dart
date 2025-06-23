import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_app/extensions/datetime.dart';
import 'package:nasa_app/home/adop/adop_response.dart';

class ADOPProvider extends ChangeNotifier {
  ADOPResponse? adop;

  bool isLoading = false;

  String? date;
  String? error;

  Future getPicture({DateTime? date}) async {
    isLoading = true;
    this.date = date?.toDateQuery();
    notifyListeners();

    var parameters = {'api_key': dotenv.get('NASA_API_KEY')};

    if (date != null) {
      parameters.addAll({'date': date.toDateQuery()});
    }

    var url = Uri.https('api.nasa.gov', '/planetary/apod', parameters);

    var response = await http.get(url);

    if (response.statusCode == 200) {
      adop = ADOPResponse.fromRawJson(response.body);
      error = null;
    } else {
      error =
          (jsonDecode(response.body)
              as Map<String, dynamic>)['error']['message'];
      debugPrint(response.body);
    }

    isLoading = false;
    notifyListeners();

    debugPrint(
      'Peticiones restantes: ${response.headers['x-ratelimit-remaining']}',
    );
  }
}
