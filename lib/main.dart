import 'package:flutter/material.dart';
import 'package:covid_graphs/viewmodels/country_view_model.dart';
import 'package:covid_graphs/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CovidDataApp());
}

class CovidDataApp extends StatelessWidget {
  const CovidDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CountryViewModel(),
      child: MaterialApp(
        title: 'Covid Data',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: HomePage(),
      ),
    );
  }
}
