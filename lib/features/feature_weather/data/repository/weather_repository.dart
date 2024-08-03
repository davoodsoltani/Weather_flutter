import 'package:dio/dio.dart';
import 'package:justl_flutter/core/params/forcast_params.dart';
import 'package:justl_flutter/core/resources/data_state.dart';
import 'package:justl_flutter/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:justl_flutter/features/feature_weather/data/models/current_city_model.dart';
import 'package:justl_flutter/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:justl_flutter/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/suggest_city_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository{
  ApiProvider apiProvider;


  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName) async {
    try{
      final Response response = await apiProvider.callCurrentWeather(cityName) as Response<dynamic>;
      if(response.statusCode == 200){
        final CurrentCityEntity currentCityEntity = CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      }else{
        return const DataFailed("error data fetch");
      }
    }catch(e){
      return const DataFailed("error data fetch:");
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params) async {
    try{
      final Response response = await apiProvider.sendRequest7DaysForecast(params) as Response<dynamic>;
      if(response.statusCode == 200){
        final ForecastDaysEntity forecastDaysEntity = ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      }else{
        return const DataFailed("error data fetch");
      }
    }catch(e){
      return const DataFailed("error data fetch: ");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {

    final Response response = await apiProvider.sendRequestCitySuggestion(cityName as String) as Response<dynamic>;

    final SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);

    return suggestCityEntity.data!;

  }
}
