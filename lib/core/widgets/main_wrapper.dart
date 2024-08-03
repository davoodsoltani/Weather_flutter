import 'package:flutter/material.dart';
import 'package:justl_flutter/core/widgets/app_background.dart';
import 'package:justl_flutter/core/widgets/bottom_nav.dart';
import 'package:justl_flutter/features/feature_weather/presentation/screens/home_screen.dart';
import 'package:justl_flutter/features/feature_bookmark/presentation/screens/bookmark_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({super.key});

  final PageController pageController = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget = [
      const HomeScreen(),
      BookmarkScreen(pageController: pageController,),
    ];

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(controller: pageController,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppBackground.getBackGroundImage(),
            fit: BoxFit.cover
          )

        ),
        height: height,
        child: PageView(
          controller: pageController,
          children: pageViewWidget,
        ),
      ),
    );
  }
}
