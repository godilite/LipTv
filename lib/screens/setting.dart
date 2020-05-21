import 'package:flutter/material.dart';
import 'package:lipstudio/providers/theme.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
     ThemeChanger _themeChanger = Provider.of<ThemeChanger>(context);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
             FlatButton(
                color: Theme.of(context).accentColor,
                child: Text('Dark Theme'),
                onPressed: () => _themeChanger.setTheme(ThemeData.dark().copyWith(primaryColor: Colors.red, 
                scaffoldBackgroundColor: Color(0xff121212), accentColor: Colors.red[900], 
                buttonColor: Color(0xff1f1f1f), appBarTheme: AppBarTheme(brightness: Brightness.dark, 
                color: Color(0xff5a5a5a), actionsIconTheme: IconThemeData(color: Colors.white))), Brightness.dark),
                ),
            FlatButton(
                child: Text('Light Theme'),
                onPressed: () => _themeChanger.setTheme(ThemeData.light().copyWith(primaryColor: Colors.white, 
                scaffoldBackgroundColor: Color(0xfff8f8ff), accentColor: Colors.red.shade900, 
                appBarTheme: AppBarTheme(brightness: Brightness.light,  
                color: Color(0xfffffff), actionsIconTheme: IconThemeData(color: Colors.black54))
                ,), Brightness.light),),

            ]
          );
  }
}