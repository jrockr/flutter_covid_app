class CovidDataModel {
  final DateTime date;
  final int confirmed;
  final int recovered;
  final int deaths;

  CovidDataModel({
    required this.date,
    required this.confirmed,
    required this.recovered,
    required this.deaths,
  });
}
