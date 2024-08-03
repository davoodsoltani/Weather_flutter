
import 'package:floor/floor.dart';
import 'package:justl_flutter/features/feature_bookmark/data/data_source/local/city_dao.dart';
import 'package:justl_flutter/features/feature_bookmark/domain/entities/city_entity.dart';
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 2, entities: [City])
abstract class AppDatabase extends FloorDatabase{
  CityDao get cityDao;
}