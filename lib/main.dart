import 'package:flutter/material.dart';
import 'package:lipstudio/providers/color_provider.dart';
import 'package:lipstudio/providers/theme.dart';
import 'package:lipstudio/screens/home_screen.dart';
import 'package:lipstudio/screens/onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (_) => ThemeChanger(ThemeData.light().copyWith(primaryColor: Colors.white, 
                scaffoldBackgroundColor: Color(0xfff8f8ff), accentColor: Colors.red.shade900, 
                appBarTheme: AppBarTheme(brightness: Brightness.light,  
                color: Color(0xfffffff), actionsIconTheme: IconThemeData(color: Colors.black54))), Brightness.light),
      child: new MaterialAppWithTheme(), 
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: 'LipTv',
      debugShowCheckedModeBanner: false,
      theme: theme.getTheme(),
      home: GoOnboarding(),
      routes: {
        "/home": (_) => new HomeScreen(),
      },
    );
  }
}

class GoOnboarding extends StatefulWidget {
  
  @override
  _GoOnboardingState createState() => _GoOnboardingState();
}

class _GoOnboardingState extends State<GoOnboarding> {
   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _firstLunch = false;

  Future<void> _checkLunch() async {
    final SharedPreferences prefs = await _prefs;
    final bool firstLunch = prefs.getBool('first') ?? true;
    if (firstLunch) {
      prefs.setBool("first", false);    
    }

    setState(() {
      _firstLunch = firstLunch;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLunch();
  }

  @override
  Widget build(BuildContext context) {
    return _firstLunch ? Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => ColorProvider(),
        child: OnBoarding()
      ),
    ) : HomeScreen();
  }
}