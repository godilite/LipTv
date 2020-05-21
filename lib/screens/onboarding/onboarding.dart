import 'package:flutter/material.dart';
import 'package:lipstudio/providers/color_provider.dart';
import 'package:lipstudio/screens/onboarding/components/onboarding_page.dart';
import 'package:lipstudio/screens/onboarding/components/page_view_indicator.dart';
import 'package:lipstudio/screens/onboarding/data/onboard_data.dart';
import 'package:provider/provider.dart';

class OnBoarding extends StatelessWidget {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    ColorProvider colorProvider = Provider.of<ColorProvider>(context);
    return Stack(
      children: <Widget> [
        PageView.builder(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: onboardData.length,
            itemBuilder: (context, int index) {
              return OnBoardPage(
                pageController: pageController,
                pageModel: onboardData[index],
              );
            },
        ),
        Container(
          width: double.infinity,
          height: 70,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 32.0),
                  child: Text(
                    'LipTv',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                        color: colorProvider.color,
                      ),
                    ),
                  ),
                 Padding(
                  padding: EdgeInsets.only(right: 32.0),
                  child: GestureDetector(
                    onTap: ()=>Navigator.pushReplacementNamed(context, "/home"),
                      child: Text(
                      'Skip',
                        style: TextStyle(
                          color: colorProvider.color,
                        ),
                      ),
                  ),
                  ),
              ],
            )
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80, left: 40),
            child: PageViewIndicator(
              controller: pageController,
              itemCount: onboardData.length,
              color: colorProvider.color
            ),
            )
        )
      ]
    );
  }
}