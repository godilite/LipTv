import 'package:flutter/material.dart';
import 'package:lipstudio/providers/color_provider.dart';
import 'package:lipstudio/screens/onboarding/components/drawer_paint.dart';
import 'package:lipstudio/screens/onboarding/models/onboard_page_model.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardPage extends StatefulWidget {
  final PageController pageController;
  final OnBoardPageModel pageModel;

  const OnBoardPage({Key key, @required this.pageModel, @required this.pageController}) : super(key: key);
  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage>
  with SingleTickerProviderStateMixin {
    AnimationController animationController;
    Animation<double> heroAnimation;
    Animation<double> borderAnimation;

    @override
    void initState(){
      animationController = 
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
      heroAnimation = Tween<double>(begin: -40, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));
      borderAnimation = Tween<double>(begin: 75, end: 50).animate(
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut));

      animationController.forward(from: 0);
      super.initState();
    }

    @override
    void dispose(){
      animationController.dispose();
      super.dispose();
    }

  _nextButtonPressed(){
    Provider.of<ColorProvider>(context, listen: false).color = widget.pageModel.nextAccentColor;
    widget.pageController.nextPage(
      duration: Duration(milliseconds: 1500), 
      curve: Curves.fastLinearToSlowEaseIn
      );
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget> [
         Container(
            color: widget.pageModel.primeColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                AnimatedBuilder(
                  animation: heroAnimation,
                  builder: (context, child){
                    return Transform.translate(
                      offset: Offset(heroAnimation.value, 0),
                        child: Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: Image.asset(widget.pageModel.imagePath, width: 300,),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                  height: 250,
                  width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.pageModel.caption,
                      style: GoogleFonts.playfairDisplay(textStyle:
                        TextStyle(
                        fontSize: 24,
                        color: widget.pageModel.accentColor.withOpacity(0.6),
                          ),
                          )
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.pageModel.subhead,
                      style: GoogleFonts.playfairDisplay(textStyle: TextStyle(
                        fontSize: 40,
                        color: widget.pageModel.accentColor,
                        fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(widget.pageModel.description,
                      style: TextStyle(
                          fontSize: 16,
                          color: widget.pageModel.accentColor.withOpacity(0.8),
                          letterSpacing: 1
                          ),
                        ),
                      )    
                    ]),
                  ),
                ),
              ]
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
             child: AnimatedBuilder(
              animation: borderAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: DrawerPaint(
                    curveColor: widget.pageModel.accentColor
                  ),
                  child: Container(
                    width: borderAnimation.value,
                    height: double.infinity,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(padding: EdgeInsets.only(bottom: 24.0),
                        child: IconButton(icon: 
                        Icon(
                          Icons.arrow_back, 
                          color: widget.pageModel.primeColor,
                          size: 32,
                          ), 
                        onPressed: _nextButtonPressed
                        ),
                      ),
                    )
                  ),
                );
              }
            )
          )
      ]
    );
  }
}
