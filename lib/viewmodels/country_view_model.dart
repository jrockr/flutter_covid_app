import 'dart:async';
import 'dart:convert';

import 'package:covid_graphs/models/country.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class CountryViewModel extends ChangeNotifier {
  bool _isApiCalled = false;
  late List<Country> _countries = [];
  List<Country> get countries => _countries;

  String? _selectedCountrySlug;
  String? get selectedCountrySlug => _selectedCountrySlug;
  var client = http.Client();

  Future<void> fetchCountries() async {
    if (!_isApiCalled) {
      _logger.d("Calling the country API");
      try {
        final response = await client
            .get(Uri.parse('https://api.covid19api.com/countries'))
            .timeout(const Duration(seconds: 60));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          _countries = data.map((item) => Country.fromJson(item)).toList();
          _logger.d("Recieved response country API");
          _isApiCalled = true;
          notifyListeners();
        } else {
          _logger.e("error feching data");
          throw Exception('Failed to load data from API');
        }
      } finally {
        try {
          client.close();
        } on Exception catch (e) {
          _logger.e("client closing error {}", e);
        }
      }
    } else {
      _logger.d("API Already Called");
    }
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    return _countries
        .map((item) => DropdownMenuItem<String>(
              value: item.slug,
              child: Text(item.country),
            ))
        .toList();
  }

  void setSelectedCountry(String country) {
    _selectedCountrySlug = country;
    notifyListeners();
  }
}
