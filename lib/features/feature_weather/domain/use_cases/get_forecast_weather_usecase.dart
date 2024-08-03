import 'package:justl_flutter/core/params/forcast_params.dart';
import 'package:justl_flutter/core/usecase/use_case.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/repository/weather_repository.dart';

import '../../../../core/resources/data_state.dart';

class GetForecastWeatherUseCase extends UseCase<DataState<ForecastDaysEntity>, ForecastParams>{
  final WeatherRepository weatherRepository;

  GetForecastWeatherUseCase(this.weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams param) {
    return weatherRepository.fetchForecastWeatherData(param);
  }

}