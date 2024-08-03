import 'package:animated_search/animated_search.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:justl_flutter/core/params/forcast_params.dart';
import 'package:justl_flutter/core/widgets/app_background.dart';
import 'package:justl_flutter/core/widgets/dot_loading_widget.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:justl_flutter/features/feature_weather/data/models/forecast_days_model.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/entities/forecast_days_entity.dart';
import 'package:justl_flutter/features/feature_weather/domain/use_cases/get_suggest_city_usecase.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:justl_flutter/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:justl_flutter/features/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:justl_flutter/features/feature_weather/presentation/widgets/day_weather_view.dart';
import 'package:justl_flutter/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase =
      GetSuggestionCityUseCase(locator());
  String cityName = "Tehran";
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: height * 0.02,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Row(
            children: [
              Expanded(
                child: AnimatedSearch(
                  width: 0.99,
                  textEditingController: textEditingController,
                  startIcon: Icons.search,
                  closeIcon: Icons.close,
                  iconColor: Colors.white,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    border: InputBorder.none,
                  ),
                  onChanged: (String value) {
                    textEditingController.text = value;
                    if (value.isEmpty) {
                      BlocProvider.of<HomeBloc>(context)
                          .add(LoadCwEvent("Tehran"));
                    } else {
                      BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(value));
                    }
                  },
                ),
              ),

              const SizedBox(width: 10,),

              BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (previous, current){
                    if(previous.cwStatus == current.cwStatus){
                      return false;
                    }
                    return true;
                  },
                  builder: (context, state){
                    /// show Loading State for Cw
                    if (state.cwStatus is CwLoading) {
                      return const CircularProgressIndicator();
                    }

                    /// show Error State for Cw
                    if (state.cwStatus is CwError) {
                      return IconButton(
                        onPressed: (){
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   content: Text("please load a city!"),
                          //   behavior: SnackBarBehavior.floating, // Add this line
                          // ));
                        },
                        icon: const Icon(Icons.error,color: Colors.white,size: 35),);
                    }

                    if(state.cwStatus is CwCompleted){
                      final CwCompleted cwComplete = state.cwStatus as CwCompleted;
                      BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwComplete.currentCityEntity.name!));
                      return BookMarkIcon(name: cwComplete.currentCityEntity.name!);
                    }

                    return Container();

                  }
              ),
            ],
          ),
        ),

        /// main ui
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) {
            if (previous.cwStatus == current.cwStatus) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            if (state.cwStatus is CwLoading) {
              return const Expanded(child: DotLoadingWidget());
            }

            if (state.cwStatus is CwCompleted) {
              final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
              final CurrentCityEntity currentCityEntity =
                  cwCompleted.currentCityEntity;

              final ForecastParams forecastParams = ForecastParams(
                  currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!,);

              BlocProvider.of<HomeBloc>(context)
                  .add(LoadFwEvent(forecastParams));

              return Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      width: width,
                      height: 400,
                      child: PageView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          allowImplicitScrolling: true,
                          controller: _pageController,
                          itemCount: 2,
                          itemBuilder: (context, position) {
                            if (position == 0) {
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    currentCityEntity.name ?? "-",
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                  Text(
                                    currentCityEntity.weather?[0].description ??
                                        "-",
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.grey,),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppBackground.setIconForMain(currentCityEntity
                                          .weather?[0].description ??
                                      "-"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${currentCityEntity.main?.temp?.round()}\u00B0",
                                    style: const TextStyle(
                                        fontSize: 50, color: Colors.white,),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            "max",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${currentCityEntity.main?.tempMax?.round()}\u00B0",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        child: Container(
                                          color: Colors.grey,
                                          width: 2,
                                          height: 40,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            "min",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${currentCityEntity.main?.tempMin?.round()}\u00B0",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                color: Colors.amber,
                              );
                            }
                          },),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: 2,
                        effect: const ExpandingDotsEffect(
                          dotWidth: 10,
                          dotHeight: 10,
                          spacing: 5,
                          activeDotColor: Colors.white,
                        ),
                        onDotClicked: (index) => _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.bounceOut),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Container(
                        color: Colors.grey,
                        width: width,
                        height: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10.0)),
                    Center(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (BuildContext context, state) {
                          if (state.fwStatus is FwLoading) {
                            return const DotLoadingWidget();
                          }

                          if (state.fwStatus is FwCompleted) {
                            final FwCompleted fwCompleted =
                                state.fwStatus as FwCompleted;
                            final ForecastDaysEntity forecastDaysEntity =
                                fwCompleted.forecastDaysEntity;
                            final List<Daily> mainDaily =
                                forecastDaysEntity.daily!;

                            return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 8,
                              itemBuilder: (BuildContext context, int index) {
                                return DaysWeatherView(
                                  daily: mainDaily[index],
                                );
                              },
                            );
                          }

                          if (state.fwStatus is FwError) {
                            final FwError fwError = state.fwStatus as FwError;
                            return Center(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(fwError.message,
                                      style:
                                          const TextStyle(color: Colors.white),),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            );
                          }

                          return Container();
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: Container(
                        color: Colors.grey,
                        width: width,
                        height: 2,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              );
            }

            if (state.cwStatus is CwError) {
              return const Center(
                  child:
                      Text("error...", style: TextStyle(color: Colors.white)),);
            }

            return Container();
          },
        ),
      ],
    ),);
  }
}
