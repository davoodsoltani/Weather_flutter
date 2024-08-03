import 'package:justl_flutter/features/feature_weather/domain/entities/current_city_entity.dart';

class CurrentCityModel extends CurrentCityEntity{
  const CurrentCityModel({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
  }) : super(
      coord: coord,
      weather: weather,
      base: base,
      main: main,
      visibility: visibility,
      wind: wind,
      clouds: clouds,
      dt: dt,
      sys: sys,
      timezone: timezone,
      id: id,
      name: name,
      cod: cod
  );

  factory CurrentCityModel.fromJson(dynamic json) {
    List<Weather> weather = [];
    if (json['weather'] != null) {
      json['weather'].forEach((v) {
        weather.add(Weather.fromJson(v));
      });
    }

    return CurrentCityModel(
        coord: json['coord'] != null ? Coord.fromJson(json['coord']) : null,
        weather: weather,
        base: json['base'] as String,
        main: json['main'] != null ? Main.fromJson(json['main']) : null,
        visibility: json['visibility'] as int,
        wind: json['wind'] != null ? Wind.fromJson(json['wind']) : null,
        clouds: json['clouds'] != null ? Clouds.fromJson(json['clouds']) : null,
        dt: json['dt'] as int,
        sys: json['sys'] != null ? Sys.fromJson(json['sys']) : null,
        timezone: json['timezone'] as int,
        id: json['id'] as int,
        name: json['name'] as String,
        cod: json['cod'] as int
    );
  }
}

/// type : 2
/// id : 47737
/// country : "IR"
/// sunrise : 1654391936
/// sunset : 1654444014

class Sys {
  Sys({
    int? type,
    int? id,
    String? country,
    int? sunrise,
    int? sunset,}){
    _type = type;
    _id = id;
    _country = country;
    _sunrise = sunrise;
    _sunset = sunset;
  }

  Sys.fromJson(dynamic json) {
    _type = json['type'] as int;
    _id = json['id'] as int;
    _country = json['country'] as String;
    _sunrise = json['sunrise'] as int;
    _sunset = json['sunset'] as int;
  }
  int? _type;
  int? _id;
  String? _country;
  int? _sunrise;
  int? _sunset;

  int? get type => _type;
  int? get id => _id;
  String? get country => _country;
  int? get sunrise => _sunrise;
  int? get sunset => _sunset;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['id'] = _id;
    map['country'] = _country;
    map['sunrise'] = _sunrise;
    map['sunset'] = _sunset;
    return map;
  }

}

/// all : 0

class Clouds {
  Clouds({
    int? all,}){
    _all = all;
  }

  Clouds.fromJson(dynamic json) {
    _all = json['all'] as int;
  }
  int? _all;

  int? get all => _all;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = _all;
    return map;
  }

}

/// speed : 3.09
/// deg : 180

class Wind {
  Wind({
    double? speed,
    int? deg,}){
    _speed = speed;
    _deg = deg;
  }

  Wind.fromJson(dynamic json) {
    _speed = json['speed'].toDouble() as double;
    _deg = json['deg'] as int;
  }
  double? _speed;
  int? _deg;

  double? get speed => _speed;
  int? get deg => _deg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['speed'] = _speed;
    map['deg'] = _deg;
    return map;
  }

}

/// temp : 29.84
/// feels_like : 28.01
/// temp_min : 29.84
/// temp_max : 29.99
/// pressure : 1017
/// humidity : 13

class Main {
  Main({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,}){
    _temp = temp;
    _feelsLike = feelsLike;
    _tempMin = tempMin;
    _tempMax = tempMax;
    _pressure = pressure;
    _humidity = humidity;
  }

  Main.fromJson(dynamic json) {
    _temp = json['temp'].toDouble() as double;
    _feelsLike = json['feels_like'].toDouble() as double;
    _tempMin = json['temp_min'].toDouble() as double;
    _tempMax = json['temp_max'].toDouble() as double;
    _pressure = json['pressure'] as int;
    _humidity = json['humidity'] as int;
  }
  double? _temp;
  double? _feelsLike;
  double? _tempMin;
  double? _tempMax;
  int? _pressure;
  int? _humidity;

  double? get temp => _temp;
  double? get feelsLike => _feelsLike;
  double? get tempMin => _tempMin;
  double? get tempMax => _tempMax;
  int? get pressure => _pressure;
  int? get humidity => _humidity;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['temp'] = _temp;
    map['feels_like'] = _feelsLike;
    map['temp_min'] = _tempMin;
    map['temp_max'] = _tempMax;
    map['pressure'] = _pressure;
    map['humidity'] = _humidity;
    return map;
  }

}

/// id : 800
/// main : "Clear"
/// description : "clear sky"
/// icon : "01d"

class Weather {
  Weather({
    int? id,
    String? main,
    String? description,
    String? icon,}){
    _id = id;
    _main = main;
    _description = description;
    _icon = icon;
  }

  Weather.fromJson(dynamic json) {
    _id = json['id'] as int;
    _main = json['main'] as String;
    _description = json['description'] as String;
    _icon = json['icon'] as String;
  }
  int? _id;
  String? _main;
  String? _description;
  String? _icon;

  int? get id => _id;
  String? get main => _main;
  String? get description => _description;
  String? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['main'] = _main;
    map['description'] = _description;
    map['icon'] = _icon;
    return map;
  }

}

/// lon : 51.4215
/// lat : 35.6944

class Coord {
  Coord({
    double? lon,
    double? lat,}){
    _lon = lon;
    _lat = lat;
  }

  Coord.fromJson(dynamic json) {
    _lon = json['lon'].toDouble() as double;
    _lat = json['lat'].toDouble() as double;
  }
  double? _lon;
  double? _lat;

  double? get lon => _lon;
  double? get lat => _lat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lon'] = _lon;
    map['lat'] = _lat;
    return map;
  }

}
