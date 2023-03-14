import 'package:covid_graphs/screens/covid_graph_screen.dart';
import 'package:covid_graphs/viewmodels/country_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
              return widgetCountrySearchBox();
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

  @override
  void initState() {
    super.initState();
    _logger.i("initState Home page");
  }

  Widget widgetCountrySearchBox() {
    return Container(
      width: 500,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(),
      ),
      child: Column(children: [
        TypeAheadFormField(
          textFieldConfiguration: const TextFieldConfiguration(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search countries...',
              labelText: 'Country',
            ),
          ),
          suggestionsCallback: (pattern) {
            return widget.viewModel.getCountries().where((country) =>
                country['name'].toLowerCase().contains(pattern.toLowerCase()));
          },
          itemBuilder: (context, country) {
            return ListTile(
              title: Text(country['name']),
            );
          },
          onSuggestionSelected: (country) {
            setState(() {
              _selectedCountry = country['slug'];
            });
          },
          noItemsFoundBuilder: (context) => const SizedBox.shrink(),
        ),
        Text(_selectedCountry ?? 'none'),
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
      ]),
    );
  }
}
