import 'package:flutter/material.dart';
import 'package:covid_graphs/viewmodels/country_view_model.dart';
import 'package:covid_graphs/screens/covid_graph_screen.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class HomePage extends StatefulWidget {
  final CountryViewModel viewModel = CountryViewModel();

  HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _logger.i("initState Home page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covid Data Dashboard'),
      ),
      body: Center(
        child: FutureBuilder(
          future: widget.viewModel.fetchCountries(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(children: [
                DropdownButton<String>(
                  value: _selectedCountry,
                  items: widget.viewModel.getDropdownItems(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedCountry != null
                      ? () {
                          //await widget.viewModel.fetchCovidData(_selectedCountry!);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CovidDataGraphScreen(
                                    country: _selectedCountry.toString())),
                          );
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ]);
            } else if (snapshot.hasError) {
              _logger.e(snapshot.error);
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18.0,
                  ),
                ),
              );
              // return widget informing of error
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
