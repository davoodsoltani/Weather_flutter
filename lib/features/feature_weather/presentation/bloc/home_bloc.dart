import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:justl_flutter/core/params/forcast_params.dart';
import 'package:justl_flutter/core/resources/data_state.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:justl_flutter/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase getForecastWeatherUseCase;

  HomeBloc(this.getCurrentWeatherUseCase, this.getForecastWeatherUseCase) : super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {

    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));

      final DataState dataState = await getCurrentWeatherUseCase(event.cityName);

      if(dataState is DataSuccess){
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data as CurrentCityEntity)));
      }

      if(dataState is DataFailed){
        emit(state.copyWith(newCwStatus: CwError(dataState.error ?? "null error")));
      }
    });

    on<LoadFwEvent>((event, emit) async {
      emit(state.copyWith(newFwStatus: FwLoading()));

      final DataState dataState = await getForecastWeatherUseCase(event.params);

      if(dataState is DataSuccess){
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data as ForecastDaysEntity)));
      }

      if(dataState is DataFailed){
        emit(state.copyWith(newFwStatus: FwError(dataState.error ?? "null error")));
      }
    });


  }
}
