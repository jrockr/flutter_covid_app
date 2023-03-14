import 'package:covid_graphs/screens/home_screen.dart';
import 'package:covid_graphs/viewmodels/country_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CovidDataApp());
}

class CovidDataApp extends StatefulWidget {
  const CovidDataApp({super.key});

  @override
  CovidDataAppState createState() => CovidDataAppState();
}

class CovidDataAppState extends State<CovidDataApp> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CountryViewModel(),
        child: MaterialApp(
          title: 'Covid Data',
          theme: isDarkModeEnabled ? ThemeData.dark() : ThemeData.light(),
          home: HomePage(toggleTheme: toggleTheme),
        ));
  }

  void toggleTheme() {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
  }
}
