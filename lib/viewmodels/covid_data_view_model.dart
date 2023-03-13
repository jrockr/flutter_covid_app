import 'dart:async';
import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_graphs/models/covid_data.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class CovidDataViewModel {
  final String country;
  late List<CovidDataModel> _data;
  bool _isApiCalled = false;

  final Logger _logger = Logger();
  var client = http.Client();

  CovidDataViewModel({required this.country}) : _data = [];

  Future<void> fetchData() async {
    if (!_isApiCalled) {
      _logger.d("Calling the CovidData API service ");
      try {
        final response = await client
            .get(Uri.parse(
                'https://api.covid19api.com/total/dayone/country/$country'))
            .timeout(const Duration(seconds: 60));

        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body) as List<dynamic>;
          _data = jsonData.map((item) {
            return CovidDataModel(
              date: DateTime.parse(item['Date']),
              confirmed: item['Confirmed'],
              recovered: item['Recovered'],
              deaths: item['Deaths'],
            );
          }).toList();
          _isApiCalled = true;
          _logger.d("ending the CovidData API service ");
        } else {
          throw Exception('Failed to load data');
        }
      } finally {
        client.close();
      }
    } else {
      _logger.d("CovidData API service data already exists");
    }
  }

  // Moved to seperate charts

  List<charts.Series<CovidDataModel, DateTime>> getChartData(String category) {
    switch (category) {
      case 'Confirmed':
        return [
          charts.Series<CovidDataModel, DateTime>(
            id: 'Confirmed',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (CovidDataModel data, _) => data.date,
            measureFn: (CovidDataModel data, _) => data.confirmed,
            data: _data,
          )
        ];
      case 'Recovered':
        return [
          charts.Series<CovidDataModel, DateTime>(
            id: 'Recovered',
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (CovidDataModel data, _) => data.date,
            measureFn: (CovidDataModel data, _) => data.recovered,
            data: _data,
          )
        ];
      case 'Deaths':
        return [
          charts.Series<CovidDataModel, DateTime>(
            id: 'Deaths',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            domainFn: (CovidDataModel data, _) => data.date,
            measureFn: (CovidDataModel data, _) => data.deaths,
            data: _data,
          )
        ];
      default:
        throw ArgumentError('Invalid category: $category');
    }
  }
}
