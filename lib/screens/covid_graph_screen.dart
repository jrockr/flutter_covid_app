import 'package:charts_flutter/flutter.dart' as charts;
import 'package:covid_graphs/viewmodels/covid_data_view_model.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class CovidDataGraphScreen extends StatefulWidget {
  final String country;
  final bool isDarkModeEnabled;

  const CovidDataGraphScreen(
      {super.key, required this.country, required this.isDarkModeEnabled});

  @override
  CovidDataGraphScreenState createState() => CovidDataGraphScreenState();
}

class CovidDataGraphScreenState extends State<CovidDataGraphScreen> {
  late final CovidDataViewModel _viewModel;
  String category = 'Confirmed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid Data Graphs for ${widget.country}'),
      ),
      body: FutureBuilder(
        future: _viewModel.fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return widgetChart();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18.0,
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    _logger.i(widget.country);
    super.initState();
    _viewModel = CovidDataViewModel(country: widget.country);
  }

  Widget widgetChart() {
    return Container(
      padding: const EdgeInsets.all(3.0),
      color: widget.isDarkModeEnabled
          ? Colors.blueGrey[100]
          : Colors.deepOrange[
              100], // Adjust the color based on the current theme mode,
      // Adjust the color based on the current theme mode
      child: Column(
        children: [
          DropdownButton<String>(
            value: category,
            onChanged: (value) {
              setState(() {
                category = value!;
              });
            },
            items: <String>['Confirmed', 'Recovered', 'Deaths']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: charts.TimeSeriesChart(
              _viewModel.getChartData(category),
              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
