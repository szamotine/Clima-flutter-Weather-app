import 'dart:convert';

import 'package:http/http.dart';

import 'constants.dart';

class WeatherData {
  WeatherData(this.response, this.cityName) {
    data = response.body;
    decodedData = jsonDecode(data);
    latitude = decodedData["latitude"];
    longitude = decodedData["longitude"];
    currentTemperature = decodedData[kCurrentWeather][kTemperature].round();
    weatherCode = decodedData[kCurrentWeather][kWeatherCode];
    windSpeed = decodedData[kCurrentWeather][kWindSpeed];
    weatherCodeDescription = weatherCodesAndIcons[weatherCode]?[0] ?? kDescriptionNotFound;
  }

  final String cityName;
  final Response response;
  late final String data;
  late final double latitude;
  late final double longitude;
  late final dynamic decodedData;
  late final int currentTemperature;
  late final int weatherCode;
  late final double windSpeed;
  late final String weatherCodeDescription;

  void printConditions() {
    print(
        'Current Temperature: $currentTemperature \n Current Wind Speed: $windSpeed \n Current Weather Code: $weatherCode \n Weather Code Description: $weatherCodeDescription');
  }
}
