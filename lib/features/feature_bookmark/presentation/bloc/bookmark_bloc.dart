import 'package:bloc/bloc.dart';
import 'package:justl_flutter/core/resources/data_state.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/entities/city_entity.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/use_cases/get_city_usecase.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/bookmark_state.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/delete_city_status.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/save_city_status.dart';
import 'package:meta/meta.dart';

part 'bookmark_event.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  GetCityUseCase getCityUseCase;
  SaveCityUseCase saveCityUseCase;
  GetAllCityUseCase getAllCityUseCase;
  DeleteCityUseCase deleteCityUseCase;

  BookmarkBloc(
      this.getCityUseCase,
      this.saveCityUseCase,
      this.getAllCityUseCase,
      this.deleteCityUseCase
      ) : super(BookmarkState(
      getCityStatus: GetCityLoading(),
      saveCityStatus: SaveCityInitial(),
      getAllCityStatus: GetAllCityLoading(),
      deleteCityStatus: DeleteCityInitial()
  )) {

    /// City Delete Event
    on<DeleteCityEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(newDeleteCityStatus: DeleteCityLoading()));

      final DataState dataState = await deleteCityUseCase(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newDeleteCityStatus: DeleteCityCompleted(dataState.data as String)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newDeleteCityStatus: DeleteCityError(dataState.error)));
      }
    });

    /// get All city
    on<GetAllCityEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newGetAllCityStatus: GetAllCityLoading()));

      DataState dataState = await getAllCityUseCase(NoParams());

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newGetAllCityStatus: GetAllCityCompleted(dataState.data as List<City>)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newGetAllCityStatus: GetAllCityError(dataState.error)));
      }
    });


    /// get city By name event
    on<GetCityByNameEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newCityStatus: GetCityLoading()));

      DataState dataState = await getCityUseCase(event.cityName);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newCityStatus: GetCityCompleted(dataState.data as City)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newCityStatus: GetCityError(dataState.error)));
      }
    });


    /// Save City Event
    on<SaveCwEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newSaveStatus: SaveCityLoading()));

      DataState dataState = await saveCityUseCase(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newSaveStatus: SaveCityCompleted(dataState.data as City)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newSaveStatus: SaveCityError(dataState.error)));
      }
    });

    /// set to init again SaveCity
    on<SaveCityInitialEvent>((event, emit) async {
      emit(state.copyWith(newSaveStatus: SaveCityInitial()));
    });

  }
}