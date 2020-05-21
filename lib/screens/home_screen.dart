import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:lipstudio/models/app_bar_search.dart';
import 'package:lipstudio/screens/movie_page.dart';
import 'package:lipstudio/screens/setting.dart';
import 'package:lipstudio/screens/tv_page.dart';

import 'home_page.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey _bottomNavigationKey = GlobalKey();
   
  List <Widget> _navitems = [
    IconButton(icon: Icon(Icons.home, color: Colors.white, size: 20,), onPressed: null),
    IconButton(icon: Icon(Icons.movie, color: Colors.white, size: 20,), onPressed: null),
    IconButton(icon: Icon(Icons.live_tv, color: Colors.white, size: 20,),onPressed: null),
    IconButton(icon: Icon(Icons.settings, color: Colors.white, size: 20,),onPressed: null)
  ];
  PageController pageController = PageController(
    initialPage: 0,
  );
 List<Widget> _introPages = [
                HomePage(),
                MoviePage(),
                TvPage(),
                Setting()
              ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0.0,
        title: ListTile(
          leading: Image(
          image: new AssetImage("images/liptv.png"),
          width: 40,
          height: 50,
          color: null,
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          ),
         title: Image(image: AssetImage('images/banner.png'),
         height: 25,),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
          showSearch(context: context, delegate: DataSearch());
          }),
        ], 
      ),
      body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount:4,
            onPageChanged: (int page){
              final CurvedNavigationBarState navBarState =
                  _bottomNavigationKey.currentState;
              navBarState.setPage(page);
            },
            itemBuilder: (context, index) {
              return _introPages[index];
            },
          ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        items: _navitems, 
        index: 0, 
        animationDuration: Duration(milliseconds: 500),
        color: Color(0xFF8b0404),
        backgroundColor: Colors.transparent,
        height: 47,
        onTap: (index){
          setState(() {
            pageController.jumpToPage(index);
          });
        },
        ),
      ),
    );
  }
}
