import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:justl_flutter/locator.dart';

import 'core/widgets/main_wrapper.dart';
import 'locator.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await setup();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => locator<HomeBloc>()),
        BlocProvider(create: (_) => locator<BookmarkBloc>()),
      ],
      child: MainWrapper(),
    ),
  ));
}

