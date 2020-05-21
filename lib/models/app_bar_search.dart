import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lipstudio/models/search_model.dart';
import 'package:lipstudio/services/api_service.dart';

class DataSearch extends SearchDelegate<String>{
  Timer _debounce;
    final citiesList = [
      "Abia",
      "Adamawa",
      "Akwa Ibom",
      "Anambra",
      "Bauchi",
      "Bayelsa",
      "Benue",
      "Borno",
      "Cross River",
      "Delta",
      "Ebonyi",
      "Edo",
      "Ekiti",
      "Enugu",
      "FCT - Abuja",
      "Gombe",
      "Imo",
      "Jigawa",
      "Kaduna",
      "Kano",
      "Katsina",
      "Kebbi",
      "Kogi",
      "Kwara",
      "Lagos",
      "Nasarawa",
      "Niger",
      "Ogun",
      "Ondo",
      "Osun",
      "Oyo",
      "Plateau",
      "Rivers",
      "Sokoto",
      "Taraba",
      "Yobe",
      "Zamfara"
    ];
  final recentSearch = [
    "Plateau",
    "Rivers",
    "Sokoto",
    "Taraba",
    "Yobe",
    "Zamfara"
  ];
  
   Future <List<SearchData>> _searchVideos({String query}) async {
     List<SearchData> _result;
         List <SearchData> results = await APIService.instance
            .searchVideos(query: query, channelId: 'UCu3D4nD7n1T3L6aCV_rdlyQ');
            _result = results;
          return _result;  
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [ IconButton(icon: 
    Icon(Icons.clear), 
    onPressed: (){
      query = "";
    }),];
  }

  @override
  Widget buildLeading(BuildContext context) {
      return IconButton(icon: 
        AnimatedIcon(icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation, ), 
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    
    return Card(
      child: Text(query)
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
      List list = new List();

      Future <List> lists()async{
        await _searchVideos(query: query).then((value) => list.add(value));
      }
      List suggestionLists = list;
     List _suggestionLists = suggestionLists;
    return FutureBuilder(
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.none &&
          projectSnap.hasData == null) {
        //print('project snapshot data is: ${projectSnap.data}');
        return Container();
      }
      return ListView.builder(itemBuilder: (context, index)=>ListTile(
        onTap: (){
          query = _suggestionLists[index][index].title.toString();
          showResults(context);
        },
        leading: Icon(Icons.movie_filter),
        title: RichText(text: TextSpan(
          text: _suggestionLists[index][index].title.substring(0, query.length),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [TextSpan(
            text: _suggestionLists[index][index].title.substring(query.length),
            style: TextStyle(color: Colors.grey)
          )]
        )),
        ),
        itemCount: list.length,
      );
      },
      future: lists(),
    );
  }

}